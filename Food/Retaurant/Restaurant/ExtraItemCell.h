//
//  ExtraItemCell.h
//  Food
//
//  Created by meixiang wu on 18/08/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMCheckBox.h>

@interface ExtraItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mCheckView;
@property (weak, nonatomic) IBOutlet UILabel *mFoodName;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;

@end
