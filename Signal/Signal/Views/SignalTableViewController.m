//
//  SignalTableViewController.m
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import "SignalTableViewController.h"
#import "Parse/Parse.h"

#import "AddSignalViewController.h"

@interface SignalTableViewController()
- (IBAction)LogOut:(UIButton *)sender;

@end

@implementation SignalTableViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
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
@end
