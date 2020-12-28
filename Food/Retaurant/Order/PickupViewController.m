//
//  PickupViewController.m
//  Food
//
//  Created by meixiang wu on 23/02/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import "PickupViewController.h"
#import "AppDelegate.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>

@interface PickupViewController (){
    NSString *fromtime;
}

@end

@implementation PickupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mDatePicker setDate:[NSDate date]];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    fromtime = [outputFormatter stringFromDate:[NSDate date]];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLayout{
    //------------today-----------------------------
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *todayStr=[dateFormatter stringFromDate:[NSDate date]];
    self.mTodayLabel.text = todayStr;
    
    NSString *btnStr = [NSString stringWithFormat:@"Pickup today at %@", fromtime];
    [self.mPickupBtn setTitle:btnStr forState:UIControlStateNormal];
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
    [self setLayout];
}
- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPickupClick:(id)sender {
    NSDate *todayDate = [NSDate date]; //Get todays date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
    [dateFormatter setDateFormat:@"MM-dd-yyyy"]; //Here we can set the format which we need
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    NSString *pickTime = [NSString stringWithFormat:@"%@ , %@", convertedDateString, fromtime];
    [SVProgressHUD show];
    [[HttpApi sharedInstance] changePickupTime:self.data.orderId Pickuptime:pickTime Completed:^(NSString *result) {
        [self.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}
@end
