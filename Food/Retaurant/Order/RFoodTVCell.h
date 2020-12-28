//
//  RFoodTVCell.h
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@interface RFoodTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet UILabel *mNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *mDescLabel;
@property (strong, nonatomic) IBOutlet UILabel *mCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCategory;

@property (strong, nonatomic) Food* data;
- (void)setLayout:(Food*)f;
@end
