//
//  HttpApi.m
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//
#import "HttpApi.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "Config.h"
#import "Common.h"

@implementation HttpApi

HttpApi *sharedObj = nil;
AFHTTPRequestOperationManager *manager;

+(id) sharedInstance{
    
    if(!sharedObj)
    {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            sharedObj = [[self alloc] init] ;
            manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/html", nil];
        });
    }
    
    return sharedObj;
}

- (void)loginWithUsername:(NSString *)username
                 Password:(NSString *)password
                    Token:(NSString *)token
                Completed:(void (^)(NSString *))completed
                   Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_LOGIN];
    NSDictionary *parameters = @{
                                 @"email":username,
                                 @"password":password,
                                 @"token":token
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSNumber* status = [dicResponse valueForKey:@"status"];
        if(status != nil) {
            if([status intValue]== 0) {
                NSString *strErrorMsg = @"Incorrect Login";
                failed(strErrorMsg);
            } else {
                NSString *strErrorMsg = @"Login failed!";
                failed(strErrorMsg);
            }
        } else {
            NSString *email = [dicResponse objectForKey:@"email"];
            if(![email isEqual:nil])
                completed(responseObject);
            else {
                NSString *strErrorMsg = @"Login failed!";
                failed(strErrorMsg);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)loginFBWithID:(NSString *)fbID
                Email:(NSString *)email
                 Name:(NSString *)name
                Phone:(NSString *)phone
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_LOGIN_FB];
    if(phone == nil) phone = @"";
    NSDictionary *parameters = @{
                                 @"fb_id":fbID,
                                 @"email":email,
                                 @"username":name,
                                 @"phone":phone
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Access Error : Unregistered User";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
    
}

- (void)loginGLWithID:(NSString *)glID
                Email:(NSString *)email
                 Name:(NSString *)name
             LastName:(NSString *)last_name
            FirstName:(NSString *)first_name
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_LOGIN_GL];
    NSDictionary *parameters = @{
                                 @"gl_id":glID,
                                 @"email":email,
                                 @"username":name,
                                 @"lastname":last_name,
                                 @"firstname":first_name
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString *products = [dicResponse objectForKey:@"data"];
        completed(products);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)verifyAccountServiceWithID:(NSString *)fbID
                           FBEmail:(NSString *)fbEmail
                             Email:(NSString *)email
                            Reason:(NSString *)reason
                          Password:password
                         Completed:(void (^)(NSString *))completed
                            Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_LOGIN_FB];
    NSDictionary *parameters = @{
                                 @"fbId":fbID,
                                 @"fb_email":fbEmail,
                                 @"email":email,
                                 @"password":password,
                                 @"reason":reason
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)SignupFBWithID:(NSString *)fbID
                 Email:(NSString *)email
                  Name:(NSString *)name
                 Phone:(NSString *)phone
                  Type:(NSString *)type
             Completed:(void (^)(NSString *))completed
                Failed:(void (^)(NSString *))failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_SIGNUP_FB];
    NSDictionary *dicParams = @{
                                @"fb_id":fbID,
                                @"username":name,
                                @"email":email,
                                @"phone":phone,
                                @"type":type,
                                };
    
    NSURL *URL = [NSURL URLWithString:url];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSNumber* status = [dicResponse objectForKey:@"status"];
        if([status intValue])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network Error!");
    }];
    

}

- (void)registerWithUsername:(NSString *)username
                       Email:(NSString *)email
                       Phone:(NSString *)phone
                    Password:(NSString *)password
                        Type:(NSString *)type
                   Completed:(void (^)(NSString *))completed
                      Failed:(void (^)(NSString *))failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_SIGNUP];
    NSDictionary *dicParams = @{
                                @"username":username,
                                @"email":email,
                                @"password":password,
                                @"phone":phone,
                                @"type":type
                                };
    
    NSURL *URL = [NSURL URLWithString:url];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSNumber* status = [dicResponse objectForKey:@"status"];
        if([status intValue])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Registration failed. The email provided is already in use.";//[dicResponse objectForKey:@"error"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network Error!");
    }];
    
}

