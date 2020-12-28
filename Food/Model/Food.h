//
//  Food.h
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject

@property (nonatomic, strong) NSString *fId; // local db useful
@property (nonatomic, strong) NSString *foodId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *restId;
@property (nonatomic, strong) NSString *restName;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSNumber *is_quick;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSNumber *is_favorite;
@property (nonatomic, strong) NSString *extra;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *cID;
@property (nonatomic, strong) NSDate *datetime;
@property (nonatomic, strong) NSString *instruction;
@property (nonatomic, strong) NSMutableArray* extrafoods;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
