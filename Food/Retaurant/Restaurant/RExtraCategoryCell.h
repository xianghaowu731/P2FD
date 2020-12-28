//
//  RExtraCategoryCell.h
//  Food
//
//  Created by meixiang wu on 06/03/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RExtraCategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *mDelBtn;
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property (weak, nonatomic) IBOutlet UIButton *mAddBtn;
@property (weak, nonatomic) IBOutlet UILabel *mRequiredLabel;

@end
