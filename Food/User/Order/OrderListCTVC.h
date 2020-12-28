//
//  OrderListCTVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "Restaurant.h"

@interface OrderListCTVC : UITableViewCell
@property (nonatomic) Restaurant *mRest;
@property (strong, nonatomic) IBOutlet UILabel *mIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *mDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRestNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDeliverTime;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;

@property (strong, nonatomic) Order* data;
- (void) setLayout:(Order*)o;
@end
