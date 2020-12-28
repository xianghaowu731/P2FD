//
//  TableFood.m
//  TableFood
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "TableFood.h"

@implementation TableFood
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    TableFood *item = [[TableFood alloc] init];
    
    item.mId = [dicParams objectForKey:@"id"];
    item.foodname = [dicParams objectForKey:@"food_name"];
    item.price = [dicParams objectForKey:@"price"];
    item.count = [dicParams objectForKey:@"count"];
    item.instruction = [dicParams objectForKey:@"instruction"];
    item.type = 1;
    
    return item;
}

@end
