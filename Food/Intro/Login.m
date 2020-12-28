//
//  Login.m
//  FoodOrder
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "Login.h"
#import "Config.h"
#import "Common.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/SignIn.h>
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "SkipVC.h"
#import "Restaurant.h"
#import "Customer.h"
#import "Deliver.h"
#import "Signup.h"
#import "ForgetPasswordVC.h"
#import "FacebookUserInfo.h"
#import "OtherCVC.h"
#import "AppDelegate.h"
#import "GuestSelectView.h"
#import "OrdersAllVC.h"
#import <OneSignal/OneSignal.h>


extern Restaurant* owner;
extern Customer* customer;
extern Deliver* deliver;

@interface Login () <GIDSignInUIDelegate, GIDSignInDelegate>{
    NSString* fbToken;
    NSString* gToken;
}

@property (strong, nonatomic) FacebookUserInfo *facebookUserInfo;


@end

@implementation Login{
    BOOL isChecked;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.checkArea addSubview:self.mCheckBox];
    self.mCheckBox.on = YES;
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
    self.mCheckBox.boxType = BEMBoxTypeSquare;
    
    /*[self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.navigationController.navigationBar.tintColor = PRIMARY_COLOR;
        
    } else {// iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = PRIMARY_COLOR;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
        
    }
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"Login";
    
    if([self.from isEqualToString:@"term"])
        self.navigationItem.hidesBackButton = YES;*/
    self.navigationController.navigationBar.hidden = true;
        
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    //self.mEmail.text = @"rest@email.com";
    //self.mPasswd.text = @"rest";
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;

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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[Common getValueKey:@"remember_login_info"] isEqualToString:@"1"]){
        isChecked = YES;
        [self.mCheckBox setOn:YES];
        
        NSString *remembered_email = [Common getValueKey:@"remember_login_email"];
        NSString *remembered_pass = [Common getValueKey:@"remember_login_pass"];
        if(remembered_email&&remembered_pass){
            self.mEmail.text = remembered_email;
            self.mPasswd.text = remembered_pass;
        }
        
    } else {
        isChecked = NO;
        [self.mCheckBox setOn:NO];
        
    }
    
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