- (void)saveAccountWithUserId:(NSString *) userId
                         Name:(NSString *)username
                 PhoneNumber:(NSString *)phoneNumber
                    Birthday:(NSString *)birthday
                      Weixin:(NSString *)weixin
                   Completed:(void (^)(NSString *))completed
                      Failed:(void (^)(NSString *))failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_SIGNUP];
    NSDictionary *dicParams = @{
                                @"userId":userId,
                                @"username":username,
                                @"phoneNumber":phoneNumber,
                                @"birthday":birthday,
                                @"weixin":weixin,
                                };
    
    NSURL *URL = [NSURL URLWithString:url];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network Error!");
    }];
    
}

- (void)modifyEmailWithUserId:(NSString *) userId
                         Email:(NSString *)email
                  Password:(NSString *)password
                     NewEmail:(NSString *)newEmail
                    Completed:(void (^)(NSString *))completed
                       Failed:(void (^)(NSString *))failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_MODIFY_EMAIL];
    NSDictionary *dicParams = @{
                                @"userId":userId,
                                @"email":email,
                                @"password":password,
                                @"newEmail":newEmail,
                                };
    
    NSURL *URL = [NSURL URLWithString:url];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network Error!");
    }];
    
}

- (void)modifyPasswordWithUserId:(NSString *) userId
                         Email:(NSString *)email
                  OldPassword:(NSString *)oldPassword
                     NewPassword:(NSString *)newPassword
                    Completed:(void (^)(NSString *))completed
                       Failed:(void (^)(NSString *))failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_CHANGE_PASSWORD];
    NSDictionary *dicParams = @{
                                @"email":email,
                                @"old_pass":oldPassword,
                                @"new_pass":newPassword,
                                };
    
    NSURL *URL = [NSURL URLWithString:url];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        NSInteger value = [status integerValue];
        if(value == 1)
        {
            NSString *products = @"Your Password is changed successfully.";
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = [dicResponse objectForKey:@"message"];//@"Network error";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network Error!");
    }];
    
}

- (void)forgotPassWithEmail:(NSString *)email
                   Completed:(void (^)(NSString *))completed
                      Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_FORGOT_PASSWORD];
    NSDictionary *parameters = @{
                                 @"email":email
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"Please check your email";//[dicResponse objectForKey:@"message"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = [dicResponse objectForKey:@"error"];//;@"Network error"
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)logoutWithUserId:(NSString *)userId
                   Completed:(void (^)(NSString *))completed
                      Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_LOGOUT];
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Login failed. Please login again.";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)getFoodById:(NSString *)Id
                     Completed:(void (^)(NSDictionary *))completed
                        Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_FOOD_BY_ID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"foodId":Id
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Food Detail error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getRestCategory:(void (^)(NSString *))completed
           Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_CATEGORY];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Loading failed.";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getRestMenuByRestId:(NSString* )restId
                  Completed:(void (^)(NSString *))completed
                     Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_MENU_BY_RESTID];
    NSDictionary *parameters = @{ @"restId":restId
                                  };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Menu loading failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)addRestMenuByRestId:(NSString* )restId
                       Name:(NSString* )name
                  Completed:(void (^)(NSString *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_ADD_MENU_BY_RESTID];
    NSDictionary *parameters = @{ @"restId":restId,
                                  @"title":name
                                  };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"success";//[dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"AddMenu failed!";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)delRestMenuByRestId:(NSString* )menuId
                  Completed:(void (^)(NSString *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DEL_MENU_BY_RESTID];
    NSDictionary *parameters = @{ @"menuId":menuId
                                  };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"success";//[dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Delete failed!";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getAdminFoodsByRestId:(NSString*)restId
                    Completed:(void (^)(NSString *))completed
                       Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_ADMIN_GET_FOODS_BY_REST_ID];
    NSDictionary *parameters = @{ @"restId":restId
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Data loading failed.";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getAdminQuickFoodsByRestId:(NSString*)restId
                    Completed:(void (^)(NSString *))completed
                       Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_ADMIN_GET_QUICK_FOODS_BY_REST_ID];
    NSDictionary *parameters = @{ @"restId":restId
                                  };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Data loading failed.";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)addToQuickMealsByFoodId:(NSString* ) foodId
                      Completed:(void (^)(NSString *))completed
                         Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_ADD_TO_QUICK_BY_FOOD_ID];
    NSDictionary *parameters = @{ @"foodId":foodId
                                  };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"";//[dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];

}
- (void)delFromQuickMealsByFoodId:(NSString* ) foodId
                      Completed:(void (^)(NSString *))completed
                         Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DEL_FROM_QUICK_BY_FOOD_ID];
    NSDictionary *parameters = @{ @"foodId":foodId
                                  };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"";//[dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Delete failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}
