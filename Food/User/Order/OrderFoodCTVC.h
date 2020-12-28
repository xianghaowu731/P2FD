//
//  OrderFoodCTVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderedFood.h"

@interface OrderFoodCTVC : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet UILabel *mNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mDescLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *mCountLabel;

@property (strong, nonatomic) OrderedFood* data;
- (void)setLayout:(OrderedFood*) of;

@end
