//
//  BaseItem.h
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseItem : NSObject
- (id)initWithDictionary:(NSDictionary *)dicParams;

- (id) initWithString: (NSString *) value;

- (NSString *) getStringOfItem;
@end
