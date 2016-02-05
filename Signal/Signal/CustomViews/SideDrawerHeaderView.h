//
//  SideDrawerHeaderView.h
//  Signal
//
//  Created by Sam Son on 2/5/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKSideDrawer;

@interface SideDrawerHeaderView : UIView

- (instancetype)initWithButton:(BOOL)addButton target:(id)target selector:(SEL)selector;

@end