- (IBAction)onJoinUsClick:(id)sender {
    OtherCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_OtherCVC"];
    mVC.mTitle = @"Join Us";
    mVC.mContent = JOIN_US_TXT;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onRememberClick:(id)sender {
    
}

- (IBAction)onRegistratorClick:(id)sender {
    Signup* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_Signup"];
    [self.navigationController pushViewController:mVC animated:YES];
}


- (IBAction)onForgetPasswordClick:(id)sender {
    ForgetPasswordVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ForgetPasswordVC"];
    [self.navigationController pushViewController:mVC animated:YES];

}

- (IBAction)onLoginWithGoogle:(id)sender {
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    //NSString *userId = user.userID;                  // For client-side use only!
    gToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    [SVProgressHUD show];
    [[HttpApi sharedInstance] loginGLWithID:(NSString *)gToken
                                      Email:(NSString *)email
                                       Name:(NSString *)fullName
                                   LastName:(NSString *)familyName
                                  FirstName:(NSString *)givenName
                                         Completed:^(NSString *tkn){
                                             
                                             logtoken = tkn;
                                             [Common saveValueKey:@"token" Value:logtoken];
                                             [Common saveValueKey:@"emailName" Value:email];
                                             [Common saveValueKey:@"login_type" Value:@"gplus"];
                                             [self getMe];
                                             socialType = @"gplus";
                                             
                                         }Failed:^(NSString *strError) {
                                             [SVProgressHUD showErrorWithStatus:strError];
                                         }];
    
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}


- (IBAction)onLoginClick:(id)sender {
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
    
    if(isChecked){
        [Common saveValueKey:@"remember_login_info" Value:@"1"];
        [Common saveValueKey:@"remember_login_email" Value:self.mEmail.text];
        [Common saveValueKey:@"remember_login_pass" Value:self.mPasswd.text];
        
    } else {
        [Common saveValueKey:@"remember_login_info" Value:@"0"];
    }
    
    NSString* token = [Common getValueKey:@"token"];//@"6c339f5c-3d6a-4e41-82f9-038bfb0dd313";//
    //[Common saveValueKey:@"token" Value:token];
    if(token==nil) {
        [OneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
            if (pushToken) {
                devToken = userId;
                [Common saveValueKey:@"token" Value:userId];
            } else {
                NSLog(@"\n%@", @"ERROR: Could not get a pushToken from Apple! Make sure your provisioning profile has 'Push Notifications' enabled and rebuild your app.");
            }
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Notice!"
                                          message:@"Please try login again."
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
        }];
        return;
    }
    [SVProgressHUD show];
    [[HttpApi sharedInstance] loginWithUsername:self.mEmail.text Password:self.mPasswd.text Token:token Completed:^(NSString *array){
    //[[HttpApi sharedInstance] loginWithUsername:@"rest@email.com" Password:@"rest" Completed:^(NSString *array){
        [SVProgressHUD dismiss];

        //==First milestone test code========
        /*UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Success!"
                                      message:@"Your Account was logined successfully."
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
        return;*/

        NSDictionary* data = (NSDictionary*) array;
        
        NSString* type = [data objectForKey:@"type"];
        [Common saveValueKey:@"login_type" Value:type];
        [Common saveValueKey:@"emailName" Value:self.mEmail.text];
        
        NSString* sID = @"SID_TabBC";
        if(type.integerValue == 0) {
            sID = @"SID_TabBC";
            owner = [[Restaurant alloc] initWithDictionary:data];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController* mVC = [sb instantiateViewControllerWithIdentifier:sID];
            mVC.modalTransitionStyle = UIModalPresentationNone;
            [self presentViewController:mVC animated:YES completion:NULL];
        } else if(type.integerValue == 2){
            deliver = [[Deliver alloc] initWithDictionary:data];
            OrdersAllVC* mVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_OrdersAllVC"];
            [self.navigationController pushViewController:mVC animated:YES];
        } else {
            sID = @"SID_CustomerTabBar";
            customer = [[Customer alloc] initWithDictionary:data];
            if(g_appDelegate.mViewState != 0){
                [self.navigationController popViewControllerAnimated:true];
                g_appDelegate.mViewState = 0;
            } else {
                GuestSelectView* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_GuestSelectView"];
                [self.navigationController pushViewController:mVC animated:YES];
            }
        }
        
    }Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
}

- (IBAction)onLoginWithFacebook:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email"] fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
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
                                        
                                        
                                        
                                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                                         
                                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                             if (!error) {
                                                 NSLog(@"fetched user:%@", result);
                                                 
                                                 NSDictionary *dicResult = (NSDictionary *)result;
                                                 
                                                 self.facebookUserInfo = [[FacebookUserInfo alloc] init];
                                                 
                                                 self.facebookUserInfo.facebookId = dicResult[@"id"];
                                                 self.facebookUserInfo.firstName = dicResult[@"first_name"];
                                                 self.facebookUserInfo.lastName = dicResult[@"last_name"];
                                                 self.facebookUserInfo.email = dicResult[@"email"];
                                                 self.facebookUserInfo.birthday = dicResult[@"birthday"];
                                                 self.facebookUserInfo.gender = dicResult[@"gender"];
                                                 self.facebookUserInfo.location = dicResult[@"location"][@"name"];
                                                 //self.facebookUserInfo.picture = dicResult[@"picture"][@"data"][@"url"];
                                                 
                                                 [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@/picture", self.facebookUserInfo.facebookId] parameters:@{@"redirect": @"false", @"width":@"500", @"height":@"500"}]
                                                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                                      if (!error) {
                                                          NSLog(@"fetched user:%@", result);
                                                          
                                                          NSDictionary *dicResult = (NSDictionary *)result;
                                                          
                                                          self.facebookUserInfo.picture = dicResult[@"data"][@"url"];
                                                          [SVProgressHUD show];
                                                          [[HttpApi sharedInstance]loginFBWithID:(NSString*)self.facebookUserInfo.facebookId
                                                                                            Email:(NSString*)self.facebookUserInfo.email
                                                                                             Name:(NSString*)self.facebookUserInfo.firstName                                             Phone:(NSString*)@""
                                                                                             Completed:^(NSString *tkn){
                                                                                                   
                                                                                                   logtoken = tkn;
                                                                                                 NSDictionary* data = (NSDictionary*) tkn;
                                                                                                 
                                                                                                 NSString* type = [data objectForKey:@"type"];
                                                                                                 [Common saveValueKey:@"token" Value:fbToken];
                                                                                                 [Common saveValueKey:@"emailName" Value:self.facebookUserInfo.email];
                                                                                                 [Common saveValueKey:@"login_type" Value:type];
                                                                                                 [self getMe];
                                                                                                 socialType = @"facebook";
                                                                                                   
                                                                                            }Failed:^(NSString *strError) {
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

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getMe {
    [SVProgressHUD dismiss];
    
    /*UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Success!"
                                  message:@"Your Account was logined successfully."
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                                                        
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];*/

    NSDictionary* data = (NSDictionary*) logtoken;
    
    NSNumber* type = [data objectForKey:@"type"];
    NSString* sID = @"SID_TabBC";
    if(type.integerValue == 0) {
        sID = @"SID_TabBC";
        owner = [[Restaurant alloc] initWithDictionary:data];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController* mVC = [sb instantiateViewControllerWithIdentifier:sID];
        mVC.modalTransitionStyle = UIModalPresentationNone;
        [self presentViewController:mVC animated:YES completion:NULL];
    } else if(type.integerValue == 2){
        deliver = [[Deliver alloc] initWithDictionary:data];
        OrdersAllVC* mVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_OrdersAllVC"];
        [self.navigationController pushViewController:mVC animated:YES];
    } else {
        sID = @"SID_CustomerTabBar";
        customer = [[Customer alloc] initWithDictionary:data];
        if(g_appDelegate.mViewState != 0){
            [self.navigationController popViewControllerAnimated:true];
            g_appDelegate.mViewState = 0;
        } else {
            GuestSelectView* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_GuestSelectView"];
            [self.navigationController pushViewController:mVC animated:YES];
        }
    }
}

@end
