//
//  RCRTableViewRefreshController.m
//
//  Created by Rich Robinson on 02/08/2014.
//  Copyright (c) 2014 Rich Robinson. All rights reserved.
//

#import "RCRTableViewRefreshController.h"

@interface RCRTableViewRefreshController ()

@property (nonatomic, copy) void (^refreshHandler) ();
@property (nonatomic, strong) UITableViewController *tableViewController;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end


@implementation RCRTableViewRefreshController

- (instancetype)initWithTableView:(UITableView *)tableView refreshHandler:(void (^) ())refreshHandler {
    self = [super init];
    
    if (self) {
        _refreshHandler = refreshHandler;
        
        // In order to use a UIRefreshControl on a the supplied table view we can use a UITableViewController behind the scenes to wire up the refresh control and table view, and get them working together. The table view controller is never actually presented - it's purely used as a workaround for adding the refresh control to the table view
        
        // First, create a UITableViewController for our internal use and set its tableView property to point at the table view passed into this method
        _tableViewController = [[UITableViewController alloc] init];
        _tableViewController.tableView = tableView;
        
        // Then create our UIRefreshControl, get it to run our refres handler when it's activated, and add it to the table view controller
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(doRefresh) forControlEvents:UIControlEventValueChanged];

        _tableViewController.refreshControl = self.refreshControl;
    }
    
    return self;
}

- (void)doRefresh {
    if (self.refreshHandler) {
        self.refreshHandler();
    }
}

- (void)endRefreshing {
    [self.refreshControl endRefreshing];
}

@end
