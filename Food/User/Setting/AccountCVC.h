//
//  AccountCVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *mFirstNameText;
@property (strong, nonatomic) IBOutlet UITextField *mLastNameText;
@property (strong, nonatomic) IBOutlet UILabel *mEmailLabel;
@property (strong, nonatomic) IBOutlet UITextField *mPhoneText;
@property (strong, nonatomic) IBOutlet UITextField *mAddressText;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onUpdateClick:(id)sender;
- (IBAction)onChangeEmailClick:(id)sender;
- (IBAction)onChangePasswdClick:(id)sender;
@end
