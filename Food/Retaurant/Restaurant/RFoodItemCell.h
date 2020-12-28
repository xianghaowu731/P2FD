//
//  RFoodItemCell.h
//  Food
//
//  Created by meixiang wu on 5/13/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFoodItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mStatusIV;
@property (weak, nonatomic) IBOutlet UIButton *mEditBtn;

@end
