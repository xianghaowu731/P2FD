//
//  PickupViewController.h
//  Food
//
//  Created by meixiang wu on 23/02/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface PickupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *mDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *mTodayLabel;
@property (weak, nonatomic) IBOutlet UIButton *mPickupBtn;

@property (strong, nonatomic) Order *data;

- (IBAction)onTimeClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onPickupClick:(id)sender;

@end
