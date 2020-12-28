//
//  ExtraMenuCell.h
//  Food
//
//  Created by meixiang wu on 07/03/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtraMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRequireLabel;
@property (weak, nonatomic) IBOutlet UILabel *mMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *mChooseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;

@end
