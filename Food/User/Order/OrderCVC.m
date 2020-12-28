//
//  OrderCVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "OrderCVC.h"
#import "Config.h"
#import "OrderListCTVC.h"
#import "OrderDetailCVC.h"
#import "Config.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Customer.h"
#import "Food.h"
#import "Login.h"
#import "AppDelegate.h"

extern Customer* customer;

@interface OrderCVC ()

@end

@implementation OrderCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderStatus:) name:@"ChangeOrderStatus" object:nil];
    // Do any additional setup after loading the view.
    /*[self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.navigationController.navigationBar.tintColor = PRIMARY_COLOR;
        
    } else {// iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = PRIMARY_COLOR;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }
    self.navigationItem.title = @"My Orders";*/
    self.navigationController.navigationBar.hidden = true;
    
    
    self.refreshController = [[RCRTableViewRefreshController alloc] initWithTableView:self.mTableView refreshHandler:^{
        [self getData];
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    if(![customer.customerId isEqualToString:@"0"])
        [self getData];
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

- (void)getData{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getOrdersByCustomerId:customer.customerId
                                          Completed:^(NSArray *array){
                                              [SVProgressHUD dismiss];
                                              
                                              self.data = [[NSMutableArray alloc] init];
                                              for(int i=0;i<array.count;i++){
                                                  Order* order = [[Order alloc] initWithDictionary:array[i]];
                                                  if([order.status_id isEqualToString:STATUS_CANCELED]) {
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
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Restaurant *one;
    one = (id)nil;
    NSString *compId = ((Order*)(self.data[indexPath.row])).restId;
    for(int i = 0 ; i < g_Restaurants.count ; i++ )
    {
        Restaurant *other = (Restaurant*)g_Restaurants[i];
        if([other.restaurantId isEqualToString:compId]){
            one = other; break;
        }
    }
    
    OrderListCTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"RID_OrderListCTVC" forIndexPath:indexPath];
    [cell setLayout:self.data[indexPath.row]];
    cell.mRest = one;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDetailCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_OrderDetailCVC"];
    mVC.data = self.data[indexPath.row];

    [self.navigationController pushViewController:mVC animated:YES];
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
