//
//  RExtraFoodVC.h
//  Food
//
//  Created by meixiang wu on 06/03/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFoodAddVC.h"

@protocol ExtraViewDelegate <NSObject>
@optional
- (void) didAddFoodItem:(NSString *)mID;
@end

@interface RExtraFoodVC : UIViewController
@property (strong, nonatomic) NSMutableArray* m_data;
@property (nonatomic, weak) id <ExtraViewDelegate> delegate;

- (void)refreshTable;
@end
