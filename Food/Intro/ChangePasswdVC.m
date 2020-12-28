//
//  ChangePasswdVC.m
//  Food
//
//  Created by weiquan zhang on 6/21/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "ChangePasswdVC.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Config.h"
#import "Customer.h"
#import "Restaurant.h"

extern Customer* customer;
extern Restaurant* owner;


@interface ChangePasswdVC ()

@end

@implementation ChangePasswdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onChangeClick:(id)sender {
    NSString* email = self.mEmailText.text;
    NSString* opwd = self.mOldPasswordText.text;
    NSString* npwd = self.mNewPasswordText.text;
    NSString* cpwd = self.mConfirmPasswordText.text;
    
    if([email length] == 0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter your email."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else if([opwd length] == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter your old password."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else if([npwd length] == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter your new password."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else if([cpwd length] == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter your confirm password."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else if(![npwd isEqualToString:cpwd]) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"Please check new password or confirm password"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else if([npwd isEqualToString:opwd]){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"Please check new password"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;

    }
    
    
    [SVProgressHUD show];
    [[HttpApi sharedInstance] modifyPasswordWithUserId:(NSString *)@""
                                                 Email:(NSString *)email
                                           OldPassword:(NSString *)opwd
                                           NewPassword:(NSString *)npwd
                                             Completed:^(NSString *dic){
                                                 [SVProgressHUD dismiss];
                                                 
                                                 UIAlertController * alert=   [UIAlertController
                                                                               alertControllerWithTitle:@"Success!"
                                                                               message:@"Your password changed successfully."
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                 
                                                 UIAlertAction* yesButton = [UIAlertAction
                                                                             actionWithTitle:@"Ok"
                                                                             style:UIAlertActionStyleDefault
                                                                             handler:^(UIAlertAction * action)
                                                                             {
                                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                                             }];
                                                 [alert addAction:yesButton];
                                                 [self presentViewController:alert animated:YES completion:nil];
                                                 
                                             }Failed:^(NSString *strError) {
                                                 [SVProgressHUD showErrorWithStatus:strError];
                                             }];

}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
