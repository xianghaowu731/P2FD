//
//  OrdersRVC.h
//  FoodOrder
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCRTableViewRefreshController.h"

@interface OrdersRVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *mSearchBar;


@property (strong, nonatomic) NSMutableArray* data;
@property (strong, nonatomic) NSMutableArray* searchResults;
@property (nonatomic, strong) RCRTableViewRefreshController *refreshController;

- (IBAction)onBackClick:(id)sender;

@end
