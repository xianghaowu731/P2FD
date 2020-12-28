//
//  OrderedFood.m
//  Food
//
//  Created by weiquan zhang on 6/28/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "OrderedFood.h"
#import "ExtraMenu.h"

@implementation OrderedFood
- (id)initWithDictionary:(NSDictionary *)dicParams
{    
    OrderedFood *item = [[OrderedFood alloc] init];
    
    item.foodId = [dicParams objectForKey:@"id"];
    item.name = [dicParams objectForKey:@"title"];
    item.desc = [dicParams objectForKey:@"content"];
    item.img = [dicParams objectForKey:@"image"];
    item.price = [dicParams objectForKey:@"price"];
    item.is_quick = [dicParams objectForKey:@"is_quick"];
    item.restId = [dicParams objectForKey:@"restaurant_id"];
    item.count = [dicParams objectForKey:@"amount"];
    item.categoryId = [dicParams objectForKey:@"category_id"];
    item.is_favorite = [dicParams objectForKey:@"is_favorite"];
    
    item.extrafoods = [[NSMutableArray alloc] init];
    NSArray *array = [dicParams objectForKey:@"extras"];
    for(int i=0; i<array.count; i++){
        [item.extrafoods addObject:[[ExtraMenu alloc] initWithDictionary:array[i]]];
    }
    
    return item;
}

@end
