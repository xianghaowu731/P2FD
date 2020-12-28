//
//  Restaurant.h
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property (nonatomic, strong) NSString *restaurantId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *worktime;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *ranking;
@property (nonatomic, strong) NSNumber *reviews;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSNumber *isfavorite;
@property (nonatomic, strong) NSNumber *cID;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *location;
@property (nonatomic) float mDistance;
@property (nonatomic) NSString *comment;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
