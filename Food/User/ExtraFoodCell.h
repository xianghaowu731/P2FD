//
//  ExtraFoodCell.h
//  Food
//
//  Created by meixiang wu on 07/03/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMCheckBox.h>

@interface ExtraFoodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mEFoodName;
@property (weak, nonatomic) IBOutlet UILabel *mPriceName;
@property (weak, nonatomic) IBOutlet UIView *mCheckView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox;
@end
