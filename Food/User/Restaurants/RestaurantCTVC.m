//
//  RestaurantCTVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "RestaurantCTVC.h"
#import "Config.h"
#import "Common.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Restaurant.h"
#import <UIImageView+WebCache.h>
#import "Customer.h"

extern Customer* customer;


@implementation RestaurantCTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CALayer *imageLayer = self.mResImageView.layer;
    //[imageLayer setCornerRadius:self.mImageView.frame.size.width/2];
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    [self.mResImageView setImage:[UIImage imageNamed:@"sample_rest.png"]];
    
    imageLayer = self.mStatusIV.layer;
    [imageLayer setCornerRadius:self.mStatusIV.frame.size.width/2];
        
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.mStatusBackIV.bounds byRoundingCorners:(UIRectCornerTopLeft) cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.mStatusBackIV.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.mStatusBackIV.layer.mask = maskLayer;
    
    self.colors = @[ [UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0f], [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f], [UIColor colorWithRed:0.1f green:1.0f blue:0.1f alpha:1.0f]];
    // Setup control using iOS7 tint Color
    self.mRatingView.backgroundColor  = self.colors[1];//[UIColor whiteColor];
    self.mRatingView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRatingView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRatingView.maxRating = 5.0;
    self.mRatingView.delegate = (id)self;
    self.mRatingView.horizontalMargin = 2.0;
    self.mRatingView.editable=NO;
    float rating = 4.65f;
    self.mRatingView.rating= rating;
    self.mRatingView.displayMode=EDStarRatingDisplayAccurate;
    [self.mRatingView  setNeedsDisplay];
    self.mRatingView.tintColor = self.colors[0];
    self.mRatingLabel.text = [NSString stringWithFormat:@"%.1f", rating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setLayout:(Restaurant*)r {
    
    self.data = r;
    self.mRestNameLabel.text = r.name;
    self.mStatusLabel.text = r.status;
    if(![r.img isEqual:nil] && ![r.img isEqualToString:@""]){
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, RESTAURANT_IMAGE_BASE_URL, r.img];
        [self.mResImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    } else [self.mResImageView setImage:[UIImage imageNamed:@"sample_rest.png"]];
    if([r.status isEqualToString:STATUS_OPEN]){
        [self.mStatusIV setImage:[UIImage imageNamed:@"ic_state_complete.png"]];//[self.mStatusIV setBackgroundColor:OPEN_COLOR];
    } else if([r.status isEqualToString:STATUS_CLOSE]) {
        [self.mStatusIV setImage:[UIImage imageNamed:@"ic_state_cancel.png"]];//[self.mStatusIV setBackgroundColor:CLOSE_COLOR];
    } else {
        [self.mStatusIV setImage:[UIImage imageNamed:@"ic_state_process.png"]];//[self.mStatusIV setBackgroundColor:BUSY_COLOR];
    }
    float rating = [r.ranking floatValue];
    self.mRatingView.rating= rating;
    [self.mRatingView  setNeedsDisplay];
    self.mRatingLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    NSInteger review_cnt = [r.reviews integerValue];
    self.mCountLabel.text = [NSString stringWithFormat:@"%ld reviews", (long)review_cnt];
    
    float fee_distance = r.mDistance / 1000;
    float m_fee = DELIVERY_FEE_PER_DEFAULT;
    if(r.mDistance >= 0.0 && [r.address length] > 0){//fee_distance < 50 &&
        if(fee_distance < KM_PER_MILE * DELIVERY_DEFAULT_DISTANCE){
            m_fee = DELIVERY_FEE_PER_DEFAULT; //5.0$
        } else{
            m_fee = DELIVERY_FEE_PER_DEFAULT + (fee_distance/KM_PER_MILE - DELIVERY_DEFAULT_DISTANCE)*DELIVERY_ADD_FEE;//over 10mile add 0.5$
        }
        self.mFeeLabel.text = [NSString stringWithFormat:@"%.2f Delivery Fee", m_fee];
    } else{
        self.mFeeLabel.text = @"Delivery Unavailable";
    }
    
    
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

/*- (IBAction)onFavoIconClick:(id)sender {
    [SVProgressHUD show];
    [[HttpApi sharedInstance] updateRestaurantFavoriteByCustomerId:customer.customerId
                                                            RestId:self.data.restaurantId
                                                         Completed:^(long is_favorite){
                                                             [SVProgressHUD dismiss];
                                                             
                                                             if(is_favorite) {
                                                                 [self.mFavoIcon setImage:[UIImage imageNamed:@"hart.png"] forState:UIControlStateNormal];
                                                                 
                                                             } else {
                                                                 [self.mFavoIcon setImage:[UIImage imageNamed:@"hart_line.png"] forState:UIControlStateNormal];
                                                             }
                                                             self.data.isfavorite = [NSNumber numberWithLong:is_favorite];
                                                             NSNumber* nTag = [NSNumber numberWithInteger:[self.data.cID integerValue]];
                                                             
                                                             NSDictionary *dic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:nTag, self.data.isfavorite, nil] forKeys:[NSArray arrayWithObjects:@"cellTag", @"isfavorite", nil]];
                                                             
                                                             NSNotification *msg = [NSNotification notificationWithName:@"RChangedFavorite" object:nil userInfo:dic];
                                                             [[NSNotificationCenter defaultCenter] postNotification:msg];
                                                         }Failed:^(NSString *strError) {
                                                             [SVProgressHUD showErrorWithStatus:strError];
                                                         }];
}*/
- (IBAction)onReviewClick:(id)sender {
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"rest":self.data
                                                                                       }];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REVIEW_VIEW object:self userInfo:dicParams];
}
@end
