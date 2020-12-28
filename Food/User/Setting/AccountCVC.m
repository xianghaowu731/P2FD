//
//  AccountCVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "AccountCVC.h"
#import "Customer.h"
#import "Login.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Config.h"
#import "ChangePasswdVC.h"

extern Customer* customer;

@interface AccountCVC ()

@end

@implementation AccountCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationItem.title = @"Account";
    
}

- (void) viewWillAppear:(BOOL)animated {
    /*
     if([customer.customerId isEqualToString:@"0"]){
     Login *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_Login"];
     vc.from = @"order";
     [self.navigationController pushViewController:vc animated:YES];
     
     } else {
     [self setLayout:customer];
     }
     */
    [self setLayout:customer];
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

- (void) setLayout:(Customer*)c {
    self.mFirstNameText.text = c.firstName;
    self.mLastNameText.text = c.lastName;
    self.mAddressText.text = c.address;
    self.mPhoneText.text = c.phone;
    self.mEmailLabel.text = c.email;
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

- (IBAction)onUpdateClick:(id)sender {
    
    NSString* firstName = self.mFirstNameText.text;
    NSString* lastName = self.mLastNameText.text;
    NSString* email = self.mEmailLabel.text;
    NSString* phone = self.mPhoneText.text;
    NSString* address = self.mAddressText.text;
    
    if([self.mEmailLabel.text length] == 0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter the email."
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
    
    if([self.mFirstNameText.text length] == 0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter your first name."
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
    
    if([self.mPhoneText.text length] != 10){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"Phone number must be 10 digits."
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
    [[HttpApi sharedInstance] uploadCustomerByCustomerId:(NSString *)customer.customerId
                                               FirstName:(NSString *)firstName
                                                LastName:(NSString *)lastName
                                                   Email:(NSString *)email
                                                   Phone:(NSString *)phone
                                                 Address:(NSString *)address
                                               Completed:^(NSDictionary *dic){
                                                   [SVProgressHUD dismiss];
                                                   
                                                   customer.firstName = self.mFirstNameText.text;
                                                   customer.lastName = self.mLastNameText.text;
                                                   customer.address = self.mAddressText.text;
                                                   customer.phone = self.mPhoneText.text;
                                                   
                                                   UIAlertController * alert=   [UIAlertController
                                                                                 alertControllerWithTitle:@"Success!"
                                                                                 message:@"Your account was changed successfully."
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                   
                                                   UIAlertAction* yesButton = [UIAlertAction
                                                                               actionWithTitle:@"Ok"
                                                                               style:UIAlertActionStyleDefault
                                                                               handler:^(UIAlertAction * action)
                                                                               {
                                                                                   //[self.navigationController popViewControllerAnimated:YES];
                                                                               }];
                                                   [alert addAction:yesButton];
                                                   [self presentViewController:alert animated:YES completion:nil];
                                                   
                                               }Failed:^(NSString *strError) {
                                                   [SVProgressHUD showErrorWithStatus:strError];
                                               }];
    
}

- (IBAction)onChangeEmailClick:(id)sender {
}

- (IBAction)onChangePasswdClick:(id)sender {
    ChangePasswdVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChangePasswdVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
