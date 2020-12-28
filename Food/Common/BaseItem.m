//
//  BaseItem.m
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import "BaseItem.h"

@implementation BaseItem
- (id) initWithDictionary:(NSDictionary *)dicParams{
    BaseItem *item = [[BaseItem alloc] init];
    
    return item;
}

- (id) initWithString: (NSString *) value{
    BaseItem *item = [[BaseItem alloc] init];
    
    return item;
}

- (NSString *) getStringOfItem{return @"";}
@end
