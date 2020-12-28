//
//  AppDelegate.h
//  Food
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import "UserTabVC.h"

@class AppDelegate;

extern NSString* logtoken;
extern NSString* devToken;
extern NSString* socialType;
extern NSString *g_address;
extern NSString *g_toFirst,*g_toLast,*g_toPhone;
extern NSString *g_latitude,*g_longitude;
extern BOOL g_isUpdatedLocation;
extern BOOL g_isChangeDateTime;
extern BOOL g_isRestOrder;
extern BOOL g_isMistakeOrder;
extern float g_subprice;
extern AppDelegate *g_appDelegate;
extern NSString *g_deliveryTime;
extern NSInteger g_tipPercent;
extern NSMutableArray *g_Restaurants;

@protocol updateNotifications <NSObject>

-(void)updateNotificationDetails:(NSString *)badgeNumber;
@end


@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) id<updateNotifications> notificationDelegate;

@property (strong, nonatomic) NSString *unreadNotificationsCount;
@property (strong, nonatomic) NSString *unreadNotificationId;

@property (nonatomic) NSInteger mViewState;
@property (nonatomic) UITabBarController *mTabVC;

@property (nonatomic, assign) NSInteger mPayMethod;

@end

