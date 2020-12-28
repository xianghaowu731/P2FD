//
//  OrderInfoCTVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrderInfoCTVC : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *mIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *mDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *mRestNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (strong, nonatomic) IBOutlet UITextView *mDescText;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *mReasonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *mSubpriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDeliveryFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *mCompleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *mToFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *mToLastLabel;
@property (weak, nonatomic) IBOutlet UILabel *mToPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTipLabel;

@property (strong, nonatomic) Order* data;
- (IBAction)onCompleteClick:(id)sender;
- (void) setLayout:(Order*) o;
@end
