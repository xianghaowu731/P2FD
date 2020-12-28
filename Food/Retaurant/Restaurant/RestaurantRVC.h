//
//  RestaurantRVC.h
//  FoodOrder
//
//  Created by weiquan zhang on 6/14/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCRTableViewRefreshController.h"
#import "EDStarRating.h"

@interface RestaurantRVC : UIViewController<EDStarRatingProtocol>
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet EDStarRating *mRatingView;
@property (strong, nonatomic) IBOutlet UIImageView *mStatusIcon;
@property (strong, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *mRatingLabel;



@property (strong, nonatomic) NSMutableArray* data;
@property (nonatomic, strong) RCRTableViewRefreshController *refreshController;
- (IBAction)onAddClick:(id)sender;
- (IBAction)onBackClick:(id)sender;

@end
