//
//  FoodCustomViewCell.h
//  Food
//
//  Created by meixiang wu on 6/2/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@interface FoodCustomViewCell : UITableViewCell
@property (strong, nonatomic) NSString* cID;
@property (strong, nonatomic) UINavigationController* mNavController;
@property (strong, nonatomic) Food* data;
- (void) setLayout:(Food*)f;

@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet UILabel *mNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *mFavIcon;
@property (strong, nonatomic) IBOutlet UILabel *mCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDescription;

- (IBAction)onFavIconClick:(id)sender;
- (IBAction)onPlusIconClick:(id)sender;
- (IBAction)onFoodDetailClick:(id)sender;

@end
