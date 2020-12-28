//
//  Menu.h
//  Menu
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

@property (nonatomic, strong) NSString *mId; // local db useful
@property (nonatomic, strong) NSString *menuId;
@property (nonatomic, strong) NSString *restId;
@property (nonatomic, strong) NSString *menuName;


- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
