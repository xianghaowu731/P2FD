//
//  RFoodEditVC.h
//  Food
//
//  Created by weiquan zhang on 6/19/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@interface RFoodEditVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *mPhotoBtn;
@property (strong, nonatomic) IBOutlet UIButton *mStatusBtn;
@property (strong, nonatomic) IBOutlet UITextField *mNameText;
@property (strong, nonatomic) IBOutlet UITextField *mPriceText;
@property (strong, nonatomic) IBOutlet UITextView *mDescText;
@property (strong, nonatomic) IBOutlet UISwitch *mStatusSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UIView *mExtraView;
@property (weak, nonatomic) IBOutlet UITextField *mMenuNameTxt;
@property (weak, nonatomic) IBOutlet UIView *mAddFoodView;
@property (weak, nonatomic) IBOutlet UITextField *mPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *mEFoodNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *mMenuRequiredTxt;


- (IBAction)onClickUpdate:(id)sender;
- (IBAction)onClickSwitch:(id)sender;
- (IBAction)onClickPhotoClick:(id)sender;
- (IBAction)onDelete:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onAddMenuClick:(id)sender;
- (IBAction)onAddViewHideClick:(id)sender;
- (IBAction)onExtraFoodAddClick:(id)sender;

@property (strong, nonatomic) Food* data;
@property (strong, nonatomic) Food* updateData;
@property (strong, nonatomic) NSMutableArray* m_data;
//- (void) setLayout:(Food* )f;
@end
