//
//  DeliverProfile.h
//  Food
//
//  Created by meixiang wu on 21/09/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deliver.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface DeliverProfile : UIViewController
@property (strong, nonatomic) Deliver* data;
@property (strong, nonatomic) Deliver* updateData;

@property (strong, nonatomic) IBOutlet UIButton *mImageBtn;
@property (strong, nonatomic) IBOutlet UILabel *mEmailLabel;
@property (strong, nonatomic) IBOutlet UITextField *mNameText;
@property (strong, nonatomic) IBOutlet UITextField *mWorkTimeText;
@property (strong, nonatomic) IBOutlet UITextField *mStatusTV;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mScrollView;
@property (strong, nonatomic) IBOutlet UITextField *mPhoneText;
@property (strong, nonatomic) IBOutlet UITextView *mDescText;

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
