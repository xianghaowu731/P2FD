//
//  RFoodDetailVC.h
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@interface RFoodDetailVC : UIViewController

@property (strong, nonatomic) NSString* mType;
@property (strong, nonatomic) Food* data;
- (void) setLayout:(Food* )f;

@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet UILabel *mNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *mStatusLabel;

@property (strong, nonatomic) IBOutlet UITextView *mDescTV;
@property (strong, nonatomic) IBOutlet UIButton *mQuickBtn;
@property (strong, nonatomic) IBOutlet UIButton *mDelBtn;

- (IBAction)onClickDelete:(id)sender;
- (IBAction)onClickQuick:(id)sender;

@end
