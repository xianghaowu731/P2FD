//
//  Menu.m
//  Menu
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "Menu.h"

@implementation Menu
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    Menu *item = [[Menu alloc] init];
    
    item.menuId = [dicParams objectForKey:@"id"];
    item.restId = [dicParams objectForKey:@"rest_id"];
    item.menuName = [dicParams objectForKey:@"title"];
    
    return item;
}

@end
