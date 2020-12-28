//
//  OrderCVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCRTableViewRefreshController.h"


@interface OrderCVC : UIViewController

@property (strong, nonatomic) NSMutableArray* data;
@property (nonatomic, strong) RCRTableViewRefreshController *refreshController;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)onBackClick:(id)sender;

@end
