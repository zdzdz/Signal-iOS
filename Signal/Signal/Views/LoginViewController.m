//
//  LoginViewController.m
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import "LoginViewController.h"

#import "RegisterViewController.h"

@interface LoginViewController()
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;

- (IBAction)navigateToRegister:(UIButton *)sender;
- (IBAction)loginBtn:(UIButton *)sender;
@end

@implementation LoginViewController

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
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"Fields cannot be empty."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end
