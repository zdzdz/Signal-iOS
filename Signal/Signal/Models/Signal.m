//
//  Signal.m
//  Signal
//
//  Created by Sam Son on 2/8/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import "Signal.h"

@implementation Signal

@synthesize title = _title;
@synthesize category = _category;
@synthesize comment = _comment;
@synthesize picture = _picture;
@synthesize username = _username;
@synthesize addedOn = _addedOn;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;

- (instancetype)init{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title comment:(NSString *)comment username:(NSString *)username addedOn:(NSString *)addedOn andCategory:(NSString *)category{
    self = [super init];
    if(self)
    {
        self.title = title;
        self.username = username;
        self.addedOn = addedOn;
        self.comment = comment;
        self.category = category;
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title comment:(NSString *)comment username:(NSString *)username addedOn:(NSString *)addedOn category:(NSString *)category latitude:(CGFloat)latitude longitude:(CGFloat)longitude andPicture:(UIImage *)picture{
    self = [super init];
    if(self)
    {
        self.title = title;
        self.username = username;
        self.addedOn = addedOn;
        self.comment = comment;
        self.category = category;
        self.latitude = latitude;
        self.longitude = longitude;
        self.picture = picture;
    }
    return self;
}

+(Signal *)signal{
    return [[Signal alloc] init];
}

+(Signal *)signalWithTitle:(NSString *)title comment:(NSString *)comment username:(NSString *)username addedOn:(NSString *)addedOn andCategory:(NSString *)category{
    return [[Signal alloc] initWithTitle:title comment:comment username:username addedOn:addedOn andCategory:category];
}

+(Signal *)signalWithTitle:(NSString *)title comment:(NSString *)comment username:(NSString *)username addedOn:(NSString *)addedOn category:(NSString *)category latitude:(CGFloat)latitude longitude:(CGFloat)longitude andPicture:(UIImage *)picture{
    return [[Signal alloc] initWithTitle:title comment:comment username:username addedOn:addedOn category:category latitude:latitude longitude:longitude andPicture:picture];
}

-(NSString *) title{
    return _title;
}

-(void)setTitle:(NSString *)title{
    if (title.length == 0) {
        _title = nil;
    } else {
        _title = title;
    }
}

-(NSString *) comment{
    return _comment;
}

-(void)setComment:(NSString *)comment{
    if (comment.length == 0) {
        _comment = nil;
    } else {
        _comment = comment;
    }
}

-(NSString *) category{
    return _category;
}

-(void)setCategory:(NSString *)category{
    if (category.length == 0) {
        _category = nil;
    } else {
        _category = category;
    }
}

-(NSString *) username{
    return _username;
}

-(void)setUsername:(NSString *)username{
     _username = username;
}

-(NSString *) addedOn{
    return _addedOn;
}

-(void)setAddedon:(NSString *)addedOn{
    _addedOn = addedOn;
}

-(CGFloat) longitude{
    return _longitude;
}

-(void)setLongitude:(CGFloat)longitude{
    _longitude = longitude;
}

-(CGFloat) latitude{
    return _latitude;
}

-(void)setLatitude:(CGFloat)latitude{
    _latitude = latitude;
}


-(UIImage *) picture{
    return _picture;
}

-(void)setPicture:(UIImage *)picture{
    _picture = picture;
}

@end
