//
//  Order.h
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"

@interface Order : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *restId;
@property (nonatomic, strong) NSString *restName;
@property (nonatomic, strong) NSString *restPhone;
@property (nonatomic, strong) NSString *restEmail;
@property (nonatomic, strong) NSString *restAddress;
@property (nonatomic, strong) NSString *orderTime;
@property (nonatomic, strong) NSMutableArray* orderedfoods;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *status_id;
@property (nonatomic, strong) NSString *totalPrice;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) Customer *user;
@property (nonatomic, strong) NSString *subPrice;
@property (nonatomic, strong) NSString *deliveryFee;
@property (nonatomic, strong) NSString *tipPrice;
@property (nonatomic, strong) NSString *fromtime;//Deliverytime
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *tofirst;
@property (nonatomic, strong) NSString *tolast;
@property (nonatomic, strong) NSString *tophone;
@property (nonatomic, strong) NSString *driverId;
@property (nonatomic, strong) NSString *pickup;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
