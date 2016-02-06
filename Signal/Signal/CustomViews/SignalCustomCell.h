//
//  SignalCustomCell.h
//  Signal
//
//  Created by Sam Son on 2/6/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignalCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellCategory;
@property (weak, nonatomic) IBOutlet UILabel *cellDate;
@property (weak, nonatomic) IBOutlet UILabel *cellAuthor;

@end
