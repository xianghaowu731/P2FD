//
//  FoodDetailCVC.h
//  Food
//
//  Created by weiquan zhang on 6/16/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
#import "UITextView+Placeholder.h"
#import "Restaurant.h"
//#import "RCRTableViewRefreshController.h"

@interface FoodDetailCVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Food* data;
@property (strong, nonatomic) NSMutableArray* m_extdata;
//@property (nonatomic, strong) RCRTableViewRefreshController *refreshController;
@property (strong, nonatomic) NSMutableArray* cartdata;
@property (strong, nonatomic) NSString* restId;
@property (strong, nonatomic) Restaurant* restaurant;

@property (nonatomic) NSInteger mQuantity;

@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet UILabel *mNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (strong, nonatomic) IBOutlet UITextView *mDescTV;
@property (weak, nonatomic) IBOutlet UILabel *mQuantityLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *mExtraView;

@property (weak, nonatomic) IBOutlet UILabel *mTotalLabel;
@property (weak, nonatomic) IBOutlet UITextView *mInstructionText;
@property (weak, nonatomic) IBOutlet UIView *mEffectView;
@property (weak, nonatomic) IBOutlet UIView *mFoodListView;
@property (weak, nonatomic) IBOutlet UIButton *mCartBtn;

@property (nonatomic) UIImage *cartImg;
@property (nonatomic) NSInteger cartCount;

- (IBAction)onCartClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onPlusClick:(id)sender;
- (IBAction)onMinuteClick:(id)sender;
- (IBAction)onBagItClick:(id)sender;
- (IBAction)onCancelClick:(id)sender;

@end
