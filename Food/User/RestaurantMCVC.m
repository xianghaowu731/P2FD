//
//  RestaurantMCVC.m
//  Food
//
//  Created by meixiang wu on 6/2/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "RestaurantMCVC.h"
#import "Config.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Customer.h"
#import <UIImageView+WebCache.h>
#import "UserCategoryView.h"
#import "RestauantInfoView.h"
#import "FMDBHelper.h"
#import "CartListVC.h"
#import "CartDetailVC.h"

extern FMDBHelper *helper;
extern Customer *customer;

@interface RestaurantMCVC (){
    
}

@end

@implementation RestaurantMCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAddOrder:) name:@"PlusOrder" object:nil];
    
    //===================================================================
    self.colors = @[ [UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0f], [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f], [UIColor colorWithRed:0.1f green:1.0f blue:0.1f alpha:1.0f]];
    // Setup control using iOS7 tint Color
    self.mRateView.backgroundColor  = self.colors[1];//[UIColor whiteColor];
    self.mRateView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRateView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRateView.maxRating = 5.0;
    self.mRateView.delegate = (id)self;
    self.mRateView.horizontalMargin = 2.0;
    self.mRateView.editable=YES;
    float rating = 4.65f;
    self.mRateView.rating= rating;
    self.mRateView.displayMode=EDStarRatingDisplayAccurate;
    [self.mRateView  setNeedsDisplay];
    self.mRateView.tintColor = self.colors[0];
    self.mRateLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    
    // Setup control using iOS7 tint Color
    self.cartImg = [Common imageWithImage:[UIImage imageNamed:@"ic_cart"] scaledToSize:CGSizeMake(28.0, 28.0)];
    [self.mCartBtn setImage:self.cartImg forState:UIControlStateNormal];
    self.cartCount = 0;
    //=====================================================================
    helper = [FMDBHelper sharedInstance];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [helper getAllOrders];
    int count = 0;
    for(int i=0;i<array.count; i++){
        Food* f = [[Food alloc] init];
        f = array[i];
        if([f.restId isEqualToString:self.mRestaurant.restaurantId])
            count += [f.count intValue];
    }
    //[self.mCartBtn setImage:[UIImage imageNamed:@"ic_cart.png"] forState:UIControlStateNormal];
    [self.mCartBtn setTitle:[NSString stringWithFormat:@" (%d)", count] forState:UIControlStateNormal];
    //[self.mCartBtn sizeToFit];
    
    UserCategoryView *userTreeview = [[UserCategoryView alloc] init];
    userTreeview.mRestaurant = self.mRestaurant;
    [self addChildViewController:userTreeview];
    CGRect frame = userTreeview.view.frame;
    frame.size.height = self.mCateView.bounds.size.height;
    userTreeview.view.frame = frame;//[[UIScreen mainScreen] bounds];
    [self.mCateView addSubview:userTreeview.view];
    [userTreeview didMoveToParentViewController:self];
    //[self getData];
    [self setLayout:self.mRestaurant];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) receiveAddOrder:(NSNotification *)notification{
    helper = [FMDBHelper sharedInstance];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [helper getOrdersByRestID:self.mRestaurant.restaurantId];
    int count = 0;
    for(int i=0;i<array.count; i++){
        Food* f = [[Food alloc] init];
        f = array[i];
        if([f.restId isEqualToString:self.mRestaurant.restaurantId])
            count += [f.count intValue];
    }
    [self.mCartBtn setTitle:[NSString stringWithFormat:@" (%d)", count] forState:UIControlStateNormal];
}

- (void)getData{
    
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getRestInfoByRestId:(NSString *)self.mRestaurant.restaurantId
                                       CustomerId:(NSString *)customer.customerId
                                        Completed:^(NSDictionary *dic){
                                            [SVProgressHUD dismiss];
                                            self.mRestaurant = [[Restaurant alloc] initWithDictionary:dic[@"rest"]];
                                            [self setLayout:self.mRestaurant];
                                        }Failed:^(NSString *strError) {
                                            [SVProgressHUD showErrorWithStatus:strError];
                                        }];    
}

- (void)infoBtnCkick{
    RestauantInfoView* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_RestaurantInfoView"];
    mVC.mRestaurant = self.mRestaurant;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [self setLayout:self.mRestaurant];
}


- (void)setLayout:(Restaurant*)r {
    self.mTitleLabel.text = r.name;
    self.mNameLabel.text = r.name;
    
    float rating = [r.ranking floatValue];
    self.mRateView.rating = rating;
    self.mRateLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    if(r.isfavorite.intValue == 1){
        [self.mFavoIcon setImage:[UIImage imageNamed:@"hart.png"] forState:UIControlStateNormal];
    } else {
        [self.mFavoIcon setImage:[UIImage imageNamed:@"hart_line.png"] forState:UIControlStateNormal];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, RESTAURANT_IMAGE_BASE_URL, r.img];
    [self.mRestImg sd_setImageWithURL:[NSURL URLWithString:url]];
    
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
    float m_fee = DELIVERY_FEE_PER_DEFAULT;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onCartIconClick:(id)sender {
    CartListVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartListVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

/*-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    //NSString *ratingString = [NSString stringWithFormat:@"Rating: %.1f", rating];
    //if( [control isEqual:self.mRatingView] )
    //_starRatingLabel.text = ratingString;
    //else
    [SVProgressHUD show];
    [[HttpApi sharedInstance] doRank:(NSString *)self.mRestaurant.restaurantId
                                mark:(NSNumber* )[NSString stringWithFormat:@"%f", rating]
                           Completed:^(NSDictionary *dic){
                               [SVProgressHUD dismiss];
                               NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                               f.numberStyle = NSNumberFormatterDecimalStyle;
                               NSString* ranking = [dic objectForKey:@"ranking"];
                               NSString* reviews = [dic objectForKey:@"amount"];
                               
                               self.mRatingView.rating = [ranking floatValue];
                               self.mReviewsLabel.text = [NSString stringWithFormat:@"(%@%@%@)", reviews, @" ", @"reviews"];
                               self.mRatingLabel.text = [NSString stringWithFormat:@"%.1f", [ranking floatValue]];
                               self.mRestaurant.ranking =  [NSNumber numberWithFloat:[ranking floatValue]];//[f numberFromString:ranking];
                               
                           }Failed:^(NSString *strError) {
                               [SVProgressHUD showErrorWithStatus:strError];
                           }];
}*/


- (IBAction)onClickFavoIconClick:(id)sender{
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
    [self infoBtnCkick];
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
