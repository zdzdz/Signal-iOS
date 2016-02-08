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
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *categoryStr;
@property (strong, nonatomic) NSString *authorStr;
@property (strong, nonatomic) NSString *addedOnStr;
@property (strong, nonatomic) NSString *descriptionStr;

@end
