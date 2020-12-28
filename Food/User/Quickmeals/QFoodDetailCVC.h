//
//  QFoodDetailCVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@interface QFoodDetailCVC : UIViewController

@property (strong, nonatomic) Food* data;

@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet UILabel *mNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mByLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (strong, nonatomic) IBOutlet UITextView *mDescLabel;
@property (strong, nonatomic) IBOutlet UIButton *mFavoIcon;

- (IBAction)onFavoIconClick:(id)sender;
@end
