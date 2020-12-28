//
//  CartCheckView.m
//  Food
//
//  Created by meixiang wu on 7/14/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "CartCheckView.h"
#import "Food.h"
#import "FMDBHelper.h"
#import "Config.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Customer.h"
#import "Login.h"
#import "CartDateView.h"
#import "AppDelegate.h"
#import "PromptDialog.h"
#import "CartReviewView.h"
#import "CLPlacemark+HNKAdditions.h"
#import "ExtraMenu.h"
#import "ExtraFood.h"
#import "TableFood.h"

extern FMDBHelper* helper;
extern Customer* customer;
static NSString *const kHNKDemoSearchResultsCellIdentifier = @"AddressSearchResultsCellIdentifier";

@interface CartCheckView ()<UISearchBarDelegate>{
    NSString *fromtime,*totimeStr;
    NSInteger mTipBtnSel;
    PromptDialog* pDlg;
    float mTipPrice;
    NSMutableArray *tablearray;
    float totalprice, subprice;
}

@end

@implementation CartCheckView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    g_appDelegate.mViewState = 8;
    
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    
    //self.mSearchView.hidden = YES;
    self.searchBar.hidden = YES;
    self.mHideBtn.hidden = YES;
    
    CALayer *imageLayer = self.mAddBtn.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor orangeColor].CGColor];
    
    imageLayer = self.mTipCustomBtn.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:TIPBTN_SEL_BG_COLOR.CGColor];
    
    imageLayer = self.mTipBtnView.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:TIPBTN_SEL_BG_COLOR.CGColor];
    
    imageLayer = self.tableView.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor grayColor].CGColor];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.mTipFirstBtn.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft) cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.mTipFirstBtn.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.mTipFirstBtn.layer.mask = maskLayer;
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.mTipForthBtn.bounds byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    maskLayer.frame = self.mTipForthBtn.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.mTipForthBtn.layer.mask = maskLayer;
    
    self.mNameLabel.text = self.mRest.name;
    g_isChangeDateTime = false;
    g_tipPercent = 14;
    mTipBtnSel = 1;
    mTipPrice = 0;
    //================================================
    
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    
    NSInteger deliverytime = 45;//(long)(((self.mRest.mDistance/1000)/KM_PER_MILE)/DELIVERY_MILE_PER_MIN);
    NSDate *plusHour = [[NSDate date] dateByAddingTimeInterval:deliverytime * 60.0f];
    fromtime = [outputFormatter stringFromDate:plusHour];
    deliverytime = 60;
    plusHour = [[NSDate date] dateByAddingTimeInterval:deliverytime * 60.0f];
    totimeStr = [outputFormatter stringFromDate:plusHour];
    
    [outputFormatter setDateFormat:@"MM-dd-yyyy"]; //Here we can set the format which we need
    NSString *convertedDateString = [outputFormatter stringFromDate:[NSDate date]];
    g_deliveryTime = [NSString stringWithFormat:@"%@ , %@ ~ %@", convertedDateString, fromtime, totimeStr];
    self.mTimeLabel.text = [NSString stringWithFormat:@"Delivery,ASAP(%@ ~ %@)", fromtime, totimeStr];
    
    helper = [FMDBHelper sharedInstance];
    [self dispTipButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.mDeliveryLabel.text = g_address;
    if(g_appDelegate.mViewState == 0)
    {
        CartReviewView *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartReviewView"];
        vc.mRest = self.mRest;
        vc.mtipFee = mTipPrice;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self reloadData];
    }
}

