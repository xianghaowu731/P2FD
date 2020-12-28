//
//  ExtraFood.m
//  ExtraFood
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "ExtraFood.h"

@implementation ExtraFood
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    ExtraFood *item = [[ExtraFood alloc] init];
    
    item.eid = [dicParams objectForKey:@"id"];
    item.menuId = [dicParams objectForKey:@"menu_id"];
    item.foodname = [dicParams objectForKey:@"food_name"];
    item.price = [dicParams objectForKey:@"price"];
    item.count = [dicParams objectForKey:@"count"];
    item.bCheck = false;
    
    return item;
}

@end
