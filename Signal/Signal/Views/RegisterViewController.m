//
//  RegisterViewController.m
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "SignalTableViewController.h"
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>

@interface RegisterViewController()
@property(nonatomic,readonly) NSManagedObjectContext *managedContext;

@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordLabel;

- (IBAction)registerBtn:(UIButton *)sender;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"Register";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtn:(UIButton *)sender {
    if (self.passwordLabel.text != self.repeatPasswordLabel.text) {
        [self showAlert:@"Warning" :@"Passwords do not match."];
    }
    
    if (self.usernameLabel.text.length == 0 || self.passwordLabel.text.length == 0 || self.repeatPasswordLabel.text.length == 0) {
        
        [self showAlert:@"Warning" :@"Fields cannot be empty."];
    } else {
        PFUser *user = [PFUser user];
        user.username = self.usernameLabel.text;
        user.password = self.passwordLabel.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSString *storyBoardId = @"SignalTable";
                
                SignalTableViewController *signalTableVC =
                [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
                [self.navigationController pushViewController:signalTableVC animated:YES];
                
                [self saveToCoreData];
                
            } else {   NSString *errorString = [error userInfo][@"error"];
                [self showAlert:@"Error" :errorString];
            }
        }];
        
    }
}

-(void)saveToCoreData{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Profile" inManagedObjectContext:self.managedContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        NSManagedObject* fetchetItem = [fetchedObjects objectAtIndex:0];
        [fetchetItem setValue:self.usernameLabel.text forKey:@"name"];
    } else {
        NSManagedObject *profile = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Profile"
                                    inManagedObjectContext:self.managedContext];
        
        [profile setValue:self.usernameLabel.text forKey:@"name"];
        
        if (![self.managedContext save:&error]) {
            NSLog(@"Error saving: %@", [error localizedDescription]);
        }
    }
}

-(NSManagedObjectContext*)managedContext{
    NSManagedObjectContext *managedContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return managedContext;
}

- (void) showAlert: (NSString*) title :(NSString*) message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
