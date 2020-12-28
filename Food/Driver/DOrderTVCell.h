//
//  DOrderTVCell.h
//  Food
//
//  Created by meixiang wu on 19/09/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface DOrderTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *mOrderIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *mRestLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPublishLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRestPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mToPhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *mAcceptBtn;
@property (weak, nonatomic) IBOutlet UILabel *mChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mEstLabel;


@property (strong, nonatomic) Order* data;
- (void)setLayout:(Order*) o;
- (IBAction)onButtonClick:(id)sender;
- (IBAction)onRestCall:(id)sender;
- (IBAction)onUserCall:(id)sender;

@end
