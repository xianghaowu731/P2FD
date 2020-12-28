//
//  ForgetPasswordVC.h
//  FoodOrder
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *mEmail;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onSendClick:(id)sender;

@end
