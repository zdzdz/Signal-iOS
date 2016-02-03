//
//  RegisterViewController.m
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import "RegisterViewController.h"

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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"Passwords do not match."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if (self.usernameLabel.text.length == 0 || self.passwordLabel.text.length == 0 || self.repeatPasswordLabel.text.length == 0) {
        
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
