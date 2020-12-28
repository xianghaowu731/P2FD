//
//  RatingReviewVC.m
//  Food
//
//  Created by meixiang wu on 21/02/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import "RatingReviewVC.h"
#import "Customer.h"
#import "ReviewTableViewCell.h"
#import "ReviewModel.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>

extern Customer* customer;
@interface RatingReviewVC (){
    float mRanking;
    NSInteger rate_count;
}

@end

@implementation RatingReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mCommentView.hidden = YES;
    self.mAddBtn.hidden = NO;
    
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
    
    self.mSetRateView.backgroundColor  = self.colors[1];//[UIColor whiteColor];
    self.mSetRateView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mSetRateView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mSetRateView.maxRating = 5.0;
    self.mSetRateView.delegate = (id)self;
    self.mSetRateView.horizontalMargin = 1.0;
    self.mSetRateView.editable=YES;
    rating = 5.0;
    self.mSetRateView.rating= rating;
    self.mSetRateView.displayMode=EDStarRatingDisplayAccurate;
    [self.mSetRateView  setNeedsDisplay];
    self.mSetRateView.tintColor = self.colors[0];
    
    CALayer *imageLayer = self.mCommentTxt.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [self loadData];
}

- (void)loadData{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getReviewsById:self.mRestaurant.restaurantId Completed:^(NSDictionary *array){
        [SVProgressHUD dismiss];
        
        self.data = [[NSMutableArray alloc] init];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *value = [f numberFromString:[array objectForKey:@"ranking"]];
        mRanking = [value floatValue];
        self.mRateView.rating = mRanking;
        value = [f numberFromString:[array objectForKey:@"amount"]];
        rate_count = [value integerValue];
        self.mRateCountLabel.text = [NSString stringWithFormat:@"%ld Ratings",rate_count];
        
        NSArray *data_array = [array objectForKey:@"reviews"];
        
        for(int i=0;i<data_array.count;i++){
            ReviewModel* one = [[ReviewModel alloc] initWithDictionary:data_array[i]];
            if([one.userid isEqualToString:customer.customerId]){
                self.mAddBtn.hidden = YES;
            }
            [self.data addObject:one];
        }
        self.mTableTitleLabel.text = [NSString stringWithFormat:@"Reviews (%ld)", self.data.count];
        [self.mTableView reloadData];
        
    }Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
    [self dataHasRefreshed];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewModel *one = self.data[indexPath.row];
    self.mCalcLabel.text = one.comment;
    CGFloat fixedWidth = self.mCalcLabel.frame.size.width;
    CGSize newSize = [self.mCalcLabel sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGFloat h = 78 + newSize.height;
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    ReviewTableViewCell* c = [tableView dequeueReusableCellWithIdentifier:@"RID_ReviewTableViewCell" forIndexPath:indexPath];
    [c setLayout:self.data[indexPath.row]];
    cell = c;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dataHasRefreshed {
    // Ensure we're on the main queue as we'll be updating the UI (not strictly necessary for this example, but will likely be essential in less trivial scenarios and so is included for illustrative purposes)
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // At some point later, when we're done getting our new data, tell our refresh controller to end refreshing
        [self.refreshController endRefreshing];
        
        // Finally get the table view to reload its data
        [self.mTableView reloadData];
        
    });
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    if(control == self.mSetRateView){
        self.mSetRateLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    }
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddReviewClick:(id)sender {
    self.mCommentView.hidden = NO;
    [self.mCommentTxt becomeFirstResponder];
}
- (IBAction)onSendClick:(id)sender {
    NSNumber *rate_val = [[NSNumber alloc] initWithFloat:self.mSetRateView.rating];
    NSDate *todayDate = [NSDate date]; //Get todays date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
    [dateFormatter setDateFormat:@"EEE, MMM dd, yyyy"]; //Here we can set the format which we need
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    [SVProgressHUD show];
    [[HttpApi sharedInstance] doReview:customer.customerId Username:customer.userName RestID:self.mRestaurant.restaurantId Rank:rate_val Comment:self.mCommentTxt.text PostTime:convertedDateString Completed:^(NSString *array){
        [SVProgressHUD dismiss];
        self.mCommentView.hidden = YES;
        [self loadData];
    }Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
    [self dataHasRefreshed];
}
@end
