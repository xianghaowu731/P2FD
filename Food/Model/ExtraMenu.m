//
//  ExtraMenu.m
//  ExtraMenu
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "ExtraMenu.h"
#import "ExtraFood.h"

@implementation ExtraMenu
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    ExtraMenu *item = [[ExtraMenu alloc] init];
    
    item.menuId = [dicParams objectForKey:@"id"];
    item.foodId = [dicParams objectForKey:@"food_id"];
    item.menuName = [dicParams objectForKey:@"menu_name"];
    item.count = [dicParams objectForKey:@"count"];
    item.extrafoods = [[NSMutableArray alloc] init];
    NSArray *array = [dicParams objectForKey:@"extra_food"];
    for(int i=0; i<array.count; i++){
        [item.extrafoods addObject:[[ExtraFood alloc] initWithDictionary:array[i]]];
    }
    
    return item;
}

@end
