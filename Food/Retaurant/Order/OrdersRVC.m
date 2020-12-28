//
//  OrdersRVC.m
//  FoodOrder
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "OrdersRVC.h"
#import "Config.h"
#import "ROrderTVCell.h"
#import "OrderDetailRVC.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Restaurant.h"
#import "Order.h"
#import "PickupViewController.h"
#import "AppDelegate.h"

extern Restaurant* owner;

@interface OrdersRVC ()

@end

@implementation OrdersRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    g_isMistakeOrder = false;
    [self getData];
    
    self.data = [[NSMutableArray alloc] init];
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.data count]];
    
    self.refreshController = [[RCRTableViewRefreshController alloc] initWithTableView:self.mTableView refreshHandler:^{
        [self getData];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderStatus:) name:@"ChangeOrderStatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickupTimeClick:) name:NOTIFICATION_PICKUP_TIME object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeOrderStatus:(NSNotification*)msg{
    [self getData];
}

- (void)pickupTimeClick:(NSNotification*)msg{
    NSDictionary *userinfo = msg.userInfo;
    Order *sel_order = userinfo[@"data"];
    PickupViewController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PickupViewController"];
    mVC.data = sel_order;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) viewWillAppear:(BOOL)animated{
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissKeyboard{
    [self.mSearchBar resignFirstResponder];
}

- (void)getData{
    
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getOrdersByRestId:(NSString *)owner.restaurantId
                                        Completed:^(NSArray *array){
                                            [SVProgressHUD dismiss];
                                            
                                            self.data = [[NSMutableArray alloc] init];
                                            for(int i=0;i<array.count;i++){
                                                Order* order = [[Order alloc] initWithDictionary:array[i]];
                                                if([order.status_id isEqualToString:STATUS_CANCELED] || [order.status_id isEqualToString:STATUS_REJECTED])
                                                {
                                                    continue;
                                                }
                                                [self.data addObject:order];
                                            }
                                            [self.mTableView reloadData];
                                        }Failed:^(NSString *strError) {
                                            //[SVProgressHUD showErrorWithStatus:strError];
                                            [SVProgressHUD dismiss];
                                        }];
    [self dataHasRefreshed];
    
}

- (void)dataHasRefreshed {
    // Ensure we're on the main queue as we'll be updating the UI (not strictly necessary for this example, but will likely be essential in less trivial scenarios and so is included for illustrative purposes)
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // At some point later, when we're done getting our new data, tell our refresh controller to end refreshing
        [self.refreshController endRefreshing];
        
        // Finally get the table view to reload its data
        [self.mTableView reloadData];
        
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        return [self.data count];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 133;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ROrderTVCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_ROrderTVCell" forIndexPath:indexPath];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Order* o = self.searchResults[indexPath.row];
        [cell setLayout:o];
    } else {
        Order* o = self.data[indexPath.row];
        [cell setLayout:o];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        OrderDetailRVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_OrderDetailRVC"];
        mVC.data = self.searchResults[indexPath.row];
        [self.navigationController pushViewController:mVC animated:YES];
    } else {
        OrderDetailRVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_OrderDetailRVC"];
        mVC.data = self.data[indexPath.row];
        [self.navigationController pushViewController:mVC animated:YES];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"orderId contains[c] %@", searchText];
    self.searchResults = [[NSMutableArray alloc] initWithArray:[self.data filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBackClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_InitNC"];
    [self presentViewController:mVC animated:YES completion:NULL];
}
@end
