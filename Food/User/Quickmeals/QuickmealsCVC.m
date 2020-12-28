//
//  QuickmealsCVC.m
//  Food
//
//  Created by weiquan zhang on 6/17/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "QuickmealsCVC.h"
#import "Config.h"
#import "QFoodCTVC.h"
#import "QFoodDetailCVC.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Customer.h"
#import "Food.h"

extern Customer* customer;

@implementation QuickmealsCVC
- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.navigationController.navigationBar.tintColor = PRIMARY_COLOR;
        
    } else {// iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = PRIMARY_COLOR;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }
    self.navigationItem.title = @"QuickMeals";
    self.refreshController = [[RCRTableViewRefreshController alloc] initWithTableView:self.mTableView refreshHandler:^{
        [self getData];
    }];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFavorite:) name:@"QChangedFavorite" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) viewWillAppear:(BOOL)animated {
    [self getData];
}
- (void)changeFavorite:(NSNotification*)msg{
    /*
    NSDictionary* dic = msg.userInfo;
    NSNumber* objectID = dic[@"cellTag"];
    NSNumber* isfavorite = dic[@"isfavorite"];
    ((Food*)(self.data[[objectID longValue]])).is_favorite = isfavorite;
    */
    [self getData];
}
- (void)getData{
    
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getQuickMealsByCustomerId:customer.customerId
                                        Completed:^(NSArray *array){
                                            [SVProgressHUD dismiss];
                                            
                                            self.data = [[NSMutableArray alloc] init];
                                            for(int i=0;i<array.count;i++){
                                                Food* food = [[Food alloc] initWithDictionary:array[i]];
                                                [self.data addObject:food];
                                            }
                                            [self.mTableView reloadData];
                                        }Failed:^(NSString *strError) {
                                            [SVProgressHUD showErrorWithStatus:strError];
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QFoodCTVC *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_QFoodCTVC" forIndexPath:indexPath];
    cell.cID = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.mNavController = self.navigationController;
    [cell setLayout:self.data[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QFoodDetailCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_QFoodDetailCVC"];
    
    mVC.data = self.data[indexPath.row];
    [self.navigationController pushViewController:mVC animated:YES];
}

@end