- (void)delFoodByFoodId:(NSString* ) foodId
                        Completed:(void (^)(NSString *))completed
                           Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DEL_FOOD_BY_ID];
    NSDictionary *parameters = @{ @"foodId":foodId
                                  };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"";//[dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Delete failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)foodImagePost:(NSData *)photo
                  Completed:(void (^)(NSString *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_FOOD_IMAGE_UPLOAD];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       }];
    
    [manager POST:urlStr
       parameters:dicParams
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:[NSData dataWithData:photo]
                                name:@"uploaded_file"
                            fileName:@"image.jpg"
                            mimeType:@"image/jpg"];
}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              NSDictionary *dicResponse = (NSDictionary *)responseObject;
              NSString* status = [dicResponse objectForKey:@"status"];
              if([status isEqualToString:@"success"])
              {
                  NSString *data = [dicResponse objectForKey:@"file_name"];
                  completed(data);
              }
              else
              {
                  NSString *strErrorMsg = @"Image post failed";//[dicResponse objectForKey:@"message"];
                  failed(strErrorMsg);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failed(@"Network error!!!");
          }];
}

- (void)registerFoodWithCategory:(NSString *)restId
                name:(NSString *)name
         Description:(NSString *)description
               price:(NSString *)price
              status:(NSString *)status
               image:(NSString *)image
            Category:(NSString *)category
               Extra:(NSString *)extra
           Completed:(void (^)(NSString *))completed
              Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_ADD_FOOD_WITH_CATEGORY];
    NSDictionary *dicParams = @{@"restId":restId,
                                @"name":name,
                                @"description":description,
                                @"price":price,
                                @"status":status,
                                @"image":image,
                                @"category":category,
                                @"extra":extra
                                };
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"Food is registered successfully";//[dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Food register failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)getExtraFoodsByFoodId:(NSString *)fId
                    Completed:(void (^)(NSArray *))completed
                       Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_EXTRA_FOODS_BY_FOODID];
    NSDictionary *dicParams = @{@"food_id":fId
                                };
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSArray *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Food register failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)registerFood:(NSString *)restId
                name:(NSString *)name
         Description:(NSString *)description
               price:(NSString *)price
              status:(NSString *)status
               image:(NSString *)image
           Completed:(void (^)(NSString *))completed
              Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_ADD_FOOD];
    NSDictionary *dicParams = @{@"restId":restId,
                                @"name":name,
                                @"description":description,
                                @"price":price,
                                @"status":status,
                                @"image":image
                                };
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"Food is registered successfully";//[dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Food register failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];

}

- (void)uploadFoodByFoodId:(NSString *)foodId
                       name:(NSString *)name
                 Description:(NSString *)description
                     price:(NSString *)price
                    status:(NSString *)status
                        image:(NSString *)image
                        Extra:(NSString *)extra
                   Completed:(void (^)(NSString *))completed
                      Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_FOOD_UPDATE];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"foodId":foodId,
                                                                                       @"name":name,
                                                                                       @"description":description,
                                                                                       @"price":price,
                                                                                       @"status":status,
                                                                                       @"image":image,
                                                                                       @"extra":extra
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"";//[dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Upload failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)restImagePost:(NSData *)photo
                   id:(NSString *)restId
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_REST_IMAGE_UPLOAD];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{ @"id":restId }];
    
    [manager POST:urlStr
       parameters:dicParams
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:[NSData dataWithData:photo]
                                name:@"uploaded_file"
                            fileName:@"image.jpg"
                            mimeType:@"image/jpg"];
    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              NSDictionary *dicResponse = (NSDictionary *)responseObject;
              NSString* status = [dicResponse objectForKey:@"status"];
              if([status isEqualToString:@"success"])
              {
                  NSString *data = [dicResponse objectForKey:@"avatar"];
                  completed(data);
              }
              else
              {
                  NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
                  failed(strErrorMsg);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failed(@"Network error!!!");
          }];
}

