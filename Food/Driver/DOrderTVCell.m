//
//  DOrderTVCell.m
//  Food
//
//  Created by meixiang wu on 19/09/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "DOrderTVCell.h"
#import "Deliver.h"
#import "Config.h"
#import <SVProgressHUD.h>
#import "HttpApi.h"

extern Deliver* deliver;
@implementation DOrderTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLayout:(Order*) o {
    self.data = o;
    self.mOrderIDLabel.text = o.orderId;//[NSString stringWithFormat:@"%@%@", @"100", o.orderId];
    self.mRestLabel.text = [NSString stringWithFormat:@"From: %@", o.restName];
    self.mRestPhoneLabel.text = o.restPhone;
    self.mNameLabel.text = [NSString stringWithFormat:@"To: %@  %@", o.tofirst, o.tolast];
    self.mToPhoneLabel.text = o.tophone;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSDate *date = [dateFormat dateFromString:o.orderTime];
    NSInteger tiptime = 20;//(long)(((self.mRest.mDistance/1000)/KM_PER_MILE)/DELIVERY_MILE_PER_MIN);
    NSDate *plusHour = [date dateByAddingTimeInterval:tiptime * 60.0f];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: plusHour];
    NSDate* real_date = [NSDate dateWithTimeInterval: seconds sinceDate: plusHour];
    self.mPublishLabel.text = [NSString stringWithFormat:@"Order In : %@", o.orderTime];
    if(o.pickup != nil && [o.pickup length] > 0){
        self.mTimeLabel.text = o.pickup;
        self.mChangeLabel.hidden = NO;
    } else{
        self.mTimeLabel.text = [NSString stringWithFormat:@"Time: %@", [dateFormat stringFromDate:real_date]];
        self.mChangeLabel.hidden = YES;
    }
    tiptime = 45;
    plusHour = [date dateByAddingTimeInterval:tiptime * 60.0f];
    NSDate *eHour = [date dateByAddingTimeInterval:(tiptime + 15) * 60.0f];
    
    seconds = [tz secondsFromGMTForDate: plusHour];
    real_date = [NSDate dateWithTimeInterval: seconds sinceDate: plusHour];
    seconds = [tz secondsFromGMTForDate: eHour];
    NSDate *real_date1 = [NSDate dateWithTimeInterval: seconds sinceDate: eHour];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    self.mEstLabel.text = [NSString stringWithFormat:@"Est. Delivery:%@-%@",[timeFormat stringFromDate:real_date] , [timeFormat stringFromDate:real_date1]];
    
    if([o.status_id isEqualToString:STATUS_WAITING]) {
        //processing status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Waiting";
        //==2017-5-9===
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_process.png"]];
        self.mAcceptBtn.hidden = NO;
        [self.mAcceptBtn setTitle:@"Accept" forState:UIControlStateNormal];
        [self.mAcceptBtn setImage:[UIImage imageNamed:@"ic_button_accept.png"] forState:UIControlStateNormal];
    } else if ([o.status_id isEqualToString:STATUS_ACCEPTED]) {
        //accepted status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Accepted";
        //==2017-5-9===
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_accept.png"]];
        self.mAcceptBtn.hidden = YES;
    } else if ([o.status_id isEqualToString:STATUS_REJECTED]) {
        //rejected status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Rejected";
        //==2017-5-9===
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_reject.png"]];
        self.mAcceptBtn.hidden = YES;
    } else if ([o.status_id isEqualToString:STATUS_CANCELED]) {
        //canceled status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Cancelled";
        //==2017-5-9===
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_cancel.png"]];
        self.mAcceptBtn.hidden = YES;
    } else if ([o.status_id isEqualToString:STATUS_PREPARED]) {
        //prepared status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Ready";
        //==2017-9-22===
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_process.png"]];
        if([o.driverId isEqualToString:deliver.dId]){
            self.mAcceptBtn.hidden = NO;
            [self.mAcceptBtn setTitle:@"Delivery" forState:UIControlStateNormal];
            [self.mAcceptBtn setImage:[UIImage imageNamed:@"ic_state_process.png"] forState:UIControlStateNormal];
        }
    } else if ([o.status_id isEqualToString:STATUS_DELIVERING]) {
        //delivering status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Delivering";
        //==2017-5-9===
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_process.png"]];
        if([o.driverId isEqualToString:deliver.dId]){
            self.mAcceptBtn.hidden = NO;
            [self.mAcceptBtn setTitle:@"Complete" forState:UIControlStateNormal];
            [self.mAcceptBtn setImage:[UIImage imageNamed:@"ic_state_complete.png"] forState:UIControlStateNormal];
        }
    }else {
        //completed status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Completed";
        //==2017-5-9===
        [self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_complete.png"]];
        self.mAcceptBtn.hidden = YES;
    }
}

