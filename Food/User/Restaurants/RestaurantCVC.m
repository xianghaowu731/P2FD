//
//  RestaurantCVC.m
//  Food
//
//  Created by weiquan zhang on 6/16/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "RestaurantCVC.h"
#import "Config.h"
#import "Common.h"
#import "FoodCTVC.h"
#import "FoodDetailCVC.h"
#import "Config.h"
#import "RestaurantCTVC.h"
#import "RestaurantCVC.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Customer.h"
#import "Food.h"
#import "RestauantInfoView.h"
#import "CartListVC.h"
#import "CartDetailVC.h"
#import "FMDBHelper.h"
#import <UIImageView+WebCache.h>

extern Customer *customer;
extern FMDBHelper* helper;

@implementation RestaurantCVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //=================================================================
    self.cartImg = [Common imageWithImage:[UIImage imageNamed:@"ic_cart"] scaledToSize:CGSizeMake(28.0, 28.0)];
    [self.mCartBtn setImage:self.cartImg forState:UIControlStateNormal];
    
    
    self.refreshController = [[RCRTableViewRefreshController alloc] initWithTableView:self.mTableView refreshHandler:^{
        [self getData];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFavorite:) name:@"ChangedFavorite" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plusOrder:) name:@"PlusOrder" object:nil];
    
    self.cartCount = 0;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [self getData];
}

- (void)changeFavorite:(NSNotification*)msg{
    
    NSDictionary* dic = msg.userInfo;
    NSNumber* objectID = dic[@"cellTag"];
    NSNumber* isfavorite = dic[@"isfavorite"];
    ((Food*)(self.data[[objectID longValue]])).is_favorite = isfavorite;
}

- (void)plusOrder:(NSNotification*)msg{
    helper = [FMDBHelper sharedInstance];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [helper getOrdersByRestID:self.mRestaurant.restaurantId];
    int count = 0;
    for(int i=0;i<array.count; i++){
        Food* f = [[Food alloc] init];
        f = array[i];
        count += [f.count intValue];
    }
    [self.mCartBtn setTitle:[NSString stringWithFormat:@"(%d)", count] forState:UIControlStateNormal];
}

- (void)getData{
    
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getRestAndFoodInfoByRestId:(NSString *)self.mRestaurant.restaurantId
                                       CustomerId:(NSString *)customer.customerId
                                        Completed:^(NSDictionary *dic){
                                            [SVProgressHUD dismiss];
                                            
                                            self.data = [[NSMutableArray alloc] init];
                                            //self.mRestaurant = [[Restaurant alloc] initWithDictionary:dic[@"rest"]];
                                            NSMutableArray* array = dic[@"foods"];
                                            for(int i=0;i<array.count;i++){
                                                Food* food = [[Food alloc] initWithDictionary:array[i]];
                                                [self.data addObject:food];
                                            }
                                            [self.mTableView reloadData];
                                            [self setLayout:self.mRestaurant];
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

- (void)setLayout:(Restaurant*)r {
    self.mNameLabel.text = r.name;
    if(r.isfavorite.intValue == 1){
        [self.mFavoIcon setImage:[UIImage imageNamed:@"hart.png"] forState:UIControlStateNormal];
    } else {
        [self.mFavoIcon setImage:[UIImage imageNamed:@"hart_line.png"] forState:UIControlStateNormal];
    }
    
    self.cartCount = 0;
    helper = [FMDBHelper sharedInstance];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [helper getOrdersByRestID:r.restaurantId];//[helper getAllOrders];
    int count = 0;
    for(int i=0;i<array.count; i++){
        Food* f = [[Food alloc] init];
        f = array[i];
        count += [f.count intValue];
    }
    self.cartCount = count;
    [self.mCartBtn setTitle:[NSString stringWithFormat:@" (%d)", count] forState:UIControlStateNormal];
    
    float fee_distance = r.mDistance / 1000;
    float m_fee = 0.0;
    if(r.mDistance != 0.0 && [r.address length] > 0){//fee_distance < 50 &&
        if(fee_distance < KM_PER_MILE * DELIVERY_DEFAULT_DISTANCE){
            m_fee = DELIVERY_FEE_PER_DEFAULT; //5.0$
        } else{
            m_fee = DELIVERY_FEE_PER_DEFAULT + (fee_distance/KM_PER_MILE - DELIVERY_DEFAULT_DISTANCE)*DELIVERY_ADD_FEE;//over 10mile add 0.5$
        }
        self.mFeeLabel.text = [NSString stringWithFormat:@"$%.2f", m_fee];
    } else{
        self.mFeeLabel.text = @"Delivery Unavailable";
    }
    self.mDistanceLabel.text = [NSString stringWithFormat:@"%.2f mi", fee_distance/KM_PER_MILE];
    self.mTimeLabel.text = [NSString stringWithFormat:@"%ld min", (long)((fee_distance/KM_PER_MILE)/DELIVERY_MILE_PER_MIN)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    //NSString *ratingString = [NSString stringWithFormat:@"Rating: %.1f", rating];
    //if( [control isEqual:self.mRatingView] )
    //_starRatingLabel.text = ratingString;
    //else
    //
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 92;
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    FoodCTVC* c = [tableView dequeueReusableCellWithIdentifier:@"RID_FoodCTVC" forIndexPath:indexPath];
    [c setLayout:self.data[indexPath.row]];
    cell = c;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FoodDetailCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_FoodDetailCVC"];
    mVC.data = self.data[indexPath.row];
    mVC.restId = self.mRestaurant.restaurantId;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onClickFavoIconClick:(id)sender {
    [SVProgressHUD show];
    [[HttpApi sharedInstance] updateRestaurantFavoriteByCustomerId:customer.customerId
                                                      RestId:self.mRestaurant.restaurantId
                                                   Completed:^(long is_favorite){
                                                       [SVProgressHUD dismiss];
                                                       
                                                       if(is_favorite) {
                                                           [self.mFavoIcon setImage:[UIImage imageNamed:@"hart.png"] forState:UIControlStateNormal];
                                                           
                                                       } else {
                                                           [self.mFavoIcon setImage:[UIImage imageNamed:@"hart_line.png"] forState:UIControlStateNormal];
                                                       }
                                                       self.mRestaurant.isfavorite = [NSNumber numberWithLong:is_favorite];
                                                   }Failed:^(NSString *strError) {
                                                       [SVProgressHUD showErrorWithStatus:strError];
                                                   }];
}

- (IBAction)onInfoClick:(id)sender {
    RestauantInfoView* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_RestaurantInfoView"];
    mVC.mRestaurant = self.mRestaurant;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCartClick:(id)sender {
    if(self.cartCount == 0) return;
    CartDetailVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartDetailVC"];
    mVC.navigationController = self.navigationController;
    mVC.restId = self.mRestaurant.restaurantId;
    mVC.mRest = self.mRestaurant;
    [self.navigationController pushViewController:mVC animated:YES];
}
@end
