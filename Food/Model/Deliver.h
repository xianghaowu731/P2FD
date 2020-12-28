//
//  Deliver.h
//  Deliver
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deliver : NSObject

@property (nonatomic, strong) NSString *dId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *worktime;
@property (nonatomic, strong) NSNumber *ranking;
@property (nonatomic, strong) NSNumber *reviews;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSNumber *isfavorite;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *location;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
