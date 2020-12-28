//
//  ReviewTableViewCell.h
//  Food
//
//  Created by meixiang wu on 21/02/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "ReviewModel.h"

@interface ReviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mMarkLabel;
@property (strong, nonatomic) IBOutlet EDStarRating *mRateView;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mContentLabel;

@property (strong, nonatomic) NSArray *colors;

- (void) setLayout:(ReviewModel*)f;

@end
