//
//  ExtraFood.h
//  ExtraFood
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExtraFood : NSObject

@property (nonatomic, strong) NSString *mId; // local db useful
@property (nonatomic, strong) NSString *eid;
@property (nonatomic, strong) NSString *menuId;
@property (nonatomic, strong) NSString *foodname;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *count;
@property (nonatomic) BOOL bCheck;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
