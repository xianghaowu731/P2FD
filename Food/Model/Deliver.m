//
//  Deliver.m
//  Deliver
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "Deliver.h"

@implementation Deliver
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    Deliver *item = [[Deliver alloc] init];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    item.dId = [dicParams objectForKey:@"id"];
    item.address = [dicParams objectForKey:@"address"];
    item.location = [dicParams objectForKey:@"location"];
    item.phone = [dicParams objectForKey:@"phone"];
    item.img = [dicParams objectForKey:@"photo"];
    item.desc = [dicParams objectForKey:@"content"];
    item.email = [dicParams objectForKey:@"email"];
    item.name = [dicParams objectForKey:@"username"];
    item.status = [dicParams objectForKey:@"state"];
    item.worktime = [dicParams objectForKey:@"worktime"];
    item.reviews = [f numberFromString:[dicParams objectForKey:@"reviews"]];
    item.ranking = [f numberFromString:[dicParams objectForKey:@"ranking"]];
    item.isfavorite = [f numberFromString:[dicParams objectForKey:@"is_favorite"]];
    
    if([item.address isKindOfClass:[NSNull class]]) item.address = @"";
    if([item.location isKindOfClass:[NSNull class]]) item.location = @"";
    return item;
}

@end
