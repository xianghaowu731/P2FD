//
//  CartDateView.h
//  Food
//
//  Created by meixiang wu on 7/15/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartDateView : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mDescLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *mDatePicker;
@property (weak, nonatomic) IBOutlet UIView *mTodayView;
@property (weak, nonatomic) IBOutlet UILabel *mTodayLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTodayDateLabel;
@property (weak, nonatomic) IBOutlet UIView *m1stView;
@property (weak, nonatomic) IBOutlet UILabel *m1stNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *m1stDateLabel;
@property (weak, nonatomic) IBOutlet UIView *m2ndView;
@property (weak, nonatomic) IBOutlet UILabel *m2ndNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *m2ndDateLabel;
@property (weak, nonatomic) IBOutlet UIView *m3rdView;
@property (weak, nonatomic) IBOutlet UILabel *m3rdNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *m3rdDateLabel;
@property (weak, nonatomic) IBOutlet UIView *m4thView;
@property (weak, nonatomic) IBOutlet UILabel *m4thNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *m4thDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *mChooseBtn;
@property (nonatomic) NSString *mRestName;
@property (nonatomic) float mDeliveryDist;

- (IBAction)onTimeClick:(id)sender;
- (IBAction)onChooseClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onTodayClick:(id)sender;
- (IBAction)on1stClick:(id)sender;
- (IBAction)on2ndClick:(id)sender;
- (IBAction)on3rdClick:(id)sender;
- (IBAction)on4thClick:(id)sender;

@end
