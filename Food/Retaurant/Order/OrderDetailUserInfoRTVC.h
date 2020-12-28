//
//  OrderDetailUserInfoRTVC.h
//  Food
//
//  Created by weiquan zhang on 6/18/16.
//  Copyright © 2016 Odelan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Customer.h"
#import "Order.h"

@interface OrderDetailUserInfoRTVC : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *mFirstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mLastNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mEmailLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *mAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *mTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *mCommentText;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (strong, nonatomic) IBOutlet UITextView *mDescText;

@property (strong, nonatomic) Customer* data;
@property (strong, nonatomic) NSString* address;
- (void) setLayout:(Order *)c;
@end
