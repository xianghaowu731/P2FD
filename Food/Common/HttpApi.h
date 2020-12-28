//
//  HttpApi.h
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpApi : NSObject

+ (id)sharedInstance;

- (void)loginWithUsername:(NSString *)username
                 Password:(NSString *)password
                    Token:(NSString *)token
                Completed:(void (^)(NSString *))completed
                   Failed:(void (^)(NSString *))failed;

- (void)loginFBWithID:(NSString *)fbID
                Email:(NSString *)email
                 Name:(NSString *)name
                Phone:(NSString *)phone
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed;

- (void)loginGLWithID:(NSString *)glID
                Email:(NSString *)email
                 Name:(NSString *)name
             LastName:(NSString *)last_name
            FirstName:(NSString *)first_name
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed;


- (void)verifyAccountServiceWithID:(NSString *)fbID
                           FBEmail:(NSString *)fbEmail
                             Email:(NSString *)email
                            Reason:(NSString *)reason
                          Password:password
                         Completed:(void (^)(NSString *))completed
                            Failed:(void (^)(NSString *))failed;

- (void)registerWithUsername:(NSString *)username
                       Email:(NSString *)email
                       Phone:(NSString *)phone
                    Password:(NSString *)password
                        Type:(NSString *)type
                   Completed:(void (^)(NSString *))completed
                      Failed:(void (^)(NSString *))failed;

- (void)SignupFBWithID:(NSString *)fbID
                 Email:(NSString *)email
                  Name:(NSString *)name
                 Phone:(NSString *)phone
                  Type:(NSString *)type
             Completed:(void (^)(NSString *))completed
                Failed:(void (^)(NSString *))failed;

- (void)forgotPassWithEmail:(NSString *)email
                   Completed:(void (^)(NSString *))completed
                      Failed:(void (^)(NSString *))failed;

- (void)logoutWithUserId:(NSString *)userId
               Completed:(void (^)(NSString *))completed
                  Failed:(void (^)(NSString *))failed;

- (void)saveAccountWithUserId:(NSString *) userId
                         Name:(NSString *)username
                  PhoneNumber:(NSString *)phoneNumber
                     Birthday:(NSString *)birthday
                       Weixin:(NSString *)weixin
                    Completed:(void (^)(NSString *))completed
                       Failed:(void (^)(NSString *))failed;

- (void)modifyEmailWithUserId:(NSString *) userId
                        Email:(NSString *)email
                     Password:(NSString *)password
                     NewEmail:(NSString *)newEmail
                    Completed:(void (^)(NSString *))completed
                       Failed:(void (^)(NSString *))failed;

- (void)modifyPasswordWithUserId:(NSString *) userId
                           Email:(NSString *)email
                     OldPassword:(NSString *)oldPassword
                     NewPassword:(NSString *)newPassword
                       Completed:(void (^)(NSString *))completed
                          Failed:(void (^)(NSString *))failed;

- (void)getFoodById:(NSString *)Id
          Completed:(void (^)(NSDictionary *))completed
             Failed:(void (^)(NSString *))failed;

- (void)getRestCategory:(void (^)(NSString *))completed
                 Failed:(void (^)(NSString *))failed;

- (void)getRestMenuByRestId:(NSString* )restId
                    Completed:(void (^)(NSString *))completed
                       Failed:(void (^)(NSString *))failed;

- (void)addRestMenuByRestId:(NSString* )restId
                       Name:(NSString* )name
                  Completed:(void (^)(NSString *))completed
                     Failed:(void (^)(NSString *))failed;

- (void)delRestMenuByRestId:(NSString* )menuId
                  Completed:(void (^)(NSString *))completed
                     Failed:(void (^)(NSString *))failed;

- (void)getAdminFoodsByRestId:(NSString* ) restId
                    Completed:(void (^)(NSString *))completed
                        Failed:(void (^)(NSString *))failed;

- (void)getAdminQuickFoodsByRestId:(NSString* ) restId
                    Completed:(void (^)(NSString *))completed
                       Failed:(void (^)(NSString *))failed;

- (void)addToQuickMealsByFoodId:(NSString* ) foodId
                         Completed:(void (^)(NSString *))completed
                            Failed:(void (^)(NSString *))failed;

- (void)delFromQuickMealsByFoodId:(NSString* ) foodId
                      Completed:(void (^)(NSString *))completed
                         Failed:(void (^)(NSString *))failed;
- (void)delFoodByFoodId:(NSString* ) foodId
                        Completed:(void (^)(NSString *))completed
                           Failed:(void (^)(NSString *))failed;
- (void)uploadFoodByFoodId:(NSString *)foodId
                       name:(NSString *)name
                 Description:(NSString *)description
                     price:(NSString *)price
                     status:(NSString *)status
                        image:(NSString *)image
                     Extra:(NSString *)extra
                   Completed:(void (^)(NSString *))completed
                      Failed:(void (^)(NSString *))failed;
