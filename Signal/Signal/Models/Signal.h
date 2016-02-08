//
//  Signal.h
//  Signal
//
//  Created by Sam Son on 2/8/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Signal : NSObject

-(instancetype)init;

-(instancetype)initWithTitle: (NSString *) title
                     comment: (NSString *) comment
                    username: (NSString *) username
                     addedOn: (NSString *) addedOn
                 andCategory: (NSString *) category;

-(instancetype)initWithTitle: (NSString *) title
                     comment: (NSString *) comment
                    username: (NSString *) username
                     addedOn: (NSString *) addedOn
                    category: (NSString *) category
                    latitude: (CGFloat) latitude
                   longitude: (CGFloat) longitude
                  andPicture: (UIImage *) picture;

+(Signal *) signal;

+(Signal *) signalWithTitle: (NSString *) title
                    comment: (NSString *) comment
                   username: (NSString *) username
                    addedOn: (NSString *) addedOn
                andCategory: (NSString *) category;

+(Signal *) signalWithTitle: (NSString *) title
                    comment: (NSString *) comment
                   username: (NSString *) username
                    addedOn: (NSString *) addedOn
                   category: (NSString *) category
                   latitude: (CGFloat) latitude
                  longitude: (CGFloat) longitude
                 andPicture: (UIImage *) picture;

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *category;
@property CGFloat latitude;
@property CGFloat longitude;
@property(nonatomic,strong) NSString *comment;
@property(nonatomic,strong) NSString *addedOn;
@property(nonatomic,strong) UIImage *picture;
@end