- (void)uploadRestByRestId:(NSString *)restId
                      name:(NSString *)name
                     email:(NSString *)email
               Description:(NSString *)description
                     phone:(NSString *)phone
                  worktime:(NSString *)worktime
                    status:(NSString *)status
                     image:(NSString *)image
                   Address:(NSString *)address
                  Location:(NSString *)location
                 Completed:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_REST_UPDATE];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"restId":restId,
                                                                                       @"email":email,
                                                                                       @"name":name,
                                                                                       @"description":description,
                                                                                       @"phone":phone,
                                                                                       @"worktime":worktime,
                                                                                       @"status":status,
                                                                                       @"image":image,
                                                                                       @"address":address,
                                                                                       @"location":location
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"";//[dicResponse objectForKey:@"avatar"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Update Failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getRestByCustomerId:(NSString *)customerId
                  Completed:(void (^)(NSArray *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_RESTS_BY_CUSTOMERID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"customer_id":customerId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSArray *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Getting Restaurant Info Failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getRestByRestId:(NSString *)restId
              Completed:(void (^)(NSDictionary *))completed
                 Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_RESTAURANT_BY_RESTID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"rest_id":restId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Getting Restaurant Info Failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getRestInfoByRestId:(NSString *)restId
                 CustomerId:(NSString *)customerId
                  Completed:(void (^)(NSDictionary *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_REST_BY_RESTID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"restaurant_id":restId,
                                                                                       @"customer_id":customerId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Getting Restaurant Info Failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getRestInfoByDriver:(NSString *)restId
                  Completed:(void (^)(NSDictionary *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_REST_BY_DRIVER];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"restaurant_id":restId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Getting Restaurant Info Failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getRestAndFoodInfoByRestId:(NSString *)restId
                 CustomerId:(NSString *)customerId
                  Completed:(void (^)(NSDictionary *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_REST_FOOD_BY_RESTID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"restaurant_id":restId,
                                                                                       @"customer_id":customerId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Getting Restaurant Info Failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getQuickMealsByCustomerId:customerId
                  Completed:(void (^)(NSArray *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_QUICKMEALS_BY_CUSTOMERID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"customer_id":customerId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSArray *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Data loading failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getFavoritesByCustomerId:customerId
                        Completed:(void (^)(NSDictionary *))completed
                           Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_FAVORITES_BY_CUSTOMERID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"customer_id":customerId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Data loading failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getOrdersByCustomerId:customerId
                        Completed:(void (^)(NSArray *))completed
                           Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_ORDERS_BY_CUSTOMERID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"customer_id":customerId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSArray *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Orders Loading Failed";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}




- (void)updateFoodFavoriteByCustomerId:(NSString *)customerId
                                FoodId:(NSString *)foodId
                             Completed:(void (^)(long))completed
                       Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_UPDATE_FOOD_FAVORITE];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"customer_id":customerId,
                                                                                       @"food_id":foodId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSNumber* products = [dicResponse valueForKey:@"data"];
            
            completed([products longValue]);
        }
        else
        {
            NSString *strErrorMsg = @"Update failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)updateRestaurantFavoriteByCustomerId:(NSString *)customerId
                                      RestId:(NSString *)restId
                             Completed:(void (^)(long))completed
                                Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_UPDATE_RESTAURANT_FAVORITE];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"customer_id":customerId,
                                                                                       @"rest_id":restId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSNumber *products = [dicResponse objectForKey:@"data"];
            completed([products longValue]);
        }
        else
        {
            NSString *strErrorMsg = @"Update failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getLocationByRestId:(NSString *)restId
                   Location:(NSString *)location
                  Completed:(void (^)(NSString *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_SET_REST_LOCATION];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"restId":restId,
                                                                                       @"location":location
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"";//[dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Update failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doOrderByCustomerId:(NSString *)customerId
                    foodIds:(NSString *)foodIds
                 totalPrice:(NSString *)totalPrice
                    comment:(NSString *)comment
                     restId:(NSString *)restId
                    Address:(NSString *)address
                   SubPrice:(NSString *)subprice
                DeliveryFee:(NSString *)deliveryfee
                   TipPrice:(NSString *)tipprice
                   FromTime:(NSString *)fromtime
                   Location:(NSString *)location
                   TouFirst:(NSString *)ufirst
                    TouLast:(NSString *)uLast
                   TouPhone:(NSString *)uPhone
                Instruction:(NSString *)uInst
                      Token:(NSString *)token
                  Completed:(void (^)(NSString *))completed
                                Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DO_ORDER];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSString* ptime = [inputFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"customer_id":customerId,
                                                                                       @"orderfoods":foodIds,
                                                                                       @"total_price":totalPrice,
                                                                                       @"comment":comment,
                                                                                       @"restaurant_id":restId,
                                                                                       @"address":address,
                                                                                       @"subprice":subprice,
                                                                                       @"deliveryfee":deliveryfee,
                                                                                       @"tipprice":tipprice,
                                                                                       @"fromtime":fromtime,
                                                                                       @"location":location,
                                                                                       @"ufirst":ufirst,
                                                                                       @"ulast":uLast,
                                                                                       @"uphone":uPhone,
                                                                                       @"cardtoken":token,
                                                                                       @"instruction":uInst,
                                                                                       @"publishtime":ptime
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"";//[dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Order failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getOrdersByDriverId:(NSString *)deliverID
                Completed:(void (^)(NSArray *))completed
                   Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_ORDERS_BY_DRIVER_ID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"driver_id":deliverID
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSArray *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Data loading failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getOrdersByRestId:(NSString *)restId
                Completed:(void (^)(NSArray *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_ORDERS_BY_REST_ID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"rest_id":restId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSArray *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Data loading failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getAdminOrderByorderId:(NSString *)orderId
                     Completed:(void (^)(NSDictionary *))completed
                   Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_ADMIN_ORDER_BY_ORDER_ID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"order_id":orderId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Data loading failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getOrderByOrderId:(NSString *)orderId
                     Completed:(void (^)(NSDictionary *))completed
                        Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_ORDER_By_ORDER_ID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"order_id":orderId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Data loading failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doAccept:(NSString *)orderId
        DriverID:(NSString *)driverId
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DO_ACCEPT];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSString* ptime = [inputFormatter stringFromDate:[NSDate date]];
    NSDictionary *dicParams = @{ @"order_id":orderId,
                                 @"driver_id":driverId,
                                 @"publishtime":ptime
                                 };
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, NSString *responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"order_id"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Accept failed. This order was accepted by other.";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doCancel:(NSString *)orderId
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DO_CANCEL];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"order_id":orderId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Cancel failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doComplete:(NSString *)orderId
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DO_COMPLETE];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSString* ptime = [inputFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"order_id":orderId,
                                                                                       @"publishtime":ptime,
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Complete failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doReady:(NSString *)orderId
         Completed:(void (^)(NSDictionary *))completed
            Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DO_READY];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSString* ptime = [inputFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"order_id":orderId,
                                                                                       @"publishtime":ptime
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Complete failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doDelivery:(NSString *)orderId
         Completed:(void (^)(NSDictionary *))completed
            Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DO_DELIVERY];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSString* ptime = [inputFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"order_id":orderId,
                                                                                       @"publishtime":ptime
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Complete failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doDelete:(NSString *)orderId
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DEL_ORDER];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"order_id":orderId
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Delecte failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)changePickupTime:(NSString *)orderId
              Pickuptime:(NSString *)pick_time
               Completed:(void (^)(NSString *))completed
                  Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_CHANGE_PICKUPTIME];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"order_id":orderId,
                                                                                       @"pickup_time":pick_time
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"success";
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doReject:(NSString *)orderId
          Reason:(NSString *)reason
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DO_REJECT];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSString* ptime = [inputFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"order_id":orderId,
                                                                                       @"publishtime":ptime,
                                                                                       @"reason":reason
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, NSString *responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Reject failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doMistake:(NSString *)orderId
           Reason:(NSString *)reason
        Completed:(void (^)(NSString *))completed
           Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DO_MISTAKE];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSString* ptime = [inputFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"order_id":orderId,
                                                                                       @"publishtime":ptime,
                                                                                       @"reason":reason
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, NSString *responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"Mistaked Order is noticed.";//[dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Reject failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}


- (void)doRank:(NSString *)restId
          mark:(NSNumber* )mark
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DO_RANK];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"rest_id":restId,
                                                                                       @"mark":mark
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Set rank failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)changeEmail:(NSString *)oldemail
              Email:(NSString *)email
           Password:(NSString *)password
       Completed:(void (^)(NSString *))completed
          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_CHANGE_EMAIL];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"old_email":oldemail,
                                                                                       @"new_email":email,
                                                                                       @"password":password
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"message"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Wrong password or Network error!";//@"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)changePassword:(NSString *)email
           oldpassword:oldPassword
           newPassword:newPassword
          Completed:(void (^)(NSDictionary *))completed
             Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_CHANGE_PASSWORD];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"email":email,
                                                                                       @"old_passwd":oldPassword,
                                                                                       @"new_passwd":newPassword
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Password changing failed.";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}









































