//
//  Restaurant.m
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

- (id)initWithDictionary:(NSDictionary *)dicParams
{
    Restaurant *item = [[Restaurant alloc] init];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    item.restaurantId = [dicParams objectForKey:@"id"];
    item.address = [dicParams objectForKey:@"address"];
    item.location = [dicParams objectForKey:@"location"];
    item.phone = [dicParams objectForKey:@"phone"];
    item.worktime = [dicParams objectForKey:@"worktime"];
    item.img = [dicParams objectForKey:@"photo"];
    item.desc = [dicParams objectForKey:@"content"];
    item.email = [dicParams objectForKey:@"email"];
    item.name = [dicParams objectForKey:@"username"];
    item.status = [dicParams objectForKey:@"state"];
    item.reviews = [f numberFromString:[dicParams objectForKey:@"reviews"]];
    item.ranking = [f numberFromString:[dicParams objectForKey:@"ranking"]];
    item.isfavorite = [f numberFromString:[dicParams objectForKey:@"is_favorite"]];
    
    if([item.address isKindOfClass:[NSNull class]]) item.address = @"";
    if([item.location isKindOfClass:[NSNull class]]) item.location = @"";
    item.mDistance = -1.0;
    return item;
}




@end
