//
//  OrderDetailRVC.h
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrderDetailRVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UILabel *mFirstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mLastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mOrderTime;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *mUserPhone;
@property (weak, nonatomic) IBOutlet UILabel *mUserAddress;
@property (weak, nonatomic) IBOutlet UIButton *mMistakeBtn;
@property (weak, nonatomic) IBOutlet UILabel *mInstructionLabel;

@property (weak, nonatomic) IBOutlet UILabel *mPickTimeLabel;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onPickupTimeClick:(id)sender;
- (IBAction)onMistakeClick:(id)sender;

@property (strong, nonatomic) Order* data;
@property (strong, nonatomic) NSMutableArray* fooddata;

@end
