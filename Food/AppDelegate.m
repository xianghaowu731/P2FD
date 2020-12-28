//
//  AppDelegate.m
//  Food
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "Config.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
#import <OneSignal/OneSignal.h>
#import <Stripe.h>


@interface AppDelegate ()

@end

NSString* logtoken;
NSString* devToken;
NSString* socialType;
NSString *g_address;
NSString *g_toFirst,*g_toLast,*g_toPhone;
NSString *g_latitude,*g_longitude;
BOOL g_isUpdatedLocation;
NSMutableArray *g_Restaurants;
NSString *g_deliveryTime;
BOOL g_isChangeDateTime;
BOOL g_isRestOrder;
BOOL g_isMistakeOrder;
float g_subprice;
NSInteger g_tipPercent;
AppDelegate *g_appDelegate;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey:GOOGLE_API_KEY];
    //[GMSServices provideAPIKey:GOOGLE_API_KEY];
    //configure it with your Stripe API keys
    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:STP_PUBLISHABLE_KEY];
    [[STPPaymentConfiguration sharedConfiguration] setAppleMerchantIdentifier:MY_MERCHANT_ID];
    
    g_appDelegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    // One Signal
    
    // (Optional) - Create block the will fire when a notification is recieved while the app is in focus.
    id notificationRecievedBlock = ^(OSNotification *notification) {
        OSNotificationPayload* payload = notification.payload;
        NSString *noti_id = payload.additionalData[@"notification_id"];
        if([noti_id integerValue] > 0 && [noti_id integerValue] < 10)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeOrderStatus" object:self userInfo:nil];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"GetNotification" object:self userInfo:@{@"notification_id":payload.additionalData[@"notification_id"]}];
        
        [AppDelegate increaseUnreadNotificationsCount:payload.additionalData];
    };
    
    // (Optional) - Create block that will fire when a notification is tapped on.
    id notificationOpenedBlock = ^(OSNotificationOpenedResult *result) {
        OSNotificationPayload* payload = result.notification.payload;
        
        NSString *noti_id = payload.additionalData[@"notification_id"];
        if([noti_id integerValue] > 0 && [noti_id integerValue] < 10)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeOrderStatus" object:self userInfo:nil];
    };
    
    // (Optional) - Configuration options for OneSignal settings.
    id oneSignalSetting = @{kOSSettingsKeyInFocusDisplayOption : @(OSNotificationDisplayTypeNotification), kOSSettingsKeyAutoPrompt : @YES};
    
    // (REQUIRED) - Initializes OneSignal
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:ONE_SIGNAL_APP_ID
          handleNotificationReceived:notificationRecievedBlock
            handleNotificationAction:notificationOpenedBlock
                            settings:oneSignalSetting];
    /*
    OSPermissionSubscriptionState* status = [OneSignal getPermissionSubscriptionState];
    
    devToken = status.subscriptionStatus.userId;
    [Common saveValueKey:@"token" Value:devToken];*/
    
    //if(devToken == nil){
        [OneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
            if (pushToken) {
                //self.textMultiLine1.text = [NSString stringWithFormat:@"PlayerId:\n%@\n\nPushToken:\n%@\n", userId, pushToken];
                NSLog(@"UserId-  %@, pushToken-  %@", userId, pushToken);
                //oneID = userId;
                devToken = userId;
                [Common saveValueKey:@"token" Value:userId];
            } else {
                //self.textMultiLine1.text = @"ERROR: Could not get a pushToken from Apple! Make sure your provisioning profile has 'Push Notifications' enabled and rebuild your app.";
                
                NSLog(@"\n%@", @"ERROR: Could not get a pushToken from Apple! Make sure your provisioning profile has 'Push Notifications' enabled and rebuild your app.");
            }
        }];
    //}
    
    /*-----------------------facebook login----------------------------------*/
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    //------------------------------------------------------------------------//
    //=======================google signin=================================//
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    //=======================================================================//
    
    g_address = @"";
    g_latitude = @"";
    g_longitude = @"";
    g_toLast = @"";
    g_toFirst = @"";
    g_toPhone = @"";
    g_isUpdatedLocation = false;
    g_isRestOrder = false;
    g_isMistakeOrder = false;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

