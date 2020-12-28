//
//  OrderDetailCVC.m
//  Food
//
//  Created by weiquan zhang on 6/20/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "OrderDetailCVC.h"
#import "OrderInfoCTVC.h"
#import "OrderFoodCTVC.h"
#import "FoodDetailCVC.h"
#import "Config.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "ExtraMenu.h"
#import "ExtraFood.h"
#import "TableFood.h"
#import "OrderedFood.h"


@interface OrderDetailCVC (){
    NSMutableArray *tablearray;
    float totalprice, subprice;
}

@end

@implementation OrderDetailCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
    //[self.mTableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeOrderStatus:) name:@"CompleteOrder" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    Order* o = self.data;
    if([o.status_id isEqualToString:@"1"]){
        // created state
        [self.mButton setEnabled:NO];
        [self.mButton setBackgroundColor:CONTROLL_EDGE_COLOR];
    } else if ([o.status_id isEqualToString:@"2"]) {
        // accepted status
        int isPassedFive = 0;
        if(isPassedFive){
            [self.mButton setEnabled:NO];
            [self.mButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [self.mButton setBackgroundColor:CONTROLL_EDGE_COLOR];
        } else {
            [self.mButton setEnabled:YES];
            [self.mButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [self.mButton setBackgroundColor:PRIMARY_COLOR];
        }
    } else {
        // 3,4,5 - rejected, cancelled, completed status
        [self.mButton setEnabled:YES];
        [self.mButton setTitle:@"Delete" forState:UIControlStateNormal];
        [self.mButton setBackgroundColor:PRIMARY_COLOR];
    }
    [self getData];
}

- (void)completeOrderStatus:(NSNotification*)msg{
    //complete action
    [SVProgressHUD show];
    [[HttpApi sharedInstance] doComplete:(NSString *)self.data.orderId
                               Completed:^(NSDictionary *array){
                                   [SVProgressHUD dismiss];
                                   UIAlertController * alert=   [UIAlertController
                                                                 alertControllerWithTitle:@"Success!"
                                                                 message:@"Order was completed successfully."
                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                   
                                   UIAlertAction* yesButton = [UIAlertAction
                                                               actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                                               {
                                                                   [self getData];
                                                               }];
                                   [alert addAction:yesButton];
                                   [self presentViewController:alert animated:YES completion:nil];
                                   
                               }Failed:^(NSString *strError) {
                                   [SVProgressHUD showErrorWithStatus:strError];
                               }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getData{
    tablearray = [[NSMutableArray alloc] init];
    totalprice = 0.0;
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
    return [tablearray count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 260;
    if(indexPath.row == 0)
        h = 260;
    else{
        TableFood* one = tablearray[indexPath.row - 1];
        if(one.type == 1){
            h = 60;
        }else{
            h = 24;
        }
    }
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    if(indexPath.row == 0) {
        OrderInfoCTVC *c = [tableView dequeueReusableCellWithIdentifier:@"RID_OrderInfoCTVC" forIndexPath:indexPath];
        [c setLayout:self.data];
        cell = c;
    } else if (indexPath.row == tablearray.count + 1) {
        UITableViewCell * c = [tableView dequeueReusableCellWithIdentifier:@"RID_ButtonCell" forIndexPath:indexPath];
        cell = c;
    } else {
        TableFood* item = tablearray[indexPath.row - 1];
        if(item.type == 1){
            cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_OrderLineCell" forIndexPath:indexPath];
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
            UILabel* instLabel = [cell viewWithTag:4];
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
    //if(indexPath.row == 0) return;
    //FoodDetailCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_FoodDetailCVC"];
    //NSMutableArray* foods = self.data.orderedfoods;
    //mVC.data = foods[indexPath.row - 1];
    //[self.navigationController pushViewController:mVC animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnClick:(id)sender {
    Order* o = self.data;
    if([o.status_id isEqualToString:@"1"]){
        // created state - no action
    } else if ([o.status_id isEqualToString:@"2"]) {
        // accepted status
        int isPassedFive = 0;
        if(isPassedFive){
            // can not cancel case - no action
        } else {
            // can cancel case - cancel button - cancel action
            Order *o = self.data;
            [SVProgressHUD show];
            [[HttpApi sharedInstance] doCancel:(NSString *)o.orderId
                                     Completed:^(NSDictionary *array){
                                         [SVProgressHUD dismiss];
                                         
                                         UIAlertController * alert=   [UIAlertController
                                                                       alertControllerWithTitle:@"Success!"
                                                                       message:@"Order was cancelled successfully."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                         
                                         UIAlertAction* yesButton = [UIAlertAction
                                                                     actionWithTitle:@"Ok"
                                                                     style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action)
                                                                     {
                                                                         [self.navigationController popViewControllerAnimated:YES];
                                                                     }];
                                         [alert addAction:yesButton];
                                         [self presentViewController:alert animated:YES completion:nil];
                                         
                                         //[self.navigationController popViewControllerAnimated:YES];
                                     }Failed:^(NSString *strError) {
                                         [SVProgressHUD showErrorWithStatus:strError];
                                     }];
        }
    } else {
        // 3,4,5 - rejected, cancelled, completed status - delete button
        Order *o = self.data;
        [SVProgressHUD show];
        [[HttpApi sharedInstance] doDelete:(NSString *)o.orderId
                                 Completed:^(NSDictionary *array){
                                     [SVProgressHUD dismiss];
                                     
                                     UIAlertController * alert=   [UIAlertController
                                                                   alertControllerWithTitle:@"Success!"
                                                                   message:@"Order was deleted successfully."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                     
                                     UIAlertAction* yesButton = [UIAlertAction
                                                                 actionWithTitle:@"Ok"
                                                                 style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action)
                                                                 {
                                                                     [self.navigationController popViewControllerAnimated:YES];
                                                                 }];
                                     [alert addAction:yesButton];
                                     [self presentViewController:alert animated:YES completion:nil];
                                     
                                 }Failed:^(NSString *strError) {
                                     [SVProgressHUD showErrorWithStatus:strError];
                                 }];
    }
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
