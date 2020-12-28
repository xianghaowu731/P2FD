//
//  TableFood.h
//  TableFood
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableFood : NSObject

@property (nonatomic, strong) NSString *mId; // local db useful
@property (nonatomic, strong) NSString *foodid;
@property (nonatomic, strong) NSString *foodname;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *instruction;
@property (nonatomic) NSInteger type;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
