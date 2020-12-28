//
//  Login.h
//  FoodOrder
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"
#import "AppDelegate.h"

@interface Login : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *mEmail;
@property (strong, nonatomic) IBOutlet UIView *checkArea;
@property (strong, nonatomic) IBOutlet UITextField *mPasswd;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox;

- (IBAction)onJoinUsClick:(id)sender;

- (IBAction)onRememberClick:(id)sender;

- (IBAction)onRegistratorClick:(id)sender;

- (IBAction)onForgetPasswordClick:(id)sender;

- (IBAction)onLoginWithGoogle:(id)sender;

- (IBAction)onLoginClick:(id)sender;

- (IBAction)onLoginWithFacebook:(id)sender;

- (IBAction)onBackClick:(id)sender;

@end
