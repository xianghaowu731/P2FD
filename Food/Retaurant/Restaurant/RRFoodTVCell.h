//
//  RRFoodTVCell.h
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@interface RRFoodTVCell : UITableViewCell

@property (strong, nonatomic) NSString* cID;
@property (strong, nonatomic) UINavigationController* mNavController;
@property (strong, nonatomic) Food* data;

@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet UILabel *mNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mDescLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mStatusBackIV;


- (IBAction)onEditClick:(id)sender;

- (void) setLayout:(Food*) data;

@end
