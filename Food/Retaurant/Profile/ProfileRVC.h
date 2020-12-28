//
//  ProfileRVC.h
//  FoodOrder
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "Restaurant.h"


@interface ProfileRVC : UIViewController

@property (strong, nonatomic) Restaurant* data;
@property (strong, nonatomic) Restaurant* updateData;

@property (strong, nonatomic) IBOutlet UIButton *mImageBtn;
@property (strong, nonatomic) IBOutlet UILabel *mEmailLabel;
@property (strong, nonatomic) IBOutlet UITextField *mNameText;
@property (strong, nonatomic) IBOutlet UITextField *mWorkTimeText;
@property (strong, nonatomic) IBOutlet UILabel *mStatusTV;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mScrollView;
@property (strong, nonatomic) IBOutlet UITextField *mPhoneText;
@property (strong, nonatomic) IBOutlet UITextView *mDescText;
@property (strong, nonatomic) IBOutlet UIButton *mChangeEmailBtn;
@property (strong, nonatomic) IBOutlet UIButton *mChangePasswdBtn;
@property (strong, nonatomic) IBOutlet UIButton *mUpdateBtn;
@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet UIButton *mLocationBtn;

- (IBAction)onImageBtnClick:(id)sender;
- (IBAction)onChangePasswdClick:(id)sender;
- (IBAction)onLogoutClick:(id)sender;
- (IBAction)onUpdateBtn:(id)sender;
- (IBAction)onLocationPick:(id)sender;

@end
