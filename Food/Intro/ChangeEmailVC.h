//
//  ChangeEmailVC.h
//  Food
//
//  Created by weiquan zhang on 6/21/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeEmailVC : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *mOldEmailTxt;
@property (strong, nonatomic) IBOutlet UITextField *mEmailTxt;
@property (strong, nonatomic) IBOutlet UITextField *mPasswordTxt;

- (IBAction)onChange:(id)sender;

@end