- (void)getHotProductCompleted:(void (^)(NSString *))completed
                        Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_HOT_PRODUCT];
    NSDictionary *parameters = @{
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)getProductWithId:(NSString *)productId
                  Completed:(void (^)(NSString *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_PRODUCT];
    NSDictionary *parameters = @{
                                 @"productId":productId,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)getProductsWithKind:(NSString *)kind
                  Completed:(void (^)(NSString *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_PRODUCTS];
    NSDictionary *parameters = @{
                                 @"kind":kind,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void) getScheduleBoatsCompleted:(void (^)(NSString *))completed
                            Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_SCHEDULE_BOAT];
    NSDictionary *parameters = @{
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void) getFishsWithSeaName:(NSString *) sea
                   Completed:(void (^)(NSString *))completed
                            Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_FISHS];
    NSDictionary *parameters = @{
                                 @"sea":sea
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void) getTechsCompleted:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_TECHS];
    NSDictionary *parameters = @{
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)getBooksWithUserId:(NSString *)userId
                  Completed:(void (^)(NSString *))completed
                     Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_BOOKS];
    NSDictionary *parameters = @{
                                 @"userId":userId
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}


- (void)uploadShowcaseWithUserId:(NSString *)userId
                             Sea:(NSString *)sea
                            Date:(NSString *)date
                         BoatNum:(NSString *)boatNum
                           title:(NSString *)title
                     Description:(NSString *)description
                            File:(NSData *)photo
                       Completed:(void (^)(NSString *))completed
                          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_UPLOADSHOWCASE];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"userId":userId,
                                                                                       @"sea":sea,
                                                                                       @"date":date,
                                                                                       @"boatNum":boatNum,
                                                                                       @"title":title,
                                                                                       @"description":description,
                                                                                       }];
    [manager POST:urlStr
       parameters:dicParams
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:[NSData dataWithData:photo]
                                name:@"file"
                            fileName:@"image.jpg"
                            mimeType:@"image/jpeg"];
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failed(@"Network error!!!");
          }];
}

