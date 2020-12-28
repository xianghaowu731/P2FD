//
//  UserCategoryView.h
//  Food
//
//  Created by meixiang wu on 6/2/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface UserCategoryView : UIViewController

@property (strong, nonatomic) NSMutableArray* m_data;
@property (strong, nonatomic) NSMutableArray* m_category;
@property (strong, nonatomic) Restaurant *mRestaurant;

@end
