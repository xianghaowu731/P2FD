//
//  CartDateView.m
//  Food
//
//  Created by meixiang wu on 7/15/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "CartDateView.h"
#import "Config.h"
#import "AppDelegate.h"

@interface CartDateView (){
    NSInteger mBtnSel;
    NSArray *weekdayNameArray;
    NSString *fromtime,*totimeStr;
    NSString *selDay;
}

@end

@implementation CartDateView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    g_appDelegate.mViewState = 8;
    weekdayNameArray = [NSArray alloc];
    weekdayNameArray = @[@"Sun",@"Mon", @"Tue", @"Wed", @"Thu",@"Fri",@"Sat"];
    mBtnSel = 0;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    fromtime = [outputFormatter stringFromDate:[NSDate date]];
    
    [self.mDatePicker setDate:[NSDate date]];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLayout{
    //------------today-----------------------------
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *todayStr=[dateFormatter stringFromDate:[NSDate date]];

    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    NSString *firstStr = [dateFormatter stringFromDate:nextDate];
    dayComponent.day = 2;
    NSDate *secondDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    NSString *secondStr = [dateFormatter stringFromDate:secondDate];
    dayComponent.day = 3;
    NSDate *thirdDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    NSString *thirdStr = [dateFormatter stringFromDate:thirdDate];
    dayComponent.day = 4;
    NSDate *forthDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    NSString *forthStr = [dateFormatter stringFromDate:forthDate];
    //---------- weekday ------------------------
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
                                                       fromDate:[NSDate date]];
    //================================================================
    
    switch (mBtnSel) {
        case 0:
            selDay = todayStr;
            self.mTodayView.backgroundColor = DATEVIEW_SEL_BG_COLOR;
            [self.mTodayLabel setTextColor:DATEVIEW_SEL_TEXT_COLOR];
            [self.mTodayDateLabel setTextColor:DATEVIEW_SEL_TEXT_COLOR];
            self.m1stView.backgroundColor = [UIColor whiteColor];
            [self.m1stNameLabel setTextColor:[UIColor blackColor]];
            [self.m1stDateLabel setTextColor:[UIColor blackColor]];
            self.m2ndView.backgroundColor = [UIColor whiteColor];
            [self.m2ndNameLabel setTextColor:[UIColor blackColor]];
            [self.m2ndDateLabel setTextColor:[UIColor blackColor]];
            self.m3rdView.backgroundColor = [UIColor whiteColor];
            [self.m3rdNameLabel setTextColor:[UIColor blackColor]];
            [self.m3rdDateLabel setTextColor:[UIColor blackColor]];
            self.m4thView.backgroundColor = [UIColor whiteColor];
            [self.m4thNameLabel setTextColor:[UIColor blackColor]];
            [self.m4thDateLabel setTextColor:[UIColor blackColor]];
            break;
        case 1:
            selDay = firstStr;
            self.mTodayView.backgroundColor = [UIColor whiteColor];
            [self.mTodayLabel setTextColor:[UIColor blackColor]];
            [self.mTodayDateLabel setTextColor:[UIColor blackColor]];
            self.m1stView.backgroundColor = DATEVIEW_SEL_BG_COLOR;
            [self.m1stNameLabel setTextColor:DATEVIEW_SEL_TEXT_COLOR];
            [self.m1stDateLabel setTextColor:DATEVIEW_SEL_TEXT_COLOR];
            self.m2ndView.backgroundColor = [UIColor whiteColor];
            [self.m2ndNameLabel setTextColor:[UIColor blackColor]];
            [self.m2ndDateLabel setTextColor:[UIColor blackColor]];
            self.m3rdView.backgroundColor = [UIColor whiteColor];
            [self.m3rdNameLabel setTextColor:[UIColor blackColor]];
            [self.m3rdDateLabel setTextColor:[UIColor blackColor]];
            self.m4thView.backgroundColor = [UIColor whiteColor];
            [self.m4thNameLabel setTextColor:[UIColor blackColor]];
            [self.m4thDateLabel setTextColor:[UIColor blackColor]];
            break;
        case 2:
            selDay = secondStr;
            self.mTodayView.backgroundColor = [UIColor whiteColor];
            [self.mTodayLabel setTextColor:[UIColor blackColor]];
            [self.mTodayDateLabel setTextColor:[UIColor blackColor]];
            self.m1stView.backgroundColor = [UIColor whiteColor];
            [self.m1stNameLabel setTextColor:[UIColor blackColor]];
            [self.m1stDateLabel setTextColor:[UIColor blackColor]];
            self.m2ndView.backgroundColor = DATEVIEW_SEL_BG_COLOR;
            [self.m2ndNameLabel setTextColor:DATEVIEW_SEL_TEXT_COLOR];
            [self.m2ndDateLabel setTextColor:DATEVIEW_SEL_TEXT_COLOR];
            self.m3rdView.backgroundColor = [UIColor whiteColor];
            [self.m3rdNameLabel setTextColor:[UIColor blackColor]];
            [self.m3rdDateLabel setTextColor:[UIColor blackColor]];
            self.m4thView.backgroundColor = [UIColor whiteColor];
            [self.m4thNameLabel setTextColor:[UIColor blackColor]];
            [self.m4thDateLabel setTextColor:[UIColor blackColor]];
            break;
        case 3:
            selDay = thirdStr;
            self.mTodayView.backgroundColor = [UIColor whiteColor];
            [self.mTodayLabel setTextColor:[UIColor blackColor]];
            [self.mTodayDateLabel setTextColor:[UIColor blackColor]];
            self.m1stView.backgroundColor = [UIColor whiteColor];
            [self.m1stNameLabel setTextColor:[UIColor blackColor]];
            [self.m1stDateLabel setTextColor:[UIColor blackColor]];
            self.m2ndView.backgroundColor = [UIColor whiteColor];
            [self.m2ndNameLabel setTextColor:[UIColor blackColor]];
            [self.m2ndDateLabel setTextColor:[UIColor blackColor]];
            self.m3rdView.backgroundColor = DATEVIEW_SEL_BG_COLOR;
            [self.m3rdNameLabel setTextColor:DATEVIEW_SEL_TEXT_COLOR];
            [self.m3rdDateLabel setTextColor:DATEVIEW_SEL_TEXT_COLOR];
            self.m4thView.backgroundColor = [UIColor whiteColor];
            [self.m4thNameLabel setTextColor:[UIColor blackColor]];
            [self.m4thDateLabel setTextColor:[UIColor blackColor]];
            break;
        case 4:
            selDay = forthStr;
            self.mTodayView.backgroundColor = [UIColor whiteColor];
            [self.mTodayLabel setTextColor:[UIColor blackColor]];
            [self.mTodayDateLabel setTextColor:[UIColor blackColor]];
            self.m1stView.backgroundColor = [UIColor whiteColor];
            [self.m1stNameLabel setTextColor:[UIColor blackColor]];
            [self.m1stDateLabel setTextColor:[UIColor blackColor]];
            self.m2ndView.backgroundColor = [UIColor whiteColor];
            [self.m2ndNameLabel setTextColor:[UIColor blackColor]];
            [self.m2ndDateLabel setTextColor:[UIColor blackColor]];
            self.m3rdView.backgroundColor = [UIColor whiteColor];
            [self.m3rdNameLabel setTextColor:[UIColor blackColor]];
            [self.m3rdDateLabel setTextColor:[UIColor blackColor]];
            self.m4thView.backgroundColor = DATEVIEW_SEL_BG_COLOR;
            [self.m4thNameLabel setTextColor:DATEVIEW_SEL_TEXT_COLOR];
            [self.m4thDateLabel setTextColor:DATEVIEW_SEL_TEXT_COLOR];
            break;
        default:
            self.mTodayView.backgroundColor = [UIColor whiteColor];
            [self.mTodayLabel setTextColor:[UIColor blackColor]];
            [self.mTodayDateLabel setTextColor:[UIColor blackColor]];
            self.m1stView.backgroundColor = [UIColor whiteColor];
            [self.m1stNameLabel setTextColor:[UIColor blackColor]];
            [self.m1stDateLabel setTextColor:[UIColor blackColor]];
            self.m2ndView.backgroundColor = [UIColor whiteColor];
            [self.m2ndNameLabel setTextColor:[UIColor blackColor]];
            [self.m2ndDateLabel setTextColor:[UIColor blackColor]];
            self.m3rdView.backgroundColor = [UIColor whiteColor];
            [self.m3rdNameLabel setTextColor:[UIColor blackColor]];
            [self.m3rdDateLabel setTextColor:[UIColor blackColor]];
            self.m4thView.backgroundColor = [UIColor whiteColor];
            [self.m4thNameLabel setTextColor:[UIColor blackColor]];
            [self.m4thDateLabel setTextColor:[UIColor blackColor]];
            break;
    }
    if(mBtnSel != 0 ) g_isChangeDateTime = true;
    self.mTodayDateLabel.text = todayStr;
    self.m1stDateLabel.text = firstStr;
    self.m2ndDateLabel.text = secondStr;
    self.m3rdDateLabel.text = thirdStr;
    self.m4thDateLabel.text = forthStr;
    self.m1stNameLabel.text = weekdayNameArray[(weekday + 0) % 7];
    self.m2ndNameLabel.text = weekdayNameArray[(weekday + 1) % 7];
    self.m3rdNameLabel.text = weekdayNameArray[(weekday + 2) % 7];
    self.m4thNameLabel.text = weekdayNameArray[(weekday + 3) % 7];
    NSString *selDate = @"today";
    if(mBtnSel != 0) selDate = [NSString stringWithFormat:@"%@", weekdayNameArray[(mBtnSel+ 2) % 7]];
    NSString *btnStr = [NSString stringWithFormat:@"Delivery %@ at %@", selDate, fromtime];
    
    NSInteger deliverytime = 15;//(long)(((self.mDeliveryDist/1000)/KM_PER_MILE)/DELIVERY_MILE_PER_MIN);
    NSDate *plusHour = [self.mDatePicker.date dateByAddingTimeInterval:deliverytime * 60.0f];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    totimeStr = [outputFormatter stringFromDate:plusHour];
    self.mDescLabel.text = [NSString stringWithFormat:@"%@ can deliver %@ ~ %@", self.mRestName, fromtime, totimeStr];
    [self.mChooseBtn setTitle:btnStr forState:UIControlStateNormal];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTimeClick:(id)sender {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    fromtime = [outputFormatter stringFromDate:self.mDatePicker.date];
    g_isChangeDateTime = true;
    [self setLayout];
}

- (IBAction)onChooseClick:(id)sender {
    NSDate *todayDate = [NSDate date]; //Get todays date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
    [dateFormatter setDateFormat:@"MM-yyyy"]; //Here we can set the format which we need
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    NSArray*foo = [convertedDateString componentsSeparatedByString:@"-"];
    g_deliveryTime = [NSString stringWithFormat:@"%@-%@-%@ , %@ ~ %@", foo[0], selDay, foo[1], fromtime, totimeStr];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTodayClick:(id)sender {
    mBtnSel = 0;
    [self setLayout];
}

- (IBAction)on1stClick:(id)sender {
    mBtnSel = 1;
    [self setLayout];
}
- (IBAction)on2ndClick:(id)sender {
    mBtnSel = 2;
    [self setLayout];
}

- (IBAction)on3rdClick:(id)sender {
    mBtnSel = 3;
    [self setLayout];
}

- (IBAction)on4thClick:(id)sender {
    mBtnSel = 4;
    [self setLayout];
}
@end
