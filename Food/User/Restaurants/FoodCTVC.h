//
//  FoodCTVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@interface FoodCTVC : UITableViewCell
@property (strong, nonatomic) NSString* cID;
@property (strong, nonatomic) UINavigationController* mNavController;
@property (strong, nonatomic) Food* data;
- (void) setLayout:(Food*)f;

@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet UILabel *mNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *mDescription;
@property (strong, nonatomic) IBOutlet UIButton *mFavIcon;
@property (strong, nonatomic) IBOutlet UILabel *mCountLabel;

- (IBAction)onFavIconClick:(id)sender;
- (IBAction)onPlusIconClick:(id)sender;

@end
