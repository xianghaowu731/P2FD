//
//  OrderDetailRVC.m
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "OrderDetailRVC.h"
#import "RFoodTVCell.h"
#import "OrderDetailUserInfoRTVC.h"
#import "Config.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "PromptDialog.h"
#import "PickupViewController.h"
#import "TableFood.h"
#import "ExtraFood.h"
#import "ExtraMenu.h"
#import "OrderedFood.h"
#import "FMDBHelper.h"
#import "Restaurant.h"
#import "AppDelegate.h"

extern FMDBHelper* helper;
extern Restaurant* owner;

@implementation OrderDetailRVC{
    PromptDialog* pDlg;
    NSMutableArray* tablearray;
    float subprice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Order Detail";
    helper = [FMDBHelper sharedInstance];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLayout{
    self.fooddata = self.data.orderedfoods;
    self.mFirstNameLabel.text = self.data.tofirst;
    self.mLastNameLabel.text = self.data.tolast;
    self.mInstructionLabel.text = self.data.comment;
    self.mOrderTime.text = [NSString stringWithFormat:@"Order In : %@", self.data.orderTime];
    self.mStatusLabel.text = self.data.status;
    if([self.data.status_id isEqualToString:STATUS_COMPLETED]){
        self.mMistakeBtn.hidden = NO;
    } else{
        self.mMistakeBtn.hidden = YES;
    }
    self.mUserPhone.text = [NSString stringWithFormat:@"Phone : %@", self.data.tophone];
    self.mUserAddress.text = [NSString stringWithFormat:@"Address : %@", self.data.address];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSDate *date = [dateFormat dateFromString:self.data.orderTime];
    NSInteger tiptime = 20;
    NSDate *plusHour = [date dateByAddingTimeInterval:tiptime * 60.0f];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: plusHour];
    NSDate* real_date = [NSDate dateWithTimeInterval: seconds sinceDate: plusHour];
    if(self.data.pickup != nil && [self.data.pickup length] > 0){
        self.mPickTimeLabel.text = self.data.pickup;
    } else{
        self.mPickTimeLabel.text = [NSString stringWithFormat:@" %@", [dateFormat stringFromDate:real_date]];
    }
    tablearray = [[NSMutableArray alloc] init];
    subprice = 0.0;
    for(int i=0;i<self.data.orderedfoods.count;i++){
        OrderedFood *order_food = self.data.orderedfoods[i];
        TableFood *one = [[TableFood alloc] init];
        one.mId = order_food.foodId;
        one.foodname = order_food.name;
        one.price = order_food.price;
        one.count = order_food.count;
        one.instruction = order_food.desc;
        one.type = 1;//main food
        [tablearray addObject:one];
        subprice += one.price.floatValue * [one.count intValue];
        for(int j = 0; j < order_food.extrafoods.count; j++){
            ExtraMenu* one_menu = order_food.extrafoods[j];
            for(int k = 0 ; k < one_menu.extrafoods.count; k++){
                ExtraFood* one_food = one_menu.extrafoods[k];
                TableFood *other = [[TableFood alloc] init];
                other.mId = one_food.eid;
                other.foodname = one_food.foodname;
                other.price = one_food.price;
                other.count = one_food.count;
                other.type = 2;//extra food
                [tablearray addObject:other];
                subprice += other.price.floatValue * [other.count intValue];
            }
        }
    }
    [self.mTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tablearray count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 64;
    if([tablearray count] == indexPath.row){
        h = 74;
        return h;
    }
    TableFood* item = tablearray[indexPath.row];
    if(item.type == 2){
        h = 24;
    }
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    if (indexPath.row == tablearray.count) {
        cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_RTotalCell" forIndexPath:indexPath];
        float totalprice=0.0;
        totalprice = subprice + (DELIVERY_TAX * subprice);
        UILabel *subLabel = [cell viewWithTag:13];
        NSString* tprice = [NSString stringWithFormat:@"%.2f", subprice];
        subLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
        UILabel *taxLabel = [cell viewWithTag:12];
        tprice = [NSString stringWithFormat:@"%.2f", (DELIVERY_TAX * subprice)];
        taxLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
        UILabel *totalLabel = [cell viewWithTag:11];
        tprice = [NSString stringWithFormat:@"%.2f", totalprice];
        totalLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
        
    } else {
        TableFood* item = tablearray[indexPath.row];
        if(item.type == 1){
            cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_RFoodLineCell" forIndexPath:indexPath];
            UILabel *foodName = [cell viewWithTag:1];
            NSString* fname = item.foodname;
            NSString* count = item.count;
            foodName.text = [NSString stringWithFormat:@"%@ (x%@)", fname, count];
            UILabel *eachLabel = [cell viewWithTag:2];
            NSString *eachprice = [NSString stringWithFormat:@"$%.2f", [item.price floatValue]];
            eachLabel.text = eachprice;
            UILabel* priceLabel = [cell viewWithTag:3];
            float price = [item.price floatValue] * [count integerValue];
            priceLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", price];
            
            UILabel* instLabel = [cell viewWithTag:5];
            instLabel.text = [NSString stringWithFormat:@"%@", item.instruction];
        } else{
            cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_ExtOrderCell" forIndexPath:indexPath];
            UILabel *foodName = [cell viewWithTag:6];
            NSString* fname = item.foodname;
            NSString* count = item.count;
            foodName.text = [NSString stringWithFormat:@"%@ (x%@)", fname, count];
            UILabel* priceLabel = [cell viewWithTag:7];
            float price = [item.price floatValue] * [count integerValue];
            if(price == 0){
                priceLabel.text = @"";
            } else{
                priceLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", price];
            }
        }
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     MNCDialogViewController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_MNCDialogVC"];
     mVC.chatMateId = chatMatesArray[indexPath.row][@"username"];
     mVC.myUserId = self.myUserId;
     // [self.navigationController pushViewController:mVC animated:YES];
     //[self.navigationController showViewController:mVC sender:self];*/
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPickupTimeClick:(id)sender {
    if([self.data.status_id isEqualToString:STATUS_WAITING]||[self.data.status_id isEqualToString:STATUS_ACCEPTED]||[self.data.status_id isEqualToString:STATUS_PREPARED]){
        PickupViewController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PickupViewController"];
        mVC.data = self.data;
        [self.navigationController pushViewController:mVC animated:YES];
    }
}

- (IBAction)onMistakeClick:(id)sender {
    pDlg = [[PromptDialog alloc] init];
    [pDlg showWithTitle:@"Reject Reason"
                Message:@"Please enter reject reason"
            PlaceHolder:@"Reject reason"
                PreText:@""
              OkCaption:@"NEXT"
          CancelCaption:@"Cancel"
                     Ok:^(NSString* cmt){
                         [SVProgressHUD show];
                         [[HttpApi sharedInstance] doMistake:(NSString *)self.data.orderId
                                                     Reason:(NSString *)cmt
                                                  Completed:^(NSString *array){
                                                      [SVProgressHUD dismiss];
                                                      
                                                      NSNotification *msg = [NSNotification notificationWithName:@"ChangeOrderStatus" object:nil userInfo:nil];
                                                      [[NSNotificationCenter defaultCenter] postNotification:msg];
                                                      
                                                      NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                                                      f.numberStyle = NSNumberFormatterDecimalStyle;
                                                      [helper deleteOrderByRestId:owner.restaurantId];
                                                      for(int i=0;i<self.data.orderedfoods.count;i++){
                                                          OrderedFood *order_food = self.data.orderedfoods[i];
                                                          Food* one = [[Food alloc] init];
                                                          one.foodId = order_food.foodId;
                                                          one.name = order_food.name;
                                                          one.price = [f numberFromString:order_food.price];
                                                          one.restId = owner.restaurantId;
                                                          one.restName = owner.name;
                                                          one.instruction = order_food.desc;
                                                          one.extrafoods = order_food.extrafoods;
                                                          [helper updateFood:one Quantity:[order_food.count integerValue]];
                                                      }
                                                      g_toFirst = self.data.tofirst;
                                                      g_toLast = self.data.tolast;
                                                      g_toPhone = self.data.tophone;
                                                      g_address = self.data.address;
                                                      NSArray *foo1 = [self.data.location componentsSeparatedByString: @","];
                                                      g_latitude = foo1[0];
                                                      g_longitude = foo1[1];
                                                      g_isMistakeOrder = true;
                                                      g_isRestOrder = true;
                                                      g_subprice = 0.0;
                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                      [self.tabBarController setSelectedIndex:3];
                                                  }Failed:^(NSString *strError) {
                                                      [SVProgressHUD showErrorWithStatus:strError];
                                                  }];
                     }
                 Cancel:^(){}];
}
@end
