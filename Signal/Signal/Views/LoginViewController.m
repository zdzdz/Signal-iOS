//
//  LoginViewController.m
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "LoginViewController.h"
#import "AppDelegate.h"

#import "RegisterViewController.h"
#import "SignalTableViewController.h"

#import <Parse/Parse.h>

@interface LoginViewController()
@property(nonatomic,readonly) NSManagedObjectContext *managedContext;

@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;

- (IBAction)navigateToRegister:(UIButton *)sender;
- (IBAction)loginBtn:(UIButton *)sender;
@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigateToRegister:(UIButton *)sender {
    NSString *storyBoardId = @"Registration";
    
    RegisterViewController *registrationVC =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:registrationVC animated:YES];
}

- (IBAction)loginBtn:(UIButton *)sender {
    
    if (self.usernameLabel.text.length == 0 || self.passwordLabel.text.length == 0) {
        [self showAlert:@"Warning" :@"Fields cannot be empty."];
    } else {
        [PFUser logInWithUsernameInBackground:self.usernameLabel.text
                                     password:self.passwordLabel.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                NSString *storyBoardId = @"SignalTable";
                                                
                                                SignalTableViewController *signalTableVC =
                                                [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
                                                [self.navigationController pushViewController:signalTableVC animated:YES];
                                                
                                                [self saveToCoreData];
                                            } else {
                                                NSString *errorString = [error userInfo][@"error"];
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
        [self.managedContext save:&error];
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
