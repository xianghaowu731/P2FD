//
//  ROrderTVCell.m
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "ROrderTVCell.h"
#import "Config.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "PromptDialog.h"

@implementation ROrderTVCell{
    PromptDialog *pDlg;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLayout:(Order*) o {
    self.data = o;
    self.mOrderIDLabel.text = o.orderId;//[NSString stringWithFormat:@"%@%@", @"100", o.orderId];
    self.mAddressLabel.text = o.address;
    self.mCustomerNameLabel.text = [NSString stringWithFormat:@"Customer : %@   %@",o.tofirst, o.tolast];
    self.mDriverNameLabel.text = [NSString stringWithFormat:@"Driver : %@", o.restName];
    self.mDriverPhoneLabel.text = o.restPhone;
    self.mOrderInLabel.text = [NSString stringWithFormat:@"Order In : %@", o.orderTime];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSDate *date = [dateFormat dateFromString:o.orderTime];
    NSInteger tiptime = 20;//(long)(((self.mRest.mDistance/1000)/KM_PER_MILE)/DELIVERY_MILE_PER_MIN);
    NSDate *plusHour = [date dateByAddingTimeInterval:tiptime * 60.0f];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: plusHour];
    NSDate* real_date = [NSDate dateWithTimeInterval: seconds sinceDate: plusHour];
    self.mOrderInLabel.text = [NSString stringWithFormat:@"Order In : %@", o.orderTime];
    if(o.pickup != nil && [o.pickup length] > 0){
        self.mTimeLabel.text = o.pickup;
    } else{
        self.mTimeLabel.text = [NSString stringWithFormat:@"Time: %@", [dateFormat stringFromDate:real_date]];
    }
    
    if([o.status_id isEqualToString:STATUS_WAITING]) {
        //waiting status
        [self.mRejectBtn setHidden:NO];
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Waiting";
        [self.mRejectBtn setTitle:@"Reject" forState:UIControlStateNormal];
        //==2017-5-9===
        [self.mRejectBtn setImage:[UIImage imageNamed:@"ic_button_reject.png"] forState:UIControlStateNormal];
                //[self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_process.png"]];
    } else if ([o.status_id isEqualToString:STATUS_ACCEPTED]) {
        //accepted status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Accepted";
        [self.mRejectBtn setHidden:NO];
        [self.mRejectBtn setTitle:@"Ready" forState:UIControlStateNormal];
        //==2017-5-9===
        [self.mRejectBtn setImage:[UIImage imageNamed:@"ic_state_process.png"] forState:UIControlStateNormal];
        //[self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_accept.png"]];
    } else if ([o.status_id isEqualToString:STATUS_REJECTED]) {
        //rejected status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Rejected";
        [self.mRejectBtn setHidden:YES];
        //==2017-5-9===
        //[self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_reject.png"]];
    } else if ([o.status_id isEqualToString:STATUS_CANCELED]) {
        //canceled status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Cancelled";
        [self.mRejectBtn setHidden:YES];
        //==2017-5-9===
        //[self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_cancel.png"]];
    } else if ([o.status_id isEqualToString:STATUS_PREPARED]) {
        //prepared status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Ready";
        [self.mRejectBtn setHidden:YES];
        //[self.mRejectBtn setTitle:@"Delivery" forState:UIControlStateNormal];
        //==2017-9-22===
        //[self.mRejectBtn setImage:[UIImage imageNamed:@"ic_state_process.png"] forState:UIControlStateNormal];
    } else if ([o.status_id isEqualToString:STATUS_DELIVERING]) {
        //Delivery status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Delivering";
        //[self.mRejectBtn setHidden:YES];
        //==2017-9-22===
        [self.mRejectBtn setHidden:YES];
        //[self.mRejectBtn setTitle:@"Complete" forState:UIControlStateNormal];
        //[self.mRejectBtn setImage:[UIImage imageNamed:@"ic_state_complete.png"] forState:UIControlStateNormal];
    } else {
        //completed status
        [self.mStatusLabel setHidden:NO];
        self.mStatusLabel.text = @"Completed";
        [self.mRejectBtn setHidden:YES];
        //==2017-5-9===
        //[self.mStatusImage setImage:[UIImage imageNamed:@"ic_state_complete.png"]];
    }
}