- (void)registerFoodWithCategory:(NSString *)restId
                            name:(NSString *)name
                     Description:(NSString *)description
                           price:(NSString *)price
                          status:(NSString *)status
                           image:(NSString *)image
                        Category:(NSString *)category
                           Extra:(NSString *)extra
                       Completed:(void (^)(NSString *))completed
                          Failed:(void (^)(NSString *))failed;

- (void)getExtraFoodsByFoodId:(NSString *)fId
                    Completed:(void (^)(NSArray *))completed
                       Failed:(void (^)(NSString *))failed;

- (void)registerFood:(NSString *)restId
                      name:(NSString *)name
               Description:(NSString *)description
                     price:(NSString *)price
                    status:(NSString *)status
                     image:(NSString *)image
                 Completed:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed;
- (void)foodImagePost:(NSData *)photo
        Completed:(void (^)(NSString *))completed
           Failed:(void (^)(NSString *))failed;

- (void)restImagePost:(NSData *)photo
                   id:(NSString *)restId
        Completed:(void (^)(NSString *))completed
           Failed:(void (^)(NSString *))failed;

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
                    Failed:(void (^)(NSString *))failed;


- (void)getRestByCustomerId:(NSString *)customerId
                  Completed:(void (^)(NSArray *))completed
                     Failed:(void (^)(NSString *))failed;

- (void)getRestByRestId:(NSString *)restId
                  Completed:(void (^)(NSDictionary *))completed
                     Failed:(void (^)(NSString *))failed;

- (void)getRestInfoByRestId:(NSString *)restId
                 CustomerId:(NSString *)customerId
                  Completed:(void (^)(NSDictionary *))completed
                     Failed:(void (^)(NSString *))failed;

- (void)getRestInfoByDriver:(NSString *)restId
                  Completed:(void (^)(NSDictionary *))completed
                     Failed:(void (^)(NSString *))failed;

- (void)getRestAndFoodInfoByRestId:(NSString *)restId
                        CustomerId:(NSString *)customerId
                         Completed:(void (^)(NSDictionary *))completed
                            Failed:(void (^)(NSString *))failed;

- (void)getLocationByRestId:(NSString *)restId
                        Location:(NSString *)location
                         Completed:(void (^)(NSString *))completed
                            Failed:(void (^)(NSString *))failed;

- (void)getQuickMealsByCustomerId:(NSString *)customerId
                  Completed:(void (^)(NSArray *))completed
                     Failed:(void (^)(NSString *))failed;

- (void)getFavoritesByCustomerId:(NSString *)customerId
                        Completed:(void (^)(NSDictionary *))completed
                           Failed:(void (^)(NSString *))failed;

- (void)getOrdersByCustomerId:(NSString *)customerId
                      Completed:(void (^)(NSArray *))completed
                         Failed:(void (^)(NSString *))failed;




- (void)updateFoodFavoriteByCustomerId:(NSString *)customerId
                                FoodId:(NSString *)foodId
                    Completed:(void (^)(long))completed
                       Failed:(void (^)(NSString *))failed;

- (void)updateRestaurantFavoriteByCustomerId:(NSString *)customerId
                                RestId:(NSString *)restId
                             Completed:(void (^)(long))completed
                                Failed:(void (^)(NSString *))failed;
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
                     Failed:(void (^)(NSString *))failed;


// 2
- (void)getOrdersByDriverId:(NSString *)deliverID
                Completed:(void (^)(NSArray *))completed
                   Failed:(void (^)(NSString *))failed;
- (void)getOrdersByRestId:(NSString *)restId
                  Completed:(void (^)(NSArray *))completed
                     Failed:(void (^)(NSString *))failed;
- (void)getAdminOrderByorderId:(NSString *)orderId
                Completed:(void (^)(NSDictionary *))completed
                   Failed:(void (^)(NSString *))failed;
- (void)getOrderByOrderId:(NSString *)orderId
                Completed:(void (^)(NSDictionary *))completed
                   Failed:(void (^)(NSString *))failed;
- (void)doAccept:(NSString *)orderId
        DriverID:(NSString *)driverId
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed;
- (void)doReject:(NSString *)orderId
          Reason:(NSString *)reason
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed;

- (void)doMistake:(NSString *)orderId
          Reason:(NSString *)reason
       Completed:(void (^)(NSString *))completed
          Failed:(void (^)(NSString *))failed;
- (void)doCancel:(NSString *)orderId
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed;
- (void)doComplete:(NSString *)orderId
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed;
- (void)doReady:(NSString *)orderId
         Completed:(void (^)(NSDictionary *))completed
            Failed:(void (^)(NSString *))failed;
- (void)doDelivery:(NSString *)orderId
         Completed:(void (^)(NSDictionary *))completed
            Failed:(void (^)(NSString *))failed;
- (void)doDelete:(NSString *)orderId
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed;
- (void)changePickupTime:(NSString *)orderId
              Pickuptime:(NSString *)pick_time
               Completed:(void (^)(NSString *))completed
                  Failed:(void (^)(NSString *))failed;
