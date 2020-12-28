//
//  OrderDetailCVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrderDetailCVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *mButton;

- (IBAction)onBtnClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
@property (strong, nonatomic) Order* data;
@end
