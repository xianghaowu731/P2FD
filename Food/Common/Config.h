//
//  Config.h
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

//======define Keys =================
#define GOOGLE_API_KEY @"AIzaSyDC6xd3oLQW5BamyBwpW2tZb3hsW06fsk4"
#define ONE_SIGNAL_APP_ID @"0daa0889-2a19-4b1f-b358-f257624f2286"

#define STP_PUBLISHABLE_KEY @"pk_live_iIjb741Nt08LBnN1JAaOegJ4" //@"pk_test_xURDLXIe1xAsDYbhGwoOYWhS"//
#define MY_MERCHANT_ID @"merchant.com.patrick.p2fd"

//=================color ======================================
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 120.0) blue:((b) / 50.0) alpha:1.0]
#define PRIMARY_COLOR  [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1.0]
#define WHITE_COLOR  [UIColor colorWithRed:(1.0) green:(1.0) blue:(1.0) alpha:1.0]
#define CONTROLL_EDGE_COLOR  [UIColor colorWithRed:(0.3) green:(0.3) blue:(0.3) alpha:0.2]
#define PRIMARY_TEXT_COLOR [UIColor colorWithRed:(210.0/255.0) green:(159.0/255.0) blue:(50.0/255.0) alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//restaurant status color
#define OPEN_COLOR  [UIColor colorWithRed:(0.0) green:(0.9) blue:(0.0) alpha:1.0]
#define CLOSE_COLOR  [UIColor colorWithRed:(0.5) green:(0.5) blue:(0.5) alpha:1.0]
#define BUSY_COLOR  [UIColor colorWithRed:(0.9) green:(0.0) blue:(0.0) alpha:1.0]
#define ANNOTATION_RESTAURANT_COLOR [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1.0]
#define ANNOTATION_SELF_COLOR [UIColor colorWithRed:(255.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1.0]
#define DATEVIEW_SEL_BG_COLOR [UIColor colorWithRed:(0.0/255.0) green:(255.0/255.0) blue:(0.0/255.0) alpha:1.0]
#define DATEVIEW_SEL_TEXT_COLOR [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0]
#define TIPBTN_SEL_BG_COLOR [UIColor colorWithRed:(0.0/255.0) green:(127.0/255.0) blue:(255.0/255.0) alpha:1.0]
#define TIPBTN_SEL_TEXT_COLOR [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0]

// food detail view's status
#define STATUS_DETAIL @"detail"
#define STATUS_ADD @"add"
#define STATUS_EDIT @"edit"

// order status
#define STATUS_WAITING @"1"
#define STATUS_ACCEPTED @"2"
#define STATUS_REJECTED @"3"
#define STATUS_CANCELED @"4"
#define STATUS_PREPARED @"5"
#define STATUS_DELIVERING @"6"
#define STATUS_COMPLETED @"7"
#define STATUS_MISTAKED @"8"

// food status
#define STATUS_FOOD_ACTIVE @"active"
#define STATUS_FOOD_INACTIVE @"inactive"

//restaurant status
#define STATUS_OPEN @"open"
#define STATUS_CLOSE @"close"
#define STATUS_BUSY @"busy"

//Delivery Fee Constant
#define KM_PER_MILE 1.60934
#define DELIVERY_DEFAULT_DISTANCE 5.0
#define DELIVERY_FEE_PER_DEFAULT 4.99
#define DELIVERY_ADD_FEE 0.5
#define DELIVERY_MILE_PER_MIN 0.4
#define DELIVERY_TAX 0.086      //(8.6%)

//favorite mode
#define MODE_RESTAURANT @"restaurant"
#define MODE_FOOD @"food"

// my type : owner or customer
#define TYPE_OWNER @"0"
#define TYPE_CUSTOMER @"1"
#define TYPE_DRIVER @"2"

//Notification
#define NOTIFICATION_REVIEW_VIEW  @"Notification_REVIEW_VIEW"
#define NOTIFICATION_PICKUP_TIME  @"Notification_PICKUP_TIME"

/*  Server API Url Part*/
#define SERVER_URL @"http://p2fooddeliveries.com/P2FD/"
//#define SERVER_URL @"http://107.180.57.15/RMenu/"

#define ME @"me"

#define FOOD_IMAGE_BASE_URL @"assets/uploads/product/blog_posts/"
#define RESTAURANT_IMAGE_BASE_URL @"assets/uploads/profile/photo/"

#define POST_LOGIN @"api/product/login"
#define POST_LOGOUT @"api/product/logout"
#define POST_LOGIN_FB @"api/product/loginFB"
#define POST_LOGIN_GL @"api/product/loginGL"
#define POST_VERIFY @"api/product/verifyLogin"
#define POST_SIGNUP @"api/product/sign_up"
#define POST_SIGNUP_FB @"api/product/signupFB"
#define POST_FORGOT_PASSWORD @"api/product/forgot_password"
#define POST_SET_REST_LOCATION @"api/product/setLocationByRestid"

