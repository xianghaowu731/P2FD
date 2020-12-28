//
//  OrdersAllVC.h
//  Food
//
//  Created by meixiang wu on 15/09/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCRTableViewRefreshController.h"

@interface OrdersAllVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *mSearchBar;


@property (strong, nonatomic) NSMutableArray* data;
@property (strong, nonatomic) NSMutableArray* searchResults;
@property (nonatomic, strong) RCRTableViewRefreshController *refreshController;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onProfileClick:(id)sender;

@end
