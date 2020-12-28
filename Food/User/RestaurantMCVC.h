//
//  RestaurantMCVC.h
//  Food
//
//  Created by meixiang wu on 6/2/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "Restaurant.h"

@interface RestaurantMCVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *mCateView;
@property (nonatomic) UIImage *cartImg;
@property (nonatomic) NSInteger cartCount;

@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *mFavoIcon;
@property (strong, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *mCartBtn;
@property (weak, nonatomic) IBOutlet UIImageView *mRestImg;

@property (strong, nonatomic) IBOutlet EDStarRating *mRateView;
@property (strong, nonatomic) IBOutlet UILabel *mRateLabel;

@property (strong, nonatomic) Restaurant *mRestaurant;
@property (strong, nonatomic) NSArray *colors;

- (IBAction)onClickFavoIconClick:(id)sender;
- (IBAction)onInfoClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onCartClick:(id)sender;

@end
