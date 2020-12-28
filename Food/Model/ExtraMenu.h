//
//  ExtraMenu.h
//  ExtraMenu
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExtraMenu : NSObject

@property (nonatomic, strong) NSString *mId; // local db useful
@property (nonatomic, strong) NSString *menuId;
@property (nonatomic, strong) NSString *foodId;
@property (nonatomic, strong) NSString *menuName;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSMutableArray* extrafoods;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
