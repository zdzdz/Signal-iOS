//
//  SignalTableViewController.h
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TelerikUI/TelerikUI.h>

@interface SignalTableViewController : UIViewController <TKSideDrawerDelegate>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *name;
@end
