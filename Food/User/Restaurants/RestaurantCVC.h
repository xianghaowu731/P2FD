//
//  RestaurantCVC.h
//  Food
//
//  Created by weiquan zhang on 6/16/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "Restaurant.h"
#import "RCRTableViewRefreshController.h"


@interface RestaurantCVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* data;
@property (strong, nonatomic) Restaurant *mRestaurant;
@property (nonatomic) UIImage *cartImg;
@property (nonatomic) NSInteger cartCount;

@property (nonatomic, strong) RCRTableViewRefreshController *refreshController;


@property (weak, nonatomic) IBOutlet UIButton *mCartBtn;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) IBOutlet UIButton *mFavoIcon;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;

- (IBAction)onClickFavoIconClick:(id)sender;
- (IBAction)onInfoClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onCartClick:(id)sender;

@end
