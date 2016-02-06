//
//  SignalDetailsViewController.m
//  Signal
//
//  Created by Sam Son on 2/6/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import "SignalDetailsViewController.h"

@interface SignalDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAddedLabel;

@property (weak, nonatomic) IBOutlet UITextField *numberLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
- (IBAction)phoneButton:(UIButton *)sender;
- (IBAction)emailButton:(UIButton *)sender;

@end

@implementation SignalDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)phoneButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", self.numberLabel.text]]];
}

- (IBAction)emailButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", self.emailLabel.text]]];
}
@end
