//
//  RestaurantRVC.m
//  FoodOrder
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "RestaurantRVC.h"
#import "RRFoodTVCell.h"
#import "RFoodDetailVC.h"
#import "Config.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Restaurant.h"
#import <UIImageView+WebCache.h>
#import "RFoodAddVC.h"

@interface RestaurantRVC ()
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) NSString* restName;
@end

//extern NSString* myID;
extern Restaurant *owner;

@implementation RestaurantRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    /*[self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.navigationController.navigationBar.tintColor = PRIMARY_COLOR;
        
    } else {// iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = PRIMARY_COLOR;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }
    self.navigationItem.title = @"Restaurant";*/
    
    self.colors = @[ [UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0f], [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f], [UIColor colorWithRed:0.1f green:1.0f blue:0.1f alpha:1.0f]];
    // Setup control using iOS7 tint Color
    self.mRatingView.backgroundColor  = self.colors[1];//[UIColor whiteColor];
    self.mRatingView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRatingView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRatingView.maxRating = 5.0;
    self.mRatingView.delegate = self;
    self.mRatingView.horizontalMargin = 5.0;
    self.mRatingView.editable=NO;
    float rating = 4.65f;
    self.mRatingView.rating= rating;
    self.mRatingView.displayMode=EDStarRatingDisplayAccurate;
    [self.mRatingView  setNeedsDisplay];
    self.mRatingView.tintColor = self.colors[0];
    self.mRatingLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    //[self starsSelectionChanged:self.mRatingView rating:2.5];
    
    CALayer *imageLayer = self.mStatusIcon.layer;
    [imageLayer setCornerRadius:self.mStatusIcon.frame.size.width/2];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];
    //[imageLayer setBorderColor:self.colors[2].CGColor];
    [self.mImageView setBackgroundColor:self.colors[2]];
    self.refreshController = [[RCRTableViewRefreshController alloc] initWithTableView:self.mTableView refreshHandler:^{
        [self getData];
    }];
    //[self getData];
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

- (void)viewDidUnload
{
    self.mRatingView = nil;
    /*[self setmRatingView:nil];
    [self setStarRatingLabel:nil];
    [self setStarRatingImage:nil];
    [self setStarRatingImageLabel:nil];
    */
     [super viewDidUnload];
    // Release any retained subviews of the main view.
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
        //_starRatingImageLabel.text = ratingString;
}

- (void)getData{
    
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getAdminFoodsByRestId:owner.restaurantId Completed:^(NSString *array){
        [SVProgressHUD dismiss];
        NSDictionary* data = (NSDictionary*) array;
        self.restName = [data objectForKey:@"rest_name"];
        NSMutableArray* mArray = [[NSMutableArray alloc] init];
        mArray = [data objectForKey:@"foods"];
        self.data = [[NSMutableArray alloc] init];
        for(int i=0;i< mArray.count;i++){
            Food* food = [[Food alloc] initWithDictionary:mArray[i]];
            [self.data addObject:food];
        }
        [self.mTableView reloadData];
        [self setLayout];
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


- (void) setLayout {
    NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, RESTAURANT_IMAGE_BASE_URL, owner.img];
    [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    self.mStatusLabel.text = owner.status;
    if([owner.status isEqualToString:STATUS_OPEN]){
        [self.mStatusIcon setBackgroundColor:OPEN_COLOR];
    } else if([owner.status isEqualToString:STATUS_CLOSE]) {
        [self.mStatusIcon setBackgroundColor:CLOSE_COLOR];
    } else {
        [self.mStatusIcon setBackgroundColor:BUSY_COLOR];
    }
    float rating = [owner.ranking floatValue];
    self.mRatingView.rating= rating;
    [self.mRatingView  setNeedsDisplay];
    self.mRatingLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    
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
    return 92;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RRFoodTVCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_RRFoodTVCell" forIndexPath:indexPath];
    cell.cID = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.mNavController = self.navigationController;
    [cell setLayout:self.data[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*RFoodDetailVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_RFoodDetailVC"];
    mVC.mType = @"rest";
    mVC.data = self.data[indexPath.row];
    [self.navigationController pushViewController:mVC animated:YES];*/
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onAddClick:(id)sender {
    Food *oneFood = [[Food alloc] init];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RFoodAddVC* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_RFoodAddVC"];
    oneFood.restId = owner.restaurantId;
    oneFood.name = @"food";
    oneFood.desc = @"";
    oneFood.img = @"";
    oneFood.price = 0;
    mVC.data = oneFood;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onBackClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_InitNC"];
    [self presentViewController:mVC animated:YES completion:NULL];
}
@end