/****************************************************
 *          Google / Facebook Signin part           *
 ****************************************************/

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    BOOL stripeHandled = [Stripe handleStripeURLCallbackWithURL:url];
    if (stripeHandled) {
        return YES;
    } else {
        NSString* urlStr = url.absoluteString;
        NSString* preChar = @"";
        for(int i=0;i<2;i++) {
            char character = [urlStr characterAtIndex:i];
            preChar = [NSString stringWithFormat:@"%@%c", preChar, character];
        }
        if([preChar isEqualToString:@"fb"]) {
            return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        } else {
            return [[GIDSignIn sharedInstance] handleURL:url
                                       sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                              annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
            
        }
    }
    
}

// for ios8 or older version
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL stripeHandled = [Stripe handleStripeURLCallbackWithURL:url];
    if (stripeHandled) {
        return YES;
    } else {
        NSString* urlStr = url.absoluteString;
        NSString* preChar = @"";
        for(int i=0;i<2;i++) {
            char character = [urlStr characterAtIndex:i];
            preChar = [NSString stringWithFormat:@"%@%c", preChar, character];
        }
        if([preChar isEqualToString:@"fb"]) {
            return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation];
        } else {
            return [[GIDSignIn sharedInstance] handleURL:url
                                       sourceApplication:sourceApplication
                                              annotation:annotation];
            
        }
    }
    
}

// This method handles opening universal link URLs (e.g., "https://example.com/stripe_ios_callback")
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
        if (userActivity.webpageURL) {
            BOOL stripeHandled = [Stripe handleStripeURLCallbackWithURL:userActivity.webpageURL];
            if (stripeHandled) {
                return YES;
            } else {
                // This was not a stripe url – do whatever url handling your app
                // normally does, if any.
            }
            return NO;
        }
    }
    return NO;
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    //NSString *userId = user.userID;                  // For client-side use only!
    //NSString *idToken = user.authentication.idToken; // Safe to send to the server
    //NSString *fullName = user.profile.name;
    //NSString *givenName = user.profile.givenName;
    //NSString *familyName = user.profile.familyName;
    //NSString *email = user.profile.email;
    // ...
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

//================================================
//Register For notifications
//================================================


// RemoteNotification
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *token=[NSString stringWithFormat:@"%@",deviceToken];
    token=[Common replaceStringwithString:token strTobeReplaced:@"<" stringReplaceWith:@""];
    token= [Common replaceStringwithString:token strTobeReplaced:@">" stringReplaceWith:@""];
    token =[Common removeSpaces:token];
    /*NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
     token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
     NSLog(@"content---%@", token);*/
    
    //devToken = token;
   //[Common saveValueKey:@"token" Value:token];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // NSLog(@"Error %@",error.localizedDescription);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *badgenumber=[NSString stringWithFormat:@"%@",userInfo[@"aps"][@"badge"]];
    [self.notificationDelegate updateNotificationDetails:badgenumber];
    [[Common simpleAlert:@"Notification" desc:userInfo[@"aps"][@"alert"]] show];
    
    NSLog(@"Push received: %@", userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)increaseUnreadNotificationsCount:(NSDictionary *)userInfo
{
    if(g_appDelegate.unreadNotificationsCount == nil)
        return;
    
    g_appDelegate.unreadNotificationsCount = [NSString stringWithFormat:@"%ld", [g_appDelegate.unreadNotificationsCount integerValue] + 1];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [g_appDelegate.unreadNotificationsCount integerValue];
    [[Common simpleAlert:@"Notification" desc:userInfo[@"alert"]] show];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"UnreadNotificationsCountChanged" object:self userInfo:nil];
}


@end
