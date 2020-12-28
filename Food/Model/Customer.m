//
//  Customer.m
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "Customer.h"

@implementation Customer
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    Customer *item = [[Customer alloc] init];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    item.customerId = [self checkNil:[dicParams objectForKey:@"id"]];
    item.firstName = [self checkNil:[dicParams objectForKey:@"firstName"]];
    item.lastName = [self checkNil:[dicParams objectForKey:@"lastName"]];
    item.userName = [self checkNil:[dicParams objectForKey:@"username"]];
    item.email = [self checkNil:[dicParams objectForKey:@"email"]];
    item.address = [self checkNil:[dicParams objectForKey:@"address"]];
    item.phone = [self checkNil:[dicParams objectForKey:@"phone"]];
    item.img = [self checkNil:[dicParams objectForKey:@"img"]];

    return item;
}

- (NSString*) checkNil:(NSString*)p{
    NSString* result = p;
    if([p isEqual:nil] || [p isEqual:[NSNull null]])
        result = @"";
    return result;
}

@end
