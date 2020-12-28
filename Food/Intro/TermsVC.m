//
//  TermsVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "TermsVC.h"
#import "Login.h"
#import <SVProgressHUD.h>
#import "HttpApi.h"

@interface TermsVC ()

@end

@implementation TermsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLayout{
    self.mEmailLabel.text = self.u_email;
    self.mPhoneNumber.text = self.u_phone;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickOK:(id)sender {
    NSString *uName = [self getSubstring:self.u_email betweenString:@"@"];
    [SVProgressHUD show];
    [[HttpApi sharedInstance] registerWithUsername:uName Email:self.u_email Phone:self.u_phone Password:self.u_password Type:self.u_type
                                         Completed:^(NSString *array){
                                             [SVProgressHUD dismiss];
                                             UIAlertController * alert=   [UIAlertController
                                                                           alertControllerWithTitle:@"Success!"
                                                                           message:@"Your Account was registered successfully."
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                             
                                             UIAlertAction* yesButton = [UIAlertAction
                                                                         actionWithTitle:@"Ok"
                                                                         style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction * action)
                                                                         {
                                                                             //[self.navigationController popViewControllerAnimated:YES];
                                                                             [self.navigationController popToViewController: self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
                                                                             /*Login* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_Login"];
                                                                             g_appDelegate.mViewState = 0;
                                                                             [self.navigationController pushViewController:mVC animated:YES];*/
                                                                         }];
                                             [alert addAction:yesButton];
                                             [self presentViewController:alert animated:YES completion:nil];
                                         }Failed:^(NSString *strError) {
                                             [SVProgressHUD showErrorWithStatus:strError];
                                         }];
    /*Login* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_Login"];
    g_appDelegate.mViewState = 4;
    [self.navigationController pushViewController:mVC animated:YES];*/
}

- (IBAction)onClickNO:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getSubstring:(NSString *)value betweenString:(NSString *)separator
{
    NSRange firstInstance = [value rangeOfString:separator];
    NSRange finalRange = NSMakeRange(0,firstInstance.location );
    
    return [value substringWithRange:finalRange];
}
@end
