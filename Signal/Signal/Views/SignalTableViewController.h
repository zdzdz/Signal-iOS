//
//  SignalTableViewController.h
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TelerikUI/TelerikUI.h>

@interface SignalTableViewController : UIViewController <TKSideDrawerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *name;

@property (nonatomic,strong) TKSideDrawerView *sideDrawerView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UITextField *searchField;
@end
