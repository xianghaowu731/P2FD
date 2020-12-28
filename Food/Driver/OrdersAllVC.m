//
//  OrdersAllVC.m
//  Food
//
//  Created by meixiang wu on 15/09/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "OrdersAllVC.h"
#import "Config.h"
#import "DOrderTVCell.h"
#import "DOrderDetailVC.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Restaurant.h"
#import "Order.h"
#import "Deliver.h"
#import "DeliverProfile.h"

extern Deliver* deliver;

@interface OrdersAllVC ()

@end

@implementation OrdersAllVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
    
    self.data = [[NSMutableArray alloc] init];
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.data count]];
    
    self.refreshController = [[RCRTableViewRefreshController alloc] initWithTableView:self.mTableView refreshHandler:^{
        [self getData];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderStatus:) name:@"ChangeOrderStatus" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeOrderStatus:(NSNotification*)msg{
    [self getData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) viewWillAppear:(BOOL)animated{
    [self getData];
}

- (void) dismissKeyboard{
    [self.mSearchBar resignFirstResponder];
}

- (void)getData{
    
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getOrdersByDriverId:(NSString *)deliver.dId
                                      Completed:^(NSArray *array){
                                          [SVProgressHUD dismiss];
                                          
                                          self.data = [[NSMutableArray alloc] init];
                                          for(int i=0;i<array.count;i++){
                                              Order* order = [[Order alloc] initWithDictionary:array[i]];
                                              if([order.status_id isEqualToString:STATUS_WAITING]){
                                                  [self.data addObject:order];
                                              } else if(![order.status_id isEqualToString:STATUS_REJECTED] && ![order.status_id isEqualToString:STATUS_CANCELED] && [order.driverId isEqualToString:deliver.dId]){
                                                  [self.data addObject:order];
                                              }
                                          }
                                          [self.mTableView reloadData];
                                      }Failed:^(NSString *strError) {
                                          [SVProgressHUD dismiss];
                                          //[SVProgressHUD showErrorWithStatus:strError];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DOrderTVCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_DOrderTVCell" forIndexPath:indexPath];
    
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
    Order *seldata = [[Order alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        seldata = self.searchResults[indexPath.row];
    } else {
        seldata = self.data[indexPath.row];
    }
    if([seldata.status_id integerValue] > [STATUS_WAITING integerValue]){
        DOrderDetailVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_DOrderDetailVC"];
        mVC.data = seldata;
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

- (IBAction)onBackClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_InitNC"];
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (IBAction)onProfileClick:(id)sender {
    DeliverProfile* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_DeliverProfile"];
    [self.navigationController pushViewController:mVC animated:YES];
}

@end
