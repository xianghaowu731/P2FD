//
//  RFoodEditVC.h
//  Food
//
//  Created by weiquan zhang on 6/19/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@interface RFoodAddVC : UIViewController

@property (strong, nonatomic) NSMutableArray* m_data;
@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet UITextField *mNameText;
@property (strong, nonatomic) IBOutlet UITextField *mPriceText;
@property (strong, nonatomic) IBOutlet UITextView *mDescText;
@property (weak, nonatomic) IBOutlet UITextField *mAddExtraNameTxt;
@property (weak, nonatomic) IBOutlet UIView *mExtraView;
@property (weak, nonatomic) IBOutlet UIView *mAddView;
@property (weak, nonatomic) IBOutlet UITextField *mEfoodNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *mEPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *mMenuRequiredTxt;


- (IBAction)onAddClick:(id)sender;
- (IBAction)mPhotoClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onAddExtraMenu:(id)sender;
- (IBAction)onAddViewHide:(id)sender;
- (IBAction)onAddExtraFoodClick:(id)sender;

@property (strong, nonatomic) Food* data;
@property (strong, nonatomic) NSString *categoryId;

@end
