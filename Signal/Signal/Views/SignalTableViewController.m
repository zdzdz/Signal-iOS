//
//  SignalTableViewController.m
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//
#import <CoreData/CoreData.h>

#import "SignalTableViewController.h"
#import "Parse/Parse.h"

#import "AddSignalViewController.h"
#import "RegisterViewController.h"

#import "AppDelegate.h"

@interface SignalTableViewController()
@property(nonatomic,readonly) NSManagedObjectContext *managedContext;
@property (weak, nonatomic) IBOutlet UIButton *buttonName;

- (IBAction)LogOut:(UIButton *)sender;


@end

@implementation SignalTableViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
    
    @try{
        NSArray *viewControllers = self.navigationController.viewControllers;
        UIViewController *rootViewController = (UIViewController *)[viewControllers objectAtIndex:viewControllers.count - 2];
        
        
        if([rootViewController isKindOfClass:[RegisterViewController class]]){
            [self showAlert:@"Welcome" :@"You have successfully registered."];
        }
    } @catch(NSException *exception){
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addBarButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
     target:self
     action:@selector(showAddButton)];
    
    self.title = @"All Signals";
    self.navigationItem.rightBarButtonItem = addBarButton;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Profile" inManagedObjectContext:self.managedContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *userName in fetchedObjects) {
       // NSLog(@"Name: %@", [userName valueForKey:@"name"]);
        [self.buttonName setTitle:[userName valueForKey:@"name"] forState: UIControlStateNormal];
    }
}

-(void) showAddButton {
    NSString *storyBoardId = @"AddSignal";
    
    AddSignalViewController *addSignalVC =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:addSignalVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogOut:(UIButton *)sender {
    [PFUser logOut];
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

-(NSManagedObjectContext*)managedContext{
    NSManagedObjectContext *managedContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return managedContext;
}

@end
