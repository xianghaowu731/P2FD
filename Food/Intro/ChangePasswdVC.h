//
//  ChangePasswdVC.h
//  Food
//
//  Created by weiquan zhang on 6/21/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswdVC : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *mEmailText;
@property (strong, nonatomic) IBOutlet UITextField *mOldPasswordText;
@property (strong, nonatomic) IBOutlet UITextField *mNewPasswordText;
@property (strong, nonatomic) IBOutlet UITextField *mConfirmPasswordText;


- (IBAction)onChangeClick:(id)sender;
- (IBAction)onBackClick:(id)sender;

@end
