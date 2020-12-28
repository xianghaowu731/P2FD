//
//  ForgetPasswordVC.m
//  FoodOrder
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "ForgetPasswordVC.h"
#import "Config.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"


@interface ForgetPasswordVC ()

@end

@implementation ForgetPasswordVC

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

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSendClick:(id)sender {
    NSString* email = self.mEmail.text;
    
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
    }
    [SVProgressHUD show];
    [[HttpApi sharedInstance] forgotPassWithEmail:(NSString *)email
                                        Completed:^(NSString *dic){
                                            [SVProgressHUD dismiss];
                                            
                                            
                                            UIAlertController * alert=   [UIAlertController
                                                                          alertControllerWithTitle:@"Success!"
                                                                          message:@"Your email was sent successfully."
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
@end
