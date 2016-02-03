//
//  RegisterViewController.m
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController()
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
        [self showAlert:@"Passwords do not match."];
    }
    
    if (self.usernameLabel.text.length == 0 || self.passwordLabel.text.length == 0 || self.repeatPasswordLabel.text.length == 0) {
        
        [self showAlert:@"Fields cannot be empty."];
    } else {
        
        PFUser *user = [PFUser user];
        user.username = self.usernameLabel.text;
        user.password = self.passwordLabel.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self showAlert:@"Fields cannot be empty."];
            } else {   NSString *errorString = [error userInfo][@"error"];
                [self showAlert:errorString];
            }
        }];
    }
}

- (void) showAlert: (NSString*) message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
