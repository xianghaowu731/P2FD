//
//  QuickmealsRVC.h
//  Food
//
//  Created by weiquan zhang on 6/17/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCRTableViewRefreshController.h"


@interface QuickmealsRVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSMutableArray* data;
@property (strong, nonatomic) NSString* restName;
@property (nonatomic, strong) RCRTableViewRefreshController *refreshController;


@property (strong, nonatomic) IBOutlet UITableView *mTableView;

@end