- (IBAction)onRejectClick:(id)sender {
    Order *o = self.data;
    if([o.status_id isEqualToString:@"1"]) {
        //reject action
        pDlg = [[PromptDialog alloc] init];
        [pDlg showWithTitle:@"Reject Reason"
                    Message:@"Please enter reject reason"
                PlaceHolder:@"Please enter reject reason"
                    PreText:@""
                  OkCaption:@"OK"
              CancelCaption:@"Cancel"
                         Ok:^(NSString* cmt){
                             [SVProgressHUD show];
                             [[HttpApi sharedInstance] doReject:(NSString *)o.orderId
                                                         Reason:(NSString *)cmt
                                                      Completed:^(NSDictionary *array){
                                                          [SVProgressHUD dismiss];
                                                          
                                                          NSNotification *msg = [NSNotification notificationWithName:@"ChangeOrderStatus" object:nil userInfo:nil];
                                                          [[NSNotificationCenter defaultCenter] postNotification:msg];
                                                          
                                                          
                                                      }Failed:^(NSString *strError) {
                                                          [SVProgressHUD showErrorWithStatus:strError];
                                                      }];
                         }
                     Cancel:^(){}];
        
    } else if([o.status_id isEqualToString:STATUS_ACCEPTED]){//Accepted=>Ready
        //Ready action
        [SVProgressHUD show];
        [[HttpApi sharedInstance] doReady:(NSString *)o.orderId
                                   Completed:^(NSDictionary *array){
                                       [SVProgressHUD dismiss];
                                       
                                       NSNotification *msg = [NSNotification notificationWithName:@"ChangeOrderStatus" object:nil userInfo:nil];
                                       [[NSNotificationCenter defaultCenter] postNotification:msg];
                                       
                                       
                                   }Failed:^(NSString *strError) {
                                       [SVProgressHUD showErrorWithStatus:strError];
                                   }];
        
    } else if([o.status_id isEqualToString:STATUS_PREPARED]){//Ready=>Delivery
        //Delivery action
        [SVProgressHUD show];
        [[HttpApi sharedInstance] doDelivery:(NSString *)o.orderId
                                Completed:^(NSDictionary *array){
                                    [SVProgressHUD dismiss];
                                    
                                    NSNotification *msg = [NSNotification notificationWithName:@"ChangeOrderStatus" object:nil userInfo:nil];
                                    [[NSNotificationCenter defaultCenter] postNotification:msg];
                                    
                                    
                                }Failed:^(NSString *strError) {
                                    [SVProgressHUD showErrorWithStatus:strError];
                                }];
    } else if([o.status_id isEqualToString:STATUS_DELIVERING]){//Delivery=>complete
        //complete action
        [SVProgressHUD show];
        [[HttpApi sharedInstance] doComplete:(NSString *)o.orderId
                                   Completed:^(NSDictionary *array){
                                       [SVProgressHUD dismiss];
                                       
                                       NSNotification *msg = [NSNotification notificationWithName:@"ChangeOrderStatus" object:nil userInfo:nil];
                                       [[NSNotificationCenter defaultCenter] postNotification:msg];
                                       
                                       
                                   }Failed:^(NSString *strError) {
                                       [SVProgressHUD showErrorWithStatus:strError];
                                   }];
    }

}

- (IBAction)omDriverCall:(id)sender {
    NSString *phoneNumber = [self.mDriverPhoneLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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

- (IBAction)onPickupClick:(id)sender {
    if([self.data.status_id isEqualToString:STATUS_WAITING]||[self.data.status_id isEqualToString:STATUS_ACCEPTED]||[self.data.status_id isEqualToString:STATUS_PREPARED]){
        NSDictionary *info = @{ @"data":self.data};
        NSNotification *msg = [NSNotification notificationWithName:NOTIFICATION_PICKUP_TIME object:nil userInfo:info];
        [[NSNotificationCenter defaultCenter] postNotification:msg];
    }
}

@end
