//
//  Food.m
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "Food.h"
#import "ExtraMenu.h"

@implementation Food
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    Food *item = [[Food alloc] init];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    item.foodId = [dicParams objectForKey:@"id"];
    item.name = [dicParams objectForKey:@"title"];
    item.desc = [dicParams objectForKey:@"content"];
    item.img = [dicParams objectForKey:@"image"];
    item.price = [f numberFromString:[dicParams objectForKey:@"price"]];
    item.is_quick = [f numberFromString:[dicParams objectForKey:@"is_quick"]];
    item.restId = [dicParams objectForKey:@"restaurant_id"];
    item.restName = [dicParams objectForKey:@"restaurant_name"];
    item.status = [dicParams objectForKey:@"status"];
    item.categoryId = [dicParams objectForKey:@"category_id"];
    item.is_favorite = [f numberFromString:[dicParams objectForKey:@"is_favorite"]];
    item.extra = [dicParams objectForKey:@"extra"];
    item.instruction = @"";
    
    item.extrafoods = [[NSMutableArray alloc] init];
    NSArray *array = [dicParams objectForKey:@"extras"];
    for(int i=0; i<array.count; i++){
        [item.extrafoods addObject:[[ExtraMenu alloc] initWithDictionary:array[i]]];
    }
    
    return item;
}

@end
