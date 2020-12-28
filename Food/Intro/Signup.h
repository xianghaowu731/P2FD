//
//  Signup.h
//  FoodOrder
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@interface Signup : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *mEmail;
@property (strong, nonatomic) IBOutlet UITextField *mPasswd;
@property (strong, nonatomic) IBOutlet UITextField *mConfirmPasswd;
@property (strong, nonatomic) IBOutlet UIView *mCheckView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox;
@property (strong, nonatomic) IBOutlet UITextField *mPhone;


- (IBAction)onBackClick:(id)sender;
- (IBAction)onSignupClick:(id)sender;
- (IBAction)onOwnerClick:(id)sender;
- (IBAction)onSignupWithFacebbok:(id)sender;

@end
