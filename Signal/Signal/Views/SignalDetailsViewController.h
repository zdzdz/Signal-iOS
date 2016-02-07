//
//  SignalDetailsViewController.h
//  Signal
//
//  Created by Sam Son on 2/6/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "FSImageViewerViewController.h"

@interface SignalDetailsViewController : UIViewController <CLLocationManagerDelegate, FSImageViewerViewControllerDelegate>

@property(strong, nonatomic) FSImageViewerViewController *imageViewController;

@end
