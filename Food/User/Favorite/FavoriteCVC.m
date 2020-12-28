//
//  FavoriteCVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "FavoriteCVC.h"
#import "Config.h"
#import "FoodCTVC.h"
#import "RestaurantCTVC.h"
#import "RestaurantCVC.h"
#import "FoodDetailCVC.h"
#import "Config.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Customer.h"
#import "Food.h"
#import "FMDBHelper.h"
#import "CartListVC.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

extern FMDBHelper *helper;
extern Customer* customer;

@interface FavoriteCVC ()
@property (strong, nonatomic) NSString* mode;

@end

@implementation FavoriteCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mode = MODE_RESTAURANT;
    
    //=================================================================
    self.cartImg = [Common imageWithImage:[UIImage imageNamed:@"ic_cart"] scaledToSize:CGSizeMake(28.0, 28.0)];
    [self.mCartBtn setImage:self.cartImg forState:UIControlStateNormal];
    
    self.refreshController = [[RCRTableViewRefreshController alloc] initWithTableView:self.mTableView refreshHandler:^{
        [self getData];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFavorite:) name:@"ChangedFavorite" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rChangeFavorite:) name:@"RChangedFavorite" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plusOrder:) name:@"PlusOrder" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [self setRightNavItem];
    [self getData];
}

- (void)setRightNavItem{
    helper = [FMDBHelper sharedInstance];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [helper getAllOrders];
    int count = 0;
    for(int i=0;i<array.count; i++){
        Food* f = [[Food alloc] init];
        f = array[i];
        count += [f.count intValue];
    }
    [self.mCartBtn setTitle:[NSString stringWithFormat:@"(%d)", count] forState:UIControlStateNormal];
}

- (void)plusOrder:(NSNotification*)msg{
    [self setRightNavItem];
}

- (void)changeFavorite:(NSNotification*)msg{
    [self getData];
}

- (void)rChangeFavorite:(NSNotification*)msg{
    [self getData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getData{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getFavoritesByCustomerId:customer.customerId
                                             Completed:^(NSDictionary *dic){
                                                 [SVProgressHUD dismiss];
                                                 
                                                 self.restData = [[NSMutableArray alloc] init];
                                                 self.foodData = [[NSMutableArray alloc] init];
                                                 
                                                 NSMutableArray* array = [dic objectForKey:@"rests"];
                                                 for(int i=0;i<array.count;i++){
                                                     Restaurant* rest = [[Restaurant alloc] initWithDictionary:array[i]];
                                                     [self.restData addObject:rest];
                                                 }
                                                 [self calcDistance];
                                                 array = [dic objectForKey:@"foods"];
                                                 for(int i=0;i<array.count;i++){
                                                     Food* food = [[Food alloc] initWithDictionary:array[i]];
                                                     [self.foodData addObject:food];
                                                 }
                                                 [self.mTableView reloadData];
                                             }Failed:^(NSString *strError) {
                                                 [SVProgressHUD showErrorWithStatus:strError];
                                             }];
    
    [self dataHasRefreshed];
}

- (void) calcDistance{
    for(int i= 0 ; i < self.restData.count ; i++)
    {
        Restaurant *one = [[Restaurant alloc] init];
        one = self.restData[i];
        
        if([one.address length] >0 && [one.location length] > 0 )
        {
            //========calculation distance
            if([g_address length] != 0){
                CLLocationDegrees onelat = [g_latitude floatValue];
                CLLocationDegrees onelon = [g_longitude floatValue];
                CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:onelat longitude:onelon];
                NSArray *foo1 = [one.location componentsSeparatedByString: @","];
                CLLocationDegrees otherlat = [foo1[0] floatValue];
                CLLocationDegrees otherlon = [foo1[1] floatValue];
                CLLocation *oneLocation = [[CLLocation alloc] initWithLatitude:otherlat longitude:otherlon];
                CLLocationDistance distance = [myLocation distanceFromLocation:oneLocation] * 1.323;//1.3
                one.mDistance = fabs(distance);
            }
        }
    }
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
    long count = 0;
    if([self.mode isEqualToString:MODE_RESTAURANT]){
        count = self.restData.count;
    } else {
        count = self.foodData.count;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    if([self.mode isEqualToString:MODE_RESTAURANT]){
        RestaurantCTVC *rc = [tableView dequeueReusableCellWithIdentifier:@"RID_RestaurantCTVC" forIndexPath:indexPath];
        [rc setLayout:self.restData[indexPath.row]];
        cell = rc;
    } else {
        FoodCTVC *fc = [tableView dequeueReusableCellWithIdentifier:@"RID_FoodCTVC" forIndexPath:indexPath];
        [fc setLayout:self.foodData[indexPath.row]];
        cell = fc;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.mode isEqualToString:MODE_RESTAURANT]){
        RestaurantCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_RestaurantCVC"];
        mVC.mRestaurant = self.restData[indexPath.row];
        [self.navigationController pushViewController:mVC animated:YES];
    } else {
        [self moveFoodDetail:indexPath.row];
    }
}

- (void)moveFoodDetail:(NSInteger) ind{
    Food* sel_food = self.foodData[ind];
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getRestByRestId:sel_food.restId
                                             Completed:^(NSDictionary *dic){
                                                 [SVProgressHUD dismiss];
                                                 
                                                 Restaurant* sel_rest = [[Restaurant alloc] initWithDictionary:dic];
                                                 FoodDetailCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_FoodDetailCVC"];
                                                 mVC.data = sel_food;
                                                 mVC.restId = sel_food.restId;
                                                 mVC.restaurant = sel_rest;
                                                 [self.navigationController pushViewController:mVC animated:YES];
                                             }Failed:^(NSString *strError) {
                                                 [SVProgressHUD showErrorWithStatus:strError];
                                             }];
    
    [self dataHasRefreshed];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onRestBtnClick:(id)sender {
    self.mode = MODE_RESTAURANT;
    //[self getData];
    [self.mTableView reloadData];
}

- (IBAction)onFoodBtnClick:(id)sender {
    self.mode = MODE_FOOD;
    //[self getData];
    [self.mTableView reloadData];
}

- (IBAction)onBackClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_InitNC"];
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (IBAction)onCartClick:(id)sender {
    CartListVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartListVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

@end