- (IBAction)onButtonClick:(id)sender {
    if([self.data.status_id isEqualToString:STATUS_WAITING]){
        [SVProgressHUD show];
        [[HttpApi sharedInstance] doAccept:(NSString *)self.data.orderId DriverID:deliver.dId
                                 Completed:^(NSDictionary *array){
                                     [SVProgressHUD dismiss];
                                     NSNotification *msg = [NSNotification notificationWithName:@"ChangeOrderStatus" object:nil userInfo:nil];
                                     [[NSNotificationCenter defaultCenter] postNotification:msg];
                                 }Failed:^(NSString *strError) {
                                     [SVProgressHUD showErrorWithStatus:strError];
                                 }];
        
    } else if([self.data.status_id isEqualToString:STATUS_PREPARED]){
        [SVProgressHUD show];
        [[HttpApi sharedInstance] doDelivery:(NSString *)self.data.orderId
                                   Completed:^(NSDictionary *array){
                                       [SVProgressHUD dismiss];                                       
                                       NSNotification *msg = [NSNotification notificationWithName:@"ChangeOrderStatus" object:nil userInfo:nil];
                                       [[NSNotificationCenter defaultCenter] postNotification:msg];
                                       
                                   }Failed:^(NSString *strError) {
                                       [SVProgressHUD showErrorWithStatus:strError];
                                   }];
    } else if([self.data.status_id isEqualToString:STATUS_DELIVERING]){
        //complete action
        [SVProgressHUD show];
        [[HttpApi sharedInstance] doComplete:(NSString *)self.data.orderId
                                   Completed:^(NSDictionary *array){
                                       [SVProgressHUD dismiss];
                                       NSNotification *msg = [NSNotification notificationWithName:@"ChangeOrderStatus" object:nil userInfo:nil];
                                       [[NSNotificationCenter defaultCenter] postNotification:msg];
                                   }Failed:^(NSString *strError) {
                                       [SVProgressHUD showErrorWithStatus:strError];
                                   }];
    }
}

- (IBAction)onRestCall:(id)sender {
    NSString *phoneNumber = [self.mRestPhoneLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([phoneNumber length] == 0) return;
    NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://+1" stringByAppendingString:phoneNumber]];
    NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://+1" stringByAppendingString:phoneNumber]];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:phoneUrl options:@{}
                                     completionHandler:^(BOOL success) {
                                         NSLog(@"Open call: %d",success);
                                     }];
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:phoneUrl];
            NSLog(@"Open call: %d",success);
        }
        
        
    }
    else{
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else if ([[UIApplication sharedApplication] canOpenURL:phoneFallbackUrl]) {
            [[UIApplication sharedApplication] openURL:phoneFallbackUrl];
        } else {
            UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }
    }
}

- (IBAction)onUserCall:(id)sender {
    NSString *phoneNumber = [self.mToPhoneLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([phoneNumber length] == 0) return;
    NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://+1" stringByAppendingString:phoneNumber]];
    NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://+1" stringByAppendingString:phoneNumber]];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:phoneUrl options:@{}
                                     completionHandler:^(BOOL success) {
                                         NSLog(@"Open call: %d",success);
                                     }];
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:phoneUrl];
            NSLog(@"Open call: %d",success);
        }
        
        
    }
    else{
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else if ([[UIApplication sharedApplication] canOpenURL:phoneFallbackUrl]) {
            [[UIApplication sharedApplication] openURL:phoneFallbackUrl];
        } else {
            UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }
    }
}

@end