- (void)uploadTechWithUserId:(NSString *)userId
                           title:(NSString *)title
                     Description:(NSString *)description
                            File:(NSData *)photo
                       Completed:(void (^)(NSString *))completed
                          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_UPLOADTECH];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"userId":userId,
                                                                                       @"title":title,
                                                                                       @"description":description,
                                                                                       }];
    [manager POST:urlStr
       parameters:dicParams
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:[NSData dataWithData:photo]
                                name:@"file"
                            fileName:@"image.jpg"
                            mimeType:@"image/jpeg"];
}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              NSDictionary *dicResponse = (NSDictionary *)responseObject;
              NSString* status = [dicResponse objectForKey:@"status"];
              if([status isEqualToString:@"success"])
              {
                  NSString *products = [dicResponse objectForKey:@"data"];
                  completed(products);
              }
              else
              {
                  NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
                  failed(strErrorMsg);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failed(@"Network error!!!");
          }];
}

- (void)requestCertWithFile:(NSData *)photo
                       Completed:(void (^)(NSNumber *))completed
                          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_REQUEST_CERT];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       }];
    [manager POST:urlStr
       parameters:dicParams
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:[NSData dataWithData:photo]
                                name:@"file"
                            fileName:@"image.png"
                            mimeType:@"image/png"];
}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              NSDictionary *dicResponse = (NSDictionary *)responseObject;
              NSString* status = [dicResponse objectForKey:@"status"];
              if([status isEqualToString:@"success"])
              {
                  NSNumber *data = [dicResponse objectForKey:@"data"];
                  completed(data);
              }
              else
              {
                  NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
                  failed(strErrorMsg);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failed(@"Network error!!!");
          }];
}


