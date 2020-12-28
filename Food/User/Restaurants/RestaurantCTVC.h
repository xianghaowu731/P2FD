//
//  RestaurantCTVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "Restaurant.h"

@interface RestaurantCTVC : UITableViewCell

@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) Restaurant* data;
//@property (strong, nonatomic) NSNumber *cID;

- (void) setLayout:(Restaurant*)r;

//@property (weak, nonatomic) IBOutlet UIButton *mFavoIcon;
@property (strong, nonatomic) IBOutlet UIImageView *mResImageView;
@property (strong, nonatomic) IBOutlet UIImageView *mStatusIV;
@property (strong, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *mRestNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCountLabel;
@property (strong, nonatomic) IBOutlet EDStarRating *mRatingView;
@property (strong, nonatomic) IBOutlet UILabel *mRatingLabel;
//@property (strong, nonatomic) IBOutlet UILabel *mWorkTimeLabel;
//@property (strong, nonatomic) IBOutlet UILabel *mDescLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mStatusBackIV;
@property (strong, nonatomic) IBOutlet UILabel *mFeeLabel;

//- (IBAction)onFavoIconClick:(id)sender;
- (IBAction)onReviewClick:(id)sender;

@end
