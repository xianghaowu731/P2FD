//
//  RestaurantMVCViewController.h
//  Food
//
//  Created by meixiang wu on 5/13/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"


@interface RestaurantMVC : UIViewController<EDStarRatingProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet EDStarRating *mRatingView;
@property (weak, nonatomic) IBOutlet UIImageView *mStatusIcon;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRatingLabel;

@property (weak, nonatomic) IBOutlet UIView *mView;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onEditMenuClick:(id)sender;

@end
