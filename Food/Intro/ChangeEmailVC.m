//
//  ChangeEmailVC.m
//  Food
//
//  Created by weiquan zhang on 6/21/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "ChangeEmailVC.h"
#import "Config.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"

@interface ChangeEmailVC ()

@end

@implementation ChangeEmailVC{
    NSString* curLoginEmail;
    NSString* curLoginType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    curLoginType = [[NSString alloc] init];
    curLoginEmail = [[NSString alloc] init];
    curLoginEmail = [Common getValueKey:@"emailName"];
    curLoginType = [Common getValueKey:@"login_type"];
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

- (IBAction)onChange:(id)sender {
    NSString* strOldEmail = self.mOldEmailTxt.text;
    NSString* strEmail = self.mEmailTxt.text;
    if([strEmail isEqualToString:strOldEmail]){
        [self showAlertDlg:@"Warning!" Content:@"New email is equal to old email. Retype new email."];
        return;
    }
    if(![strOldEmail isEqualToString:curLoginEmail]){
        [self showAlertDlg:@"Warning!" Content:@"Old email is wrong. Retype old email."];
        return;
    }
    if(self.mPasswordTxt.text == (id)[NSNull null]){
        [self showAlertDlg:@"Warning!" Content:@"Password is wrong."];
        return;

    }
    [SVProgressHUD show];
    [[HttpApi sharedInstance] changeEmail:strOldEmail Email:strEmail Password:self.mPasswordTxt.text Completed:^(NSString *data){
        [SVProgressHUD dismiss];
        [self showAlertDlg:@"Success!" Content:data];
        [Common saveValueKey:@"emailName" Value:strEmail];
        [self dismissViewControllerAnimated:YES completion:Nil];
    }Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
}

-(void) showAlertDlg:(NSString *)title
             Content:(NSString *)content
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:content
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
}

@end
