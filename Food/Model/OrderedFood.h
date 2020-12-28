//
//  OrderedFood.h
//  Food
//
//  Created by weiquan zhang on 6/28/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderedFood : NSObject

@property (nonatomic, strong) NSString *foodId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *restId;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *is_quick;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *is_favorite;
@property (nonatomic, strong) NSMutableArray* extrafoods;

- (id)initWithDictionary:(NSDictionary *)dicParams;
@end
