//
//  CartDetailVC.m
//  Food
//
//  Created by weiquan zhang on 6/27/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "CartDetailVC.h"
#import "Food.h"
#import "FMDBHelper.h"
#import "Config.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Customer.h"
#import "PromptDialog.h"
#import "CartCheckView.h"
#import <UIImageView+WebCache.h>
#import "ExtraFood.h"
#import "ExtraMenu.h"
#import "TableFood.h"
#import "AppDelegate.h"

extern FMDBHelper* helper;
extern Customer* customer;

@interface CartDetailVC ()

@end

@implementation CartDetailVC{
    NSString* comment;
    PromptDialog* pDlg;
    NSMutableArray* tablearray;
    float totalprice, subprice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mImageView.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    self.mNameLabel.text = self.mRest.name;
    self.mAddressLabel.text = self.mRest.address;
    NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, RESTAURANT_IMAGE_BASE_URL, self.mRest.img];
    [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    helper = [FMDBHelper sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadData];
}

- (void)reloadData{
    self.data = [helper getOrdersByRestID:self.restId];
    tablearray = [[NSMutableArray alloc] init];
    totalprice = 0.0;
    subprice = 0.0;
    for(int i=0;i<self.data.count;i++){
        Food *cart_food = (Food*)(self.data[i]);
        TableFood *one = [[TableFood alloc] init];
        one.mId = cart_food.fId;
        one.foodname = cart_food.name;
        one.price = [cart_food.price stringValue];
        one.count = [cart_food.count stringValue];
        one.instruction = cart_food.instruction;
        one.type = 1;//main food
        [tablearray addObject:one];
        subprice += cart_food.price.floatValue * [cart_food.count intValue];
        for(int j = 0; j < cart_food.extrafoods.count; j++){
            ExtraMenu* one_menu = cart_food.extrafoods[j];
            for(int k = 0 ; k < one_menu.extrafoods.count; k++){
                ExtraFood* one_food = one_menu.extrafoods[k];
                TableFood *other = [[TableFood alloc] init];
                other.mId = one_food.mId;
                other.foodname = one_food.foodname;
                other.price = one_food.price;
                other.count = one_food.count;
                other.type = 2;//extra food
                [tablearray addObject:other];
                subprice += other.price.floatValue * [other.count intValue];
            }
        }
    }
    if(g_isRestOrder && g_isMistakeOrder){
        subprice = g_subprice;
    }
    [self.mTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tablearray count] + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 60;
    if(indexPath.row == tablearray.count){
        h = 70;
    } else if(indexPath.row == tablearray.count + 1){
        h = 64;
    } else{
        TableFood* item = tablearray[indexPath.row];
        if(item.type == 2){ // extra food
            h = 40;
        } else{
            h = 60;
        }
    }
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    /*if(indexPath.row == 0){
        cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_HeaderCell" forIndexPath:indexPath];
        UILabel *restName = [cell viewWithTag:1];
        restName.text = ((Food*)(self.data[0])).restName;
        UILabel *date = [cell viewWithTag:2];
        date.text = @"";//datetime;
    } else */
    if (indexPath.row == tablearray.count) {
        cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_TotalCell" forIndexPath:indexPath];
        totalprice = subprice + DELIVERY_TAX * subprice;
        UILabel *subLabel = [cell viewWithTag:9];
        NSString* tprice = [NSString stringWithFormat:@"%.2f", subprice];
        subLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
        UILabel *taxLabel = [cell viewWithTag:10];
        tprice = [NSString stringWithFormat:@"%.2f", (DELIVERY_TAX * subprice)];
        taxLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
        UILabel *totalLabel = [cell viewWithTag:11];
        tprice = [NSString stringWithFormat:@"%.2f", totalprice];
        totalLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
        UIButton *inputBtn = [cell viewWithTag:20];
        inputBtn.tag = indexPath.row;
        [inputBtn addTarget:self action:@selector(onInputPriceClick:) forControlEvents:UIControlEventTouchUpInside];
    } else if (indexPath.row == tablearray.count+1) {
        cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_OrderCell" forIndexPath:indexPath];
    } else {
        TableFood* item = tablearray[indexPath.row];
        if(item.type == 1){
            cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_FoodLineCell" forIndexPath:indexPath];
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
            
            UIButton *delBtn = [cell viewWithTag:4];
            delBtn.tag = indexPath.row;
            [delBtn addTarget:self action:@selector(onMinuteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        } else{
            cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_ExtFoodCell" forIndexPath:indexPath];
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
            UIButton *delBtn = [cell viewWithTag:8];
            delBtn.tag = indexPath.row;
            [delBtn addTarget:self action:@selector(onExtMinuteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if(g_isRestOrder && g_isMistakeOrder){
                delBtn.hidden = NO; //modify
            } else{
                delBtn.hidden = YES; //modify
            }            
        }
    }
    return cell;
}

- (void)onInputPriceClick:(UIButton *)sender {
    [pDlg showWithTitle:@"Foods Price"
                Message:@"Please enter new price"
            PlaceHolder:@"0.99"
                PreText:@""
              OkCaption:@"Ok"
          CancelCaption:@"Cancel"
                     Ok:^(NSString* cmt){
                         g_subprice = [cmt floatValue];
                         [self reloadData];
                     }
                 Cancel:^(){}];
}

- (void)onMinuteBtnClick:(UIButton *)sender {
    long index = sender.tag;
    TableFood* sel_food = tablearray[index];
    Food* one_sel = [[Food alloc] init];
    for(int i=0;i<self.data.count;i++){
        Food* one = self.data[i];
        if([one.fId isEqualToString:sel_food.mId]){
            one_sel = one;
            //NSInteger count = [one_sel.count integerValue];
            [helper deleteFood:one_sel];
            //[helper updateFood:one_sel Quantity:-1];
            [self reloadData];
            return;
        }
    }
}

- (void)onExtMinuteBtnClick:(UIButton *)sender {
    long index = sender.tag;
    TableFood* sel_food = tablearray[index];
    ExtraFood* one_sel = [[ExtraFood alloc] init];
    for(int i=0;i<self.data.count;i++){
        Food* one = self.data[i];
        for(int j = 0; j < one.extrafoods.count; j++){
            ExtraMenu* one_menu = one.extrafoods[j];
            for(int k = 0 ; k < one_menu.extrafoods.count; k++){
                ExtraFood* one_food = one_menu.extrafoods[k];
                if([one_food.mId isEqualToString:sel_food.mId]){
                    one_sel = one_food;
                    [helper deleteExtFood:one_sel];
                    [self reloadData];
                    return;
                }
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onCommentIconClick:(id)sender {
   
    pDlg = [[PromptDialog alloc] init];
    [pDlg showWithTitle:@"Comment"
                Message:@"Please enter your comment"
            PlaceHolder:@"Please enter your comment"
                PreText:comment
              OkCaption:@"OK"
          CancelCaption:@"Cancel"
                     Ok:^(NSString* cmt){
                         comment = cmt;
                     }
                 Cancel:^(){}];
}

- (IBAction)onOrderClick:(id)sender {
    if([self.data count] > 0 ){
        CartCheckView *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartCheckVC"];
        vc.mRest = self.mRest;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDeleteClick:(id)sender {
    [helper deleteOrderByRestId:self.mRest.restaurantId];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"", nil] forKeys:[NSArray arrayWithObjects:@"cellTag", nil]];
    
    NSNotification *msg = [NSNotification notificationWithName:@"DeleteOrderByRestId" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:msg];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
