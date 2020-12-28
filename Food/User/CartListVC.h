//
//  CartListVC.h
//  Food
//
//  Created by weiquan zhang on 6/27/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartListVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray* data;

@property (strong, nonatomic) IBOutlet UILabel *mTitleLabel;

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)onBackClick:(id)sender;

@end
