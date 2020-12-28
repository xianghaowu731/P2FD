//
//  Order.m
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "Order.h"
#import "OrderedFood.h"

@implementation Order

- (id)initWithDictionary:(NSDictionary *)dicParams
{
    Order *item = [[Order alloc] init];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    item.orderId = [dicParams objectForKey:@"id"];
    item.customerId = [dicParams objectForKey:@"user_id"];
    item.restId = [dicParams objectForKey:@"restaurant_id"];
    item.restName = [dicParams objectForKey:@"rest_name"];
    item.restPhone = [dicParams objectForKey:@"rest_phone"];
    item.restEmail = [dicParams objectForKey:@"rest_email"];
    item.restAddress = [dicParams objectForKey:@"rest_address"];
    item.orderTime = [dicParams objectForKey:@"publish_time"];
    item.orderedfoods = [[NSMutableArray alloc] init];
    NSArray *array = [dicParams objectForKey:@"foods"];
    NSString *inst_str = [dicParams objectForKey:@"instruction"];
    if(inst_str==nil || [inst_str length] == 0){
        inst_str = @" , , , , , , , , , , , , , , , , ";
    }
    NSArray *foo = [inst_str componentsSeparatedByString:@","];
    for(int i=0; i<array.count; i++){
        [item.orderedfoods addObject:[[OrderedFood alloc] initWithDictionary:[array objectAtIndex:i]]];
        if([foo[i] length] > 0){
            ((OrderedFood *)item.orderedfoods[i]).desc = foo[i];
        }
    }
    item.status = [dicParams objectForKey:@"status"];
    item.status_id = [dicParams objectForKey:@"status_id"];
    item.reason = [dicParams objectForKey:@"reason"];
    item.totalPrice = [dicParams objectForKey:@"total_price"];
    item.address = [dicParams objectForKey:@"address"];
    item.comment = [dicParams objectForKey:@"comment"];
    item.userId = [dicParams objectForKey:@"user_id"];
    item.user = [[Customer alloc] initWithDictionary:[dicParams objectForKey:@"user"]];
    item.subPrice = [dicParams objectForKey:@"subprice"];
    item.deliveryFee = [dicParams objectForKey:@"deliveryfee"];
    item.tipPrice = [dicParams objectForKey:@"tipprice"];
    item.fromtime = [dicParams objectForKey:@"fromtime"];
    item.location = [dicParams objectForKey:@"location"];
    item.tofirst = [dicParams objectForKey:@"to_ufirst"];
    item.tolast = [dicParams objectForKey:@"to_ulast"];
    item.tophone = [dicParams objectForKey:@"to_uphone"];
    item.driverId = [dicParams objectForKey:@"driver_id"];
    item.pickup = [dicParams objectForKey:@"pickup_time"];
    
    return item;
}


@end