#define POST_ADMIN_GET_FOODS_BY_REST_ID @"api/product/admin_foods_resid"
#define POST_ADMIN_GET_QUICK_FOODS_BY_REST_ID @"api/product/admin_quick_foods_resid"
#define POST_ADD_TO_QUICK_BY_FOOD_ID @"api/product/addToQuickMeals"
#define POST_DEL_FROM_QUICK_BY_FOOD_ID @"api/product/delFromQuickMeals"
#define POST_DEL_FOOD_BY_ID @"api/product/delFoodByID"
#define POST_FOOD_IMAGE_UPLOAD @"mobile/product_image_upload.php"
#define POST_FOOD_UPDATE @"api/product/updateFoodByID"
#define POST_REST_IMAGE_UPLOAD @"mobile/avatar_image_upload.php"
#define POST_REST_UPDATE @"api/product/updateRestByID"
#define POST_CUSTOMER_UPDATE @"api/product/updateCustomerByID"
#define POST_GET_RESTS_BY_CUSTOMERID @"api/product/getRestsByUserId"
#define POST_GET_RESTAURANT_BY_RESTID @"api/product/getRestByRestId"
#define POST_GET_REST_FOOD_BY_RESTID @"api/product/getRestAndFoodInfo"
#define POST_GET_REST_BY_RESTID @"api/product/getRestInfo"
#define POST_GET_REST_BY_DRIVER @"api/product/getRestByDriver"

#define POST_ADD_FOOD @"api/product/registerFood"
#define POST_ADD_FOOD_WITH_CATEGORY @"api/product/registerFoodWithCategory"
#define POST_GET_CATEGORY @"api/product/getCategories"
#define POST_GET_FOOD_BY_ID @"api/product/getFoodById"
#define POST_GET_EXTRA_FOODS_BY_FOODID @"api/product/get_extra_foods"

#define POST_GET_MENU_BY_RESTID @"api/product/getMenuByRestId"
#define POST_ADD_MENU_BY_RESTID @"api/product/addMenuByRestId"
#define POST_DEL_MENU_BY_RESTID @"api/product/delMenuByRestId"

#define POST_GET_QUICKMEALS_BY_CUSTOMERID @"api/product/getQuickMealsByUserId"
#define POST_GET_FAVORITES_BY_CUSTOMERID @"api/product/getFavoritesByUserId"
#define POST_GET_ORDERS_BY_CUSTOMERID @"api/order/getOrdersHistoryByUserId"
#define POST_UPDATE_FOOD_FAVORITE @"api/product/updateFoodFavorite"
#define POST_UPDATE_RESTAURANT_FAVORITE @"api/product/updateRestaurantFavorite"
#define POST_DO_ORDER @"api/order"

#define POST_GET_ORDERS_BY_DRIVER_ID @"api/order/getOrdersByDriverId"
#define POST_GET_ORDERS_BY_REST_ID @"api/order/getOrdersByRestId"
#define POST_ADMIN_ORDER_BY_ORDER_ID @"api/product/getAdminOrderByOrderId" //?
#define POST_GET_ORDER_By_ORDER_ID @"api/product/getOrderByOrderId" //?
#define POST_DO_ACCEPT @"api/order/doAccept"
#define POST_DO_REJECT @"api/order/doReject"
#define POST_DO_CANCEL @"api/order/doCancel"
#define POST_DO_READY @"api/order/doReady"
#define POST_DO_DELIVERY @"api/order/doDelivery"
#define POST_DO_COMPLETE @"api/order/doComplete"
#define POST_DO_RANK @"api/product/doRank"
#define POST_DEL_ORDER @"api/order/removeOrder"
#define POST_CHANGE_EMAIL @"api/product/changeEmail"
#define POST_CHANGE_PASSWORD @"api/product/changePassword"
#define POST_CHANGE_PICKUPTIME @"api/order/changePickupTime"
#define POST_DO_MISTAKE @"api/order/doMistake"

#define POST_GET_REVIEWS_BY_REST_ID @"api/product/getReviewsById"
#define POST_UPLOAD_REVIEW @"api/product/doReview"


#define POST_GET_HOT_PRODUCT @"/pro/getHotProducts"
#define POST_GET_PRODUCT @"/pro/getProduct"
#define POST_GET_PRODUCTS @"/pro/getProducts"
#define POST_GET_SCHEDULE_BOAT @"/schedule/getSchedules"
#define POST_GET_FISHS @"/schedule/getFishs"
#define POST_GET_TECHS @"/schedule/getTechs"
#define POST_GET_BOOKS @"/schedule/getBooks"
#define POST_SAVE_ACCOUNT @"/user/login/saveAccount"
#define POST_MODIFY_EMAIL @"/user/login/modifyEmail"
#define POST_MODIFY_PASS @"/user/login/modifyPassword"
#define POST_UPLOADSHOWCASE @"/schedule/uploadShowcase"
#define POST_UPLOADTECH @"/schedule/uploadTechService"
#define POST_REQUEST_CERT @"/schedule/requestCert"
#define POST_GET_BOAT_NUMS @"/schedule/getBoatNums"
#define POST_BOOKING_PREVIEW @"/schedule/bookingPreview"
#define POST_BOOKING_REQUEST @"/schedule/bookingRequest"
#define POST_BOOKING @""
#define POST_GET_CERT_PRICE @"/schedule/getCertPrice"
#define POST_DELETE_BOOK_ITEM @"/schedule/deleteBookItem"
#define POST_REGISTER_GCM_TOKEN @"/schedule/registerGCMToken"
#define POST_UNREGISTER_GCM_TOKEN @"/schedule/unRegisterGCMToken"
#define POST_REFUND @"/schedule/refundRequest"
#define POST_BOOK_PROCESS @"/schedule/bookProcessRequest"

#define JOIN_US_TXT @"Join Us for P2FoodDelivery App \n\n  1.This App is App that customers find nearby restaurants and order foods. \n  2.Owners can register them restaurants and serve foods to customers. \n  3.App support several payments such as Apple Pay and Credit Card.  \n\nContact manager at p2fooddelivery.com or phone number: 5207953400 ";


