//
//  RatingReviewVC.h
//  Food
//
//  Created by meixiang wu on 21/02/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "Restaurant.h"
#import "RCRTableViewRefreshController.h"

@interface RatingReviewVC : UIViewController
@property (strong, nonatomic) IBOutlet EDStarRating *mRateView;
@property (weak, nonatomic) IBOutlet UILabel *mRateCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *mAddBtn;
@property (weak, nonatomic) IBOutlet UIView *mCommentView;
@property (weak, nonatomic) IBOutlet UITextView *mCommentTxt;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UILabel *mCalcLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTableTitleLabel;

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) Restaurant *mRestaurant;
@property (strong, nonatomic) NSArray *colors;
@property (nonatomic, strong) RCRTableViewRefreshController *refreshController;
@property (strong, nonatomic) IBOutlet EDStarRating *mSetRateView;
@property (weak, nonatomic) IBOutlet UILabel *mSetRateLabel;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onAddReviewClick:(id)sender;
- (IBAction)onSendClick:(id)sender;

@end