- (void)doRank:(NSString *)restId
          mark:(NSNumber *)mark
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed;
- (void)changeEmail:(NSString *)email
              Email:(NSString *)email
             Password:(NSString *)password
       Completed:(void (^)(NSString *))completed
          Failed:(void (^)(NSString *))failed;
- (void)changePassword:(NSString *)email
           oldpassword:oldPassword
           newPassword:newPassword
       Completed:(void (^)(NSDictionary *))completed
          Failed:(void (^)(NSString *))failed;

- (void)getReviewsById:(NSString *)restId
             Completed:(void (^)(NSDictionary *))completed
                Failed:(void (^)(NSString *))failed;
- (void)doReview:(NSString *)userId
        Username:(NSString *)username
          RestID:(NSString *)restId
            Rank:(NSNumber *)rank
         Comment:(NSString *)comment
        PostTime:(NSString *)posttime
       Completed:(void (^)(NSString *))completed
          Failed:(void (^)(NSString *))failed;






















- (void)getProductWithId:(NSString *)productId
               Completed:(void (^)(NSString *))completed
                  Failed:(void (^)(NSString *))failed;

- (void)getProductsWithKind:(NSString *)kind
                  Completed:(void (^)(NSString *))completed
                     Failed:(void (^)(NSString *))failed;

- (void) getScheduleBoatsCompleted:(void (^)(NSString *))completed
                            Failed:(void (^)(NSString *))failed;

- (void) getFishsWithSeaName:(NSString *) sea
                   Completed:(void (^)(NSString *))completed
                      Failed:(void (^)(NSString *))failed;

- (void) getTechsCompleted:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed;

- (void)getBooksWithUserId:(NSString *)userId
                 Completed:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed;

- (void)uploadShowcaseWithUserId:(NSString *)userId
                             Sea:(NSString *)sea
                            Date:(NSString *)date
                         BoatNum:(NSString *)boatNum
                           title:(NSString *)title
                     Description:(NSString *)description
                            File:(NSData *)photo
                       Completed:(void (^)(NSString *))completed
                          Failed:(void (^)(NSString *))failed;

- (void)uploadTechWithUserId:(NSString *)userId
                       title:(NSString *)title
                 Description:(NSString *)description
                        File:(NSData *)photo
                   Completed:(void (^)(NSString *))completed
                      Failed:(void (^)(NSString *))failed;

- (void)requestCertWithFile:(NSData *)photo
                  Completed:(void (^)(NSNumber *))completed
                     Failed:(void (^)(NSString *))failed;

- (void)getBoatNumsCompleted:(void (^)(NSString *))completed
                      Failed:(void (^)(NSString *))failed;

- (void)bookingWithUserId:(NSString *)userId
               ScheduleId:scheduleId
            CertRequestId:certRequestId
               ProductIds:productIds
                Completed:(void (^)(NSString *))completed
                   Failed:(void (^)(NSString *))failed;

- (void)bookingPreviewWithUserId:(NSString *)userId
                      ScheduleId:scheduleId
                   CertRequestId:certRequestId
                      ProductIds:productIds
                       Completed:(void (^)(NSString *))completed
                          Failed:(void (^)(NSString *))failed;

- (void)bookingRequestWithUserId:(NSString *)userId
                      ScheduleId:scheduleId
                   CertRequestId:certRequestId
                      ProductIds:productIds
                       PaymentId:paymentId
                          Amount:amount
                            Unit:unit
                       Completed:(void (^)(NSString *))completed
                          Failed:(void (^)(NSString *))failed;

- (void)getCertPriceCompleted:(void (^)(NSString *))completed
                       Failed:(void (^)(NSString *))failed;

- (void)deleteBookItemWithUserId:(NSString *)userId
                          BookId:bookId
                       Completed:(void (^)(NSString *))completed
                          Failed:(void (^)(NSString *))failed;

- (void)registerGCMTokenWithUserId:(NSString *)userId
                             Token:token
                         Completed:(void (^)(NSString *))completed
                            Failed:(void (^)(NSString *))failed;

- (void)unregisterGCMTokenWithUserId:(NSString *)userId
                           Completed:(void (^)(NSString *))completed
                              Failed:(void (^)(NSString *))failed;

- (void)refundRequestWithUserId:(NSString *)userId
                         BookId:bookId
                      Completed:(void (^)(NSString *))completed
                         Failed:(void (^)(NSString *))failed;

- (void)bookProcessRequestWithUserId:(NSString *)userId
                              BookId:bookId
                         AdminPasswd:adminPasswd
                           Completed:(void (^)(NSString *))completed
                              Failed:(void (^)(NSString *))failed;

- (void)uploadCustomerByCustomerId:(NSString *)customerId
                         FirstName:(NSString *)firstName
                          LastName:(NSString *)lastName
                             Email:(NSString *)email
                             Phone:(NSString *)phone
                           Address:(NSString *)address
                         Completed:(void (^)(NSDictionary *))completed
                            Failed:(void (^)(NSString *))failed;

@end