- (void)getBoatNumsCompleted:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_BOAT_NUMS];
    NSDictionary *parameters = @{
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)bookingWithUserId:(NSString *)userId
                      ScheduleId:scheduleId
                   CertRequestId:certRequestId
                      ProductIds:productIds
                       Completed:(void (^)(NSString *))completed
                          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_BOOKING];
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"scheduleId":scheduleId,
                                 @"certRequestId":certRequestId,
                                 @"productIds":productIds
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)bookingPreviewWithUserId:(NSString *)userId
                      ScheduleId:scheduleId
                   CertRequestId:certRequestId
                      ProductIds:productIds
                 Completed:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_BOOKING_PREVIEW];
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"scheduleId":scheduleId,
                                 @"certRequestId":certRequestId,
                                 @"productIds":productIds
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)bookingRequestWithUserId:(NSString *)userId
                      ScheduleId:scheduleId
                   CertRequestId:certRequestId
                      ProductIds:productIds
                       PaymentId:paymentId
                          Amount:amount
                            Unit:unit
                       Completed:(void (^)(NSString *))completed
                          Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_BOOKING_REQUEST];
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"scheduleId":scheduleId,
                                 @"certRequestId":certRequestId,
                                 @"productIds":productIds,
                                 @"paymentId":paymentId,
                                 @"amount":amount,
                                 @"unit":unit
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)getCertPriceCompleted:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_CERT_PRICE];
    NSDictionary *parameters = @{
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"price"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}


- (void)deleteBookItemWithUserId:(NSString *)userId
                          BookId:bookId
                 Completed:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DELETE_BOOK_ITEM];
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"bookId":bookId
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}


- (void)registerGCMTokenWithUserId:(NSString *)userId
                             Token:token
                 Completed:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_REGISTER_GCM_TOKEN];
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}


- (void)unregisterGCMTokenWithUserId:(NSString *)userId
                 Completed:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_UNREGISTER_GCM_TOKEN];
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)refundRequestWithUserId:(NSString *)userId
                         BookId:bookId
                 Completed:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_REFUND];
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"bookId":bookId
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)bookProcessRequestWithUserId:(NSString *)userId
                              BookId:bookId
                         AdminPasswd:adminPasswd
                 Completed:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_BOOK_PROCESS];
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"bookId":bookId,
                                 @"adminPasswd":adminPasswd
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)uploadCustomerByCustomerId:(NSString *)customerId
                         FirstName:(NSString *)firstName
                          LastName:(NSString *)lastName
                             Email:(NSString *)email
                             Phone:(NSString *)phone
                           Address:(NSString *)address
                         Completed:(void (^)(NSDictionary *))completed
                            Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_CUSTOMER_UPDATE];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"customerId":customerId,
                                                                                       @"firstName":firstName,
                                                                                       @"lastName":lastName,
                                                                                       @"email":email,
                                                                                       @"phone":phone,
                                                                                       @"address":address
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Network error";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getReviewsById:(NSString *)restId
             Completed:(void (^)(NSDictionary *))completed
                Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_REVIEWS_BY_REST_ID];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"restaurant_id":restId,
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *products = [dicResponse objectForKey:@"data"];
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Getting reviews failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}
- (void)doReview:(NSString *)userId
        Username:(NSString *)username
          RestID:(NSString *)restId
            Rank:(NSNumber *)rank
         Comment:(NSString *)comment
        PostTime:(NSString *)posttime
       Completed:(void (^)(NSString *))completed
          Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_UPLOAD_REVIEW];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"user_id":userId,
                                                                                       @"username":username,
                                                                                       @"restaurant_id":restId,
                                                                                       @"ranking":rank,
                                                                                       @"comment":comment,
                                                                                       @"posttime":posttime,
                                                                                       }];
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:dicParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            NSString *products = @"Sent review successfully.";
            completed(products);
        }
        else
        {
            NSString *strErrorMsg = @"Send review failed";//[dicResponse objectForKey:@"message"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}


@end
