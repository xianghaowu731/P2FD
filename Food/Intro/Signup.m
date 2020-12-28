//
//  Signup.m
//  FoodOrder
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "Signup.h"
#import "Config.h"
#import "Common.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "TermsVC.h"
#import "FacebookUserInfo.h"
#import "AppDelegate.h"



@interface Signup (){
    NSString* fbToken;
}
@property (strong, nonatomic) FacebookUserInfo *facebookUserInfo;
@end

@implementation Signup{
    BOOL isChecked;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.navigationItem.title = @"Signup";
    /*self.mCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView addSubview:self.mCheckBox];
    self.mCheckBox.on = NO;
    self.mCheckBox.onFillColor = PRIMARY_COLOR;
    self.mCheckBox.onTintColor = PRIMARY_COLOR;
    self.mCheckBox.tintColor = PRIMARY_COLOR;
    self.mCheckBox.onCheckColor = WHITE_COLOR;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(check:)];
    [self.mCheckBox addGestureRecognizer:singleFingerTap];
    
    self.mCheckBox.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox.boxType = BEMBoxTypeSquare;*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)check:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    if(isChecked){
        isChecked = NO;
        [self.mCheckBox setOn:NO animated:YES];
        
    } else {
        [self.mCheckBox setOn:YES animated:YES];
        isChecked = YES;
    }
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

- (IBAction)onSignupClick:(id)sender {
    if([self.mEmail.text length]==0){
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
    if([self.mPasswd.text length]==0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter your password."
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
    if([self.mConfirmPasswd.text length]==0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter confirmpassword."
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
    
    if(![self.mPasswd.text isEqualToString:self.mConfirmPasswd.text]){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"The passwords are not matched."
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
    
    if([self.mPhone.text length] != 10){
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
    
    //NSString *uTYPE =  isChecked? TYPE_OWNER : TYPE_CUSTOMER;
    NSString *uTYPE =  isChecked? TYPE_DRIVER:TYPE_CUSTOMER;
    NSString *uName = @"";
    NSRange range = [self.mEmail.text rangeOfString:@"@"];
    if (range.location == NSNotFound)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"Your email address is invalid. Please enter email again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else{
        uName = [self getSubstring:self.mEmail.text betweenString:@"@"];
    }
    
    NSRange range1 = [self.mEmail.text rangeOfString:@".com"];
    if(range1.location == NSNotFound){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"Your email address is invalid. Please enter email again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [SVProgressHUD show];
    [[HttpApi sharedInstance] registerWithUsername:uName Email:self.mEmail.text Phone:self.mPhone.text Password:self.mPasswd.text Type:uTYPE
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
                                            [self.navigationController popViewControllerAnimated:YES];
                                            /*TermsVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TermsVC"];
                                            mVC.u_type = uTYPE;
                                            mVC.u_email = self.mEmail.text;
                                            mVC.u_phone = self.mPhone.text;
                                            mVC.u_password = self.mPasswd.text;
                                            [self.navigationController pushViewController:mVC animated:YES];*/
                                            
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }Failed:^(NSString *strError) {
            [SVProgressHUD showErrorWithStatus:strError];
    }];
    //---------------================----------------------
    /*TermsVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TermsVC"];
    mVC.u_type = uTYPE;
    mVC.u_email = self.mEmail.text;
    mVC.u_phone = self.mPhone.text;
    mVC.u_password = self.mPasswd.text;
    [self.navigationController pushViewController:mVC animated:YES];*/

}

- (NSString *)getSubstring:(NSString *)value betweenString:(NSString *)separator
{
    NSRange firstInstance = [value rangeOfString:separator];
    NSRange finalRange = NSMakeRange(0,firstInstance.location );
    
    return [value substringWithRange:finalRange];
}

- (IBAction)onOwnerClick:(id)sender {
}

- (IBAction)onSignupWithFacebbok:(id)sender {
    NSString *uTYPE =  isChecked? TYPE_DRIVER : TYPE_CUSTOMER;
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email"] fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
        if (error) {
            NSLog(@"Process error");
        } else if (result.isCancelled) {
            NSLog(@"Cancelled");
        } else {
            NSLog(@"Logged in");
            FBSDKAccessToken* fToken = [FBSDKAccessToken currentAccessToken];
            if ([FBSDKAccessToken currentAccessToken]) {
                fbToken = fToken.tokenString;
                
                NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                [parameters setValue:@"id,first_name, name, last_name, email" forKey:@"fields"];
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          NSLog(@"fetched user:%@", result);
                          
                          NSDictionary *dicResult = (NSDictionary*)result;
                          self.facebookUserInfo = [[FacebookUserInfo alloc] init];
                          self.facebookUserInfo.facebookId = dicResult[@"id"];
                          self.facebookUserInfo.firstName = dicResult[@"first_name"];
                          self.facebookUserInfo.lastName = dicResult[@"last_name"];
                          self.facebookUserInfo.email = dicResult[@"email"];
                          self.facebookUserInfo.birthday = dicResult[@"birthday"];
                          self.facebookUserInfo.gender = dicResult[@"gender"];
                          self.facebookUserInfo.location = dicResult[@"location"][@"name"];
                          //self.facebookUserInfo.picture = dicResult[@"picture"][@"data"][@"url"];
                          
                          [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@/picture", self.facebookUserInfo.facebookId] parameters:@{@"redirect": @"false", @"width":@"500", @"height":@"500"}] startWithCompletionHandler:^ (FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                               if (!error) {
                                   NSLog(@"fetched user:%@", result);
                                   NSDictionary *dicResult = (NSDictionary *)result;
                                   
                                   self.facebookUserInfo.picture = dicResult[@"data"][@"url"];
                                   [SVProgressHUD show];
                                   [[HttpApi sharedInstance]SignupFBWithID:(NSString*)self.facebookUserInfo.facebookId
                                                                     Email:(NSString*)self.facebookUserInfo.email
                                                                      Name:(NSString*)self.facebookUserInfo.firstName
                                                                     Phone:(NSString*)@""
                                                                      Type:(NSString*)uTYPE
                                                                 Completed:^(NSString *tkn){
                                                                     logtoken = tkn;
                                                                     [Common saveValueKey:@"token" Value:logtoken];
                                                                     [Common saveValueKey:@"emailName" Value:self.facebookUserInfo.email];
                                                                     [Common saveValueKey:@"login_type" Value:@"facebook"];
                                                                     socialType = @"facebook";
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
                                                                                                     
                                                                                                     [self.navigationController popViewControllerAnimated:YES];
                                                                                                     
                                                                                                     /*TermsVC* mVC = [self.storyboard
                                                                                                                     instantiateViewControllerWithIdentifier:@"SID_TermsVC"];
                                                                                                     
                                                                                                     [self.navigationController pushViewController:mVC
                                                                                                                                          animated:YES];*/
                                                                                                     
                                                                                                     
                                                                                                     
                                                                                                 }];
                                                                     [alert addAction:yesButton];
                                                                     
                                                                     [self presentViewController:alert animated:YES completion:nil];
                                                                 }
                                                                 Failed:^(NSString *strError) {
                                                                     [SVProgressHUD showErrorWithStatus:strError];
                                                                 }];
                                                            }
                                                    }];
                                            }
                                    }];
                                }
                        }
                 }];

}
@end