- (void)reloadData{
    self.searchBar.hidden = YES;
    self.mHideBtn.hidden = YES;
    self.data = [helper getOrdersByRestID:self.mRest.restaurantId];
    
    tablearray = [[NSMutableArray alloc] init];
    totalprice = 0.0;
    subprice=0.0;
    for(int i=0;i<self.data.count;i++){
        Food *cart_food = (Food*)(self.data[i]);
        TableFood *one = [[TableFood alloc] init];
        one.mId = cart_food.foodId;
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
    
    if([self.mRest.location length] == 0 && ((self.mRest.mDistance / 1000) > 100 || self.mRest.mDistance == -1)){
        CLLocationCoordinate2D otherloc = [self getLocationFromAddressString:self.mRest.address];
        self.mRest.location = [NSString stringWithFormat:@"%f,%f", otherloc.latitude, otherloc.longitude];
        NSArray *foo1 = [self.mRest.location componentsSeparatedByString: @","];
        CLLocationDegrees otherlat = [foo1[0] floatValue];
        CLLocationDegrees otherlon = [foo1[1] floatValue];
        CLLocationDegrees onelat = [g_latitude floatValue];
        CLLocationDegrees onelon = [g_longitude floatValue];
        CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:onelat longitude:onelon];
        CLLocation *oneLocation = [[CLLocation alloc] initWithLatitude:otherlat longitude:otherlon];
        CLLocationDistance distance = [myLocation distanceFromLocation:oneLocation] * 1.323;
        self.mRest.mDistance = fabs(distance);
        [[HttpApi sharedInstance] getLocationByRestId:self.mRest.restaurantId Location:self.mRest.location
                                            Completed:^(NSString *array){
                                            }Failed:^(NSString *strError) {
                                            }];
    }
    float fee_distance = self.mRest.mDistance / 1000;
    float m_fee = DELIVERY_FEE_PER_DEFAULT;
    if(fee_distance >= 0.0 && [self.mRest.address length] > 0){//fee_distance < 50 &&
        if(fee_distance < KM_PER_MILE * DELIVERY_DEFAULT_DISTANCE){
            m_fee = DELIVERY_FEE_PER_DEFAULT; //5.0$
        } else{
            m_fee = DELIVERY_FEE_PER_DEFAULT + (fee_distance/KM_PER_MILE - DELIVERY_DEFAULT_DISTANCE)*DELIVERY_ADD_FEE;//over 10mile add 0.5$
        }
    }
    if(g_isRestOrder){
        self.mDeliveryLabel.text = g_address;
        if(g_isMistakeOrder){
            subprice = g_subprice;
            m_fee = 0;
        }
    }
    self.mDeliveryFee = m_fee;
    
    if(g_isChangeDateTime){
        self.mTimeLabel.text = [NSString stringWithFormat:@"Delivery:%@", g_deliveryTime];
    }
    else{
        self.mTimeLabel.text = [NSString stringWithFormat:@"Delivery,ASAP(%@ ~ %@)", fromtime, totimeStr];
    }
    self.mTipPercentLabel.text = [NSString stringWithFormat:@"%ld%%",(long)g_tipPercent];
    self.mTipPriceLabel.text = [NSString stringWithFormat:@"$%.2f",(float)(subprice*g_tipPercent/100)];
    mTipPrice = (float)(subprice*g_tipPercent/100);
    totalprice = subprice + DELIVERY_TAX * subprice + m_fee + mTipPrice;
    NSString *title = [NSString stringWithFormat:@"Continue to Checkout: $%.2f", totalprice];
    [self.mContinueBtn setTitle:title forState:UIControlStateNormal];
    [self.mTableView reloadData];
}

