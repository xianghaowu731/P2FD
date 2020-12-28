//
//  ROrderTVCell.h
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface ROrderTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *mOrderIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *mCustomerNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *mRejectBtn;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *mAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDriverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mOrderInLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDriverPhoneLabel;

- (IBAction)onRejectClick:(id)sender;
- (IBAction)omDriverCall:(id)sender;
- (IBAction)onPickupClick:(id)sender;

@property (strong, nonatomic) Order* data;
- (void)setLayout:(Order*) o;
@end
