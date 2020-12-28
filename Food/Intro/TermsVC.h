//
//  TermsVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsVC : UIViewController
- (IBAction)onClickOK:(id)sender;
- (IBAction)onClickNO:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *mEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPhoneNumber;

@property (strong, nonatomic) NSString* u_email;
@property (strong, nonatomic) NSString* u_phone;
@property (strong, nonatomic) NSString* u_password;
@property (strong, nonatomic) NSString* u_type;

@end
