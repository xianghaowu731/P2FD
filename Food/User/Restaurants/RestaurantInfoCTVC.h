//
//  RestaurantInfoCTVC.h
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface RestaurantInfoCTVC : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *mNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mEmailLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *mWorkTimeLabel;
@property (strong, nonatomic) IBOutlet UITextView *mDescText;
@property (strong, nonatomic) IBOutlet UILabel *mAddress;


@property (strong, nonatomic) Restaurant* data;
- (void) setLayout:(Restaurant*) r;

@end