- (void)dispTipButtons{
    switch (mTipBtnSel) {
        case 1:
            g_tipPercent = 14;
            self.mTipFirstBtn.backgroundColor = TIPBTN_SEL_BG_COLOR;
            [self.mTipFirstBtn setTitleColor:TIPBTN_SEL_TEXT_COLOR forState:UIControlStateNormal];
            self.mTipSecondBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipSecondBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipThirdBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipThirdBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipForthBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipForthBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            break;
        case 2:
            g_tipPercent = 15;
            self.mTipFirstBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipFirstBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipSecondBtn.backgroundColor = TIPBTN_SEL_BG_COLOR;
            [self.mTipSecondBtn setTitleColor:TIPBTN_SEL_TEXT_COLOR forState:UIControlStateNormal];
            self.mTipThirdBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipThirdBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipForthBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipForthBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            break;
        case 3:
            g_tipPercent = 20;
            self.mTipFirstBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipFirstBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipSecondBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipSecondBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipThirdBtn.backgroundColor = TIPBTN_SEL_BG_COLOR;
            [self.mTipThirdBtn setTitleColor:TIPBTN_SEL_TEXT_COLOR forState:UIControlStateNormal];
            self.mTipForthBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipForthBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            break;
        case 4:
            g_tipPercent = 25;
            self.mTipFirstBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipFirstBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipSecondBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipSecondBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipThirdBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipThirdBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipForthBtn.backgroundColor = TIPBTN_SEL_BG_COLOR;
            [self.mTipForthBtn setTitleColor:TIPBTN_SEL_TEXT_COLOR forState:UIControlStateNormal];
            break;
        default:
            self.mTipFirstBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipFirstBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipSecondBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipSecondBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipThirdBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipThirdBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            self.mTipForthBtn.backgroundColor = TIPBTN_SEL_TEXT_COLOR;
            [self.mTipForthBtn setTitleColor:TIPBTN_SEL_BG_COLOR forState:UIControlStateNormal];
            break;
    }
    [self reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDateChangeClick:(id)sender {
    CartDateView *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartDateView"];
    vc.mRestName = self.mRest.name;
    vc.mDeliveryDist = self.mRest.mDistance;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onAddItemsClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onContinueClick:(id)sender {
    if(![self checkRestOpenStatus]){
        NSString *msg = [NSString stringWithFormat:@"Delivery cannot be placed at this time. Please changes delivery time to reflect working hours.\n Working Time:%@", self.mRest.worktime];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Delivery Time Unavailable!"
                                      message:msg
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if([customer.customerId isEqualToString:@"0"]){
        Login *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_Login"];
        g_appDelegate.mViewState = 8;//@"cart";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CartReviewView *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartReviewView"];
        vc.mRest = self.mRest;
        vc.mtipFee = mTipPrice;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)checkRestOpenStatus{
    NSArray *del_foo = [g_deliveryTime componentsSeparatedByString:@","];
    NSArray *del_time = [del_foo[1] componentsSeparatedByString:@" ~ "];
    NSString *delivery_time = [NSString stringWithFormat:@"%@%@",del_foo[0], del_time[0]];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *worktime = self.mRest.worktime;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSArray *foo = [worktime componentsSeparatedByString:@","];
    for(int i = 0; i < foo.count; i++){
        NSArray *dt_foo = [foo[i] componentsSeparatedByString:@"-"];
        if(dt_foo.count != 2) return false;
        NSString *start_time = [NSString stringWithFormat:@"%@ %@",del_foo[0], dt_foo[0]];
        NSString *end_time = [NSString stringWithFormat:@"%@ %@",del_foo[0], dt_foo[1]];
        NSDate *start_DT = [inputFormatter dateFromString:start_time];
        NSDate *end_DT = [inputFormatter dateFromString:end_time];
        NSDate *today_DT = [inputFormatter dateFromString:delivery_time];
        if ([today_DT compare:start_DT] == NSOrderedDescending && [today_DT compare:end_DT] == NSOrderedAscending) {
            //"date1 is later than date2    &&   //date1 is earlier than date2
            return true;
        }
    }
    return false;
}

- (IBAction)onTipCustomClick:(id)sender {
    pDlg = [[PromptDialog alloc] init];
    [pDlg showWithTitle:@"Tip"
                Message:@"Please enter tip amount(%):1~50"
            PlaceHolder:@"Please enter tip percent(ex:17)"
                PreText:@"17"
              OkCaption:@"OK"
          CancelCaption:@"Cancel"
                     Ok:^(NSString* cmt){
                         g_tipPercent = [cmt integerValue];
                         mTipBtnSel = 0;
                         [self dispTipButtons];
                     }
                 Cancel:^(){}];
}

- (IBAction)onTipFirstClick:(id)sender {
    mTipBtnSel = 1;
    [self dispTipButtons];
}

- (IBAction)onTipSecondClick:(id)sender {
    mTipBtnSel = 2;
    [self dispTipButtons];
}

- (IBAction)onTipThirdClick:(id)sender {
    mTipBtnSel = 3;
    [self dispTipButtons];
}

- (IBAction)onTipForthClick:(id)sender {
    mTipBtnSel = 4;
    [self dispTipButtons];
}

- (IBAction)onEditAddressClick:(id)sender {
    //self.mSearchView.hidden = NO;
    self.searchBar.hidden = NO;
    self.mHideBtn.hidden = NO;
}

- (IBAction)onHideClick:(id)sender {
    self.searchBar.hidden = YES;
    self.mHideBtn.hidden = YES;
    self.tableView.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(tableView == self.mTableView){
        return [tablearray count] + 1;
    } else if(tableView == self.tableView){
        return self.searchResults.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mTableView){
        int h = 32;
        if(indexPath.row == tablearray.count) h = 96;
        return h;
    } else if(tableView == self.tableView){
        return 44;
    }
    return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.mTableView){
        UITableViewCell* cell;
        if (indexPath.row == tablearray.count) {
            cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_TotalCell" forIndexPath:indexPath];
            //totalprice = subprice + DELIVERY_TAX * subprice;
            UILabel *subLabel = [cell viewWithTag:3];
            NSString* tprice = [NSString stringWithFormat:@"%.2f", subprice];
            subLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
            
            UILabel *feeLabel = [cell viewWithTag:4];
            tprice = [NSString stringWithFormat:@"%.2f", self.mDeliveryFee];
            feeLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
            
            UILabel *taxLabel = [cell viewWithTag:5];
            tprice = [NSString stringWithFormat:@"%.2f", DELIVERY_TAX * subprice];
            taxLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
            
        } else {
            cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_FoodLineCell" forIndexPath:indexPath];
            TableFood* item = tablearray[indexPath.row];
            UILabel *foodName = [cell viewWithTag:1];
            UILabel* priceLabel = [cell viewWithTag:2];
            NSString* fname = item.foodname;
            NSString* count = item.count;
            float price = [item.price floatValue] * [count integerValue];
            if(item.type == 1){
                foodName.text = [NSString stringWithFormat:@"%@ (x%@)", fname, count];
                priceLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", price];
            } else{
                [foodName setFont:[UIFont systemFontOfSize:12]];
                if(price == 0){
                    foodName.text = [NSString stringWithFormat:@"\t%@ (x%@)", fname, count];
                } else{
                    foodName.text = [NSString stringWithFormat:@"\t%@ (x%@)\t\t$%.2f", fname, count, price];
                }
                
                priceLabel.text = @"";
            }
        }
        return cell;
    } else if(tableView == self.tableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHNKDemoSearchResultsCellIdentifier forIndexPath:indexPath];
        
        HNKGooglePlacesAutocompletePlace *thisPlace = self.searchResults[indexPath.row];
        cell.textLabel.text = thisPlace.name;
        return cell;
    }
    return nil;
}
#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){
        [self.searchBar setShowsCancelButton:NO animated:YES];
        [self.searchBar resignFirstResponder];
        
        HNKGooglePlacesAutocompletePlace *selectedPlace = self.searchResults[indexPath.row];
        
        [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace
                                           apiKey: self.searchQuery.apiKey
                                       completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
                                           if (placemark) {
                                               [self.tableView setHidden: YES];
                                               g_address = addressString;
                                               g_latitude = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
                                               g_longitude = [NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
                                               [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                                               self.mDeliveryLabel.text = g_address;
                                               if([self.mRest.location length] != 0){
                                                   CLLocationDegrees onelat = [g_latitude floatValue];
                                                   CLLocationDegrees onelon = [g_longitude floatValue];
                                                   CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:onelat longitude:onelon];
                                                   NSArray *foo1 = [self.mRest.location componentsSeparatedByString: @","];
                                                   CLLocationDegrees otherlat = [foo1[0] floatValue];
                                                   CLLocationDegrees otherlon = [foo1[1] floatValue];
                                                   CLLocation *oneLocation = [[CLLocation alloc] initWithLatitude:otherlat longitude:otherlon];
                                                   CLLocationDistance distance = [myLocation distanceFromLocation:oneLocation] * 1.323;
                                                   self.mRest.mDistance = fabs(distance);
                                                   [self reloadData];
                                               }
                                               
                                           }  else {
                                               UIAlertController * alert=   [UIAlertController
                                                                             alertControllerWithTitle:@"Warning!"
                                                                             message:@"Google can not find location from your address. Please enter address again."
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                               
                                               UIAlertAction* yesButton = [UIAlertAction
                                                                           actionWithTitle:@"Ok"
                                                                           style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * action)
                                                                           {
                                                                               //Handel your yes please button action here
                                                                               
                                                                           }];
                                               [alert addAction:yesButton];
                                               [self presentViewController:alert animated:YES completion:nil];
                                           }
                                           //[SVProgressHUD dismiss];
                                       }];
        //self.mSearchView.hidden = YES;
        self.searchBar.hidden = YES;
        self.mHideBtn.hidden = YES;
    }
}

#pragma mark - UISearchBar Delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0)
    {
        [self.tableView setHidden:NO];
        
        [self.searchQuery fetchPlacesForSearchQuery: searchText
                                         completion:^(NSArray *places, NSError *error) {
                                             if (error) {
                                                 NSLog(@"ERROR: %@", error);
                                                 [self handleSearchError:error];
                                             } else {
                                                 self.searchResults = places;
                                                 [self.tableView reloadData];
                                             }
                                         }];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.tableView setHidden:YES];
    //self.mSearchView.hidden = YES;
    self.searchBar.hidden = YES;
    self.mHideBtn.hidden = YES;
}

- (void)handleSearchError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    return center;
}
@end
