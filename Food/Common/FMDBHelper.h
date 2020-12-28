//
//  FMDBHelper.h
//  BoatTicketBooking
//
//  Created by Jin_Q on 5/28/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Food.h"
#import "ExtraFood.h"

@interface FMDBHelper : NSObject

+ (id) sharedInstance;

- (NSMutableArray*) getAllOrders;
- (NSMutableArray*) getRestIds;
- (NSMutableArray*) getOrdersByRestID:(NSString*)restId;
- (NSMutableArray*) getOrdersGroup;
- (void) deleteOrderByRestId:(NSString*) restId;

- (void) updateFood:(Food*) food
           Quantity:(NSInteger) mcount;
- (void) deleteFood:(Food*) food;
- (void) deleteExtFood:(ExtraFood*) extfood;
@end
