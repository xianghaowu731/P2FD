//
//  CartReviewView.m
//  Food
//
//  Created by meixiang wu on 7/17/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "CartReviewView.h"
#import "Food.h"
#import "FMDBHelper.h"
#import "Customer.h"
#import "AppDelegate.h"
#import "Config.h"
#import <SVProgressHUD.h>
#import "HttpApi.h"
#import "Common.h"
#import "ChoosePaymentView.h"
#import "PayConfirmView.h"
#import "CardViewController.h"
#import "ApplePayViewController.h"
#import "ThreeDSViewController.h"
#import "ShippingManager.h"
#import "CLPlacemark+HNKAdditions.h"
#import "TableFood.h"
#import "ExtraFood.h"
#import "ExtraMenu.h"


extern FMDBHelper* helper;
extern Customer* customer;
// To set this up, check out https://github.com/stripe/example-ios-backend
// This should be in the format https://my-shiny-backend.herokuapp.com
NSString const *BackendBaseURL = @"https://p2fdbackend.herokuapp.com";//@"https://stripep2fd.herokuapp.com"; // TODO: replace nil with your own value
static NSString *const kHNKDemoSearchResultsCellIdentifier = @"AddressSearchResultsCellIdentifier";

@interface CartReviewView ()<UISearchBarDelegate,CheckViewControllerDelegate, PKPaymentAuthorizationViewControllerDelegate,CLLocationManagerDelegate>{
    NSMutableArray* tabledata;
    float totalprice, subprice;
}
@property (nonatomic) ShippingManager *shippingManager;
//@property (strong, nonatomic) NSString *publicKey;
@property (strong, nonatomic) UIColor *primaryColor;
@property (nonatomic) NSString *mTotalPrice;
@property (nonatomic) UIImage *logoImg;
@property (nonatomic) BOOL applePaySucceeded;
@property (nonatomic) NSError *applePayError;
@property (nonatomic) NSString *paytoken;

@end

@implementation CartReviewView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    g_appDelegate.mViewState = 8;
    g_appDelegate.mPayMethod = 0;
    
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    
    self.primaryColor = PRIMARY_COLOR;
    self.shippingManager = [[ShippingManager alloc] init];
    
    //==========================================
    self.logoImg = [Common imageWithImage:[UIImage imageNamed:@"guest_logo"] scaledToSize:CGSizeMake(50.0, 50.0)];
    self.paytoken = @"";
    
    CALayer *imageLayer = self.mDeliveryAddress.layer;
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor blackColor].CGColor];
    
    imageLayer = self.mInstructionText.layer;
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor blackColor].CGColor];
    
    imageLayer = self.tableView.layer;
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor grayColor].CGColor];
    
    self.mInstructionText.placeholder = @"Include Apt# or Building#";
    self.mDeliveryAddress.placeholder = @"Street, Address, City, State";
    self.mHideBtn.hidden = YES;
    self.searchBar.hidden = YES;
    self.tableView.hidden = YES;
    
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadLayout];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) setLayout{
    if(g_isRestOrder){
        self.mUserFirstName.text = g_toFirst;
        self.mUserLastName.text = g_toLast;
        self.mUserPhone.text = g_toPhone;
        self.mDeliveryAddress.text = g_address;
        if([self.mRest.address length] > 0 && [self.mRest.location length] == 0) {
            CLLocationCoordinate2D otherloc = [self getLocationFromAddressString:self.mRest.address];
            self.mRest.location = [NSString stringWithFormat:@"%f,%f", otherloc.latitude, otherloc.longitude];
        }
        
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
            [[HttpApi sharedInstance] getLocationByRestId:self.mRest.restaurantId Location:self.mRest.location
                                                Completed:^(NSString *array){
                                                }Failed:^(NSString *strError) {
                                                }];
            
        }
        self.mApplePayView.hidden = YES;
        g_appDelegate.mPayMethod = 1;
    }
    self.mDeliveryAddress.text = g_address;
    NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[self.mRest.comment dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.mInstructionText.attributedText = desc;
    self.mInstructionText.textAlignment = NSTextAlignmentLeft;
    [self.mInstructionText setFont:[UIFont systemFontOfSize:13]];
    /*if(g_appDelegate.mPayMethod == 0){
        [self.mPayTypeBtn setTitle:@"Apple Pay" forState:UIControlStateNormal];
        [self.mPlaceBtn setTitle:@"" forState:UIControlStateNormal];
        self.mMarkImg.hidden = false;
        //[self.mMarkImg setImage:[UIImage imageNamed:@"ApplePayBtn_2.png"]];
    } else if(g_appDelegate.mPayMethod == 1){
        [self.mPayTypeBtn setTitle:@"Credit Card" forState:UIControlStateNormal];
        self.mMarkImg.hidden = true;
    } else{
        [self.mPayTypeBtn setTitle:@"Credit Card + 3DS" forState:UIControlStateNormal];
        self.mMarkImg.hidden = true;
    }*/
    [self drawPaymentMethod];
    self.mRestName.text = self.mRest.name;
    [self reloadLayout];
}

- (void)drawPaymentMethod{
    switch (g_appDelegate.mPayMethod) {
        case 0://Apple
            [self.mAppleOptionImg setImage:[UIImage imageNamed: @"ic_choice_on.png"]];
            [self.mCreditOptionImg setImage:[UIImage imageNamed: @"ic_choice_off.png"]];            
            [self.mPlaceBtn setTitle:@"" forState:UIControlStateNormal];
            self.mMarkImg.hidden = false;
            break;
        case 1:
            [self.mAppleOptionImg setImage:[UIImage imageNamed: @"ic_choice_off.png"]];
            [self.mCreditOptionImg setImage:[UIImage imageNamed: @"ic_choice_on.png"]];
            self.mMarkImg.hidden = true;
            break;
        default:
            break;
    }
}

- (void) reloadLayout{
    self.data = [helper getOrdersByRestID:self.mRest.restaurantId];
    tabledata = [[NSMutableArray alloc] init];
    totalprice = 0;
    subprice = 0;
    for(int i=0;i<self.data.count;i++){
        Food *cart_food = (Food*)(self.data[i]);
        TableFood *one = [[TableFood alloc] init];
        one.mId = cart_food.foodId;
        one.foodname = cart_food.name;
        one.price = [cart_food.price stringValue];
        one.count = [cart_food.count stringValue];
        one.type = 1;//main food
        [tabledata addObject:one];
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
                [tabledata addObject:other];
                subprice += other.price.floatValue * [other.count intValue];
            }
        }
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
        if(g_isMistakeOrder){
            subprice = g_subprice;
            m_fee = 0;
        }
    }
    self.mDeliveryFee = m_fee;
    
    totalprice = subprice + DELIVERY_TAX * subprice + m_fee + self.mtipFee;
    
    if(g_appDelegate.mPayMethod != 0){
        NSString *title = [NSString stringWithFormat:@"Place My Order - $%.2f", totalprice];
        [self.mPlaceBtn setTitle:title forState:UIControlStateNormal];
    }
    
    //long dtime = (long)((fee_distance/KM_PER_MILE)/DELIVERY_MILE_PER_MIN);
    self.mDeliveryTime.text =@"45 - 60 minutes"; //[NSString stringWithFormat:@"%ld - %ld minutes", dtime, dtime+10];
    
    [self.mTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onAddressEditClick:(id)sender {
    self.mHideBtn.hidden = NO;
    self.searchBar.hidden = NO;
    self.tableView.hidden = NO;
}

- (IBAction)onApplePayClick:(id)sender {
    g_appDelegate.mPayMethod = 0;
    [self drawPaymentMethod];
    [self reloadLayout];
}

- (IBAction)onCreditPayClick:(id)sender {
    g_appDelegate.mPayMethod = 1;
    [self drawPaymentMethod];
    [self reloadLayout];
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPlaceClick:(id)sender {
    if([self.mUserFirstName.text length] == 0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter first name."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self.mUserFirstName becomeFirstResponder];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if([self.mUserLastName.text length] == 0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter first name."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self.mUserLastName becomeFirstResponder];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if([self.mUserPhone.text length] == 0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter phone number."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self.mUserPhone becomeFirstResponder];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if([self.mUserPhone.text length] != 10){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"Phone number must be 10 digits."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self.mUserPhone becomeFirstResponder];                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if([self.mDeliveryAddress.text length] == 0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Warning!"
                                      message:@"You must enter delivery address."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self.mDeliveryAddress becomeFirstResponder];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    self.mRest.comment = [self.mInstructionText.attributedText string];
    /*NSString* foodIds = @"";
    for(int i=0;i<self.data.count-1;i++){
        Food *food = self.data[i];
        NSString* foodId = food.foodId;
        NSString* count = [food.count stringValue];
        foodIds = [NSString stringWithFormat:@"%@%@*%@,", foodIds, foodId, count];
    }
    
    foodIds = [NSString stringWithFormat:@"%@%@*%@", foodIds, ((Food*)(self.data[self.data.count-1])).foodId, [((Food*)(self.data[self.data.count-1])).count stringValue]];*/
    
    NSString* subPriceStr = [NSString stringWithFormat:@"%.2f", subprice];
    self.mTotalPrice = [NSString stringWithFormat:@"%ld", (long)(totalprice * 100)];
    NSString *total_price = [NSString stringWithFormat:@"%.2f", totalprice];
    NSString* delFee = [NSString stringWithFormat:@"%.2f", self.mDeliveryFee];
    NSString* tipPrice = [NSString stringWithFormat:@"%.2f", self.mtipFee];
    NSString* taxStr = [NSString stringWithFormat:@"%.2f", DELIVERY_TAX * subprice];
    
    if(g_isRestOrder && g_isMistakeOrder){
        [self sendOrderRequest:@"mistake-token"];
        return;
    }
    //=====testcode=========
    //[self sendOrderRequest:@"test-token"];
    //return;
    //------------------------------------    
    
    UIViewController *viewController;
    if(g_appDelegate.mPayMethod == 0){// Apple Pay
        PKPaymentSummaryItem *subitem = [[PKPaymentSummaryItem alloc] init];
        subitem.label = @"Foods Price";
        subitem.amount = [NSDecimalNumber decimalNumberWithString:subPriceStr];
        
        PKPaymentSummaryItem *deliveryitem = [[PKPaymentSummaryItem alloc] init];
        deliveryitem.label = @"Delivery Fee";
        deliveryitem.amount = [NSDecimalNumber decimalNumberWithString:delFee];
        
        PKPaymentSummaryItem *taxitem = [[PKPaymentSummaryItem alloc] init];
        taxitem.label = @"Tax";
        taxitem.amount = [NSDecimalNumber decimalNumberWithString:taxStr];
        
        PKPaymentSummaryItem *tipitem = [[PKPaymentSummaryItem alloc] init];
        tipitem.label = @"Tip";
        tipitem.amount = [NSDecimalNumber decimalNumberWithString:tipPrice];
        
        PKPaymentSummaryItem *totalitem = [[PKPaymentSummaryItem alloc] init];
        totalitem.label = @"P2FD";
        totalitem.amount = [NSDecimalNumber decimalNumberWithString:total_price];
        
        PKPaymentRequest* paymentRequest = [[PKPaymentRequest alloc] init];
        paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkDiscover, PKPaymentNetworkMasterCard, PKPaymentNetworkPrivateLabel, PKPaymentNetworkVisa];
        paymentRequest.countryCode = @"US";
        paymentRequest.currencyCode = @"USD";
        
        //2. SDKDemo.entitlements needs to be updated to use the new merchant id
        paymentRequest.merchantIdentifier = @"merchant.com.patrick.p2fd";
        
        paymentRequest.merchantCapabilities = PKMerchantCapabilityEMV | PKMerchantCapability3DS;
        paymentRequest.paymentSummaryItems = @[subitem, deliveryitem, taxitem, tipitem, totalitem];
        paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
        paymentRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress;
        
        
        //3. Create a PKPaymentAuthorizationController object with your paymentRequest
        /*PKPaymentAuthorizationViewController *pavc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
        pavc.delegate = self;
        
        if (pavc) {
            [self presentViewController:pavc animated:YES completion:nil];
        } else {
            NSLog(@"PKPaymentAuhthorizationViewController failure. Have you added any cards to the device?");
        }*/
        //PKPaymentRequest *paymentRequest = [self buildPaymentRequest];
        if (paymentRequest) {
            if([Stripe canSubmitPaymentRequest:paymentRequest]){
                self.applePaySucceeded = NO;
                self.applePayError = nil;
                
                //PKPaymentRequest *paymentRequest = [self buildPaymentRequest];
                if ([Stripe canSubmitPaymentRequest:paymentRequest]) {
                    PKPaymentAuthorizationViewController *auth = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
                    auth.delegate = self;
                    if (auth) {
                        [self presentViewController:auth animated:YES completion:nil];
                    } else {
                        NSLog(@"Apple Pay returned a nil PKPaymentAuthorizationViewController - make sure you've configured Apple Pay correctly, as outlined at https://stripe.com/docs/mobile/apple-pay");
                    }
                }
            }
        }
        return;
    } else if(g_appDelegate.mPayMethod == 1){//credit card
        CardViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CardViewController"];
        vc.delegate = self;
        viewController = vc;
    } else{
        ThreeDSViewController *exampleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ThreeDSViewController"];
        exampleVC.delegate = self;
        viewController = exampleVC;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onPayTypeChange:(id)sender {
    ChoosePaymentView *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChoosePaymentView"];
    //UIButton *senderBtn = (UIButton *)sender;
    CGPoint point = self.mPayTypeBtn.frame.origin;
    point.x+=self.mPayTypeBtn.frame.size.width/2;point.y+=( 164 + self.mPayTypeBtn.frame.size.height);
    [viewController ShowPopover:self ShowAtPoint:point DismissHandler:^{
        [self setLayout];
    }];
}

- (IBAction)onHideViewClick:(id)sender {
}
#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(tableView == self.mTableView){
        return [tabledata count] + 1;
    } else if(tableView == self.tableView){
        return self.searchResults.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mTableView){
        int h = 28;
        if(indexPath.row == tabledata.count) h = 128;
        return h;
    } else if(tableView == self.tableView){
        return 40;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView==self.mTableView){
        UITableViewCell* cell;
        if (indexPath.row == tabledata.count) {
            cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_TotalCell" forIndexPath:indexPath];
            UILabel *subLabel = [cell viewWithTag:3];
            NSString* tprice = [NSString stringWithFormat:@"%.2f", subprice];
            subLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
            
            UILabel *feeLabel = [cell viewWithTag:4];
            tprice = [NSString stringWithFormat:@"%.2f", self.mDeliveryFee];
            feeLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
            
            UILabel *taxLabel = [cell viewWithTag:5];
            tprice = [NSString stringWithFormat:@"%.2f", (DELIVERY_TAX * subprice)];
            taxLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
            
            UILabel *tipLabel = [cell viewWithTag:6];
            tprice = [NSString stringWithFormat:@"%.2f", self.mtipFee];
            tipLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
            
            //totalprice = subprice + DELIVERY_TAX * subprice + self.mDeliveryFee + self.mtipFee;
            UILabel *totalLabel = [cell viewWithTag:7];
            tprice = [NSString stringWithFormat:@"%.2f", totalprice];
            totalLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
            
        } else {
            cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_FoodLineCell" forIndexPath:indexPath];
            UILabel *foodName = [cell viewWithTag:1];
            UILabel* priceLabel = [cell viewWithTag:2];
            TableFood* item = tabledata[indexPath.row];
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
                                               self.mDeliveryAddress.text = g_address;
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
                                                   [self reloadLayout];
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
        self.mHideBtn.hidden = YES;
        self.searchBar.hidden = YES;
        self.tableView.hidden = YES;
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
    self.mHideBtn.hidden = YES;
    self.searchBar.hidden = YES;
    self.tableView.hidden = YES;
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
//==============================================

- (NSArray *)summaryItemsForShippingMethod:(PKShippingMethod *)shippingMethod {
    PKPaymentSummaryItem *shirtItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Cool Shirt" amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]];
    NSDecimalNumber *total = [shirtItem.amount decimalNumberByAdding:shippingMethod.amount];
    PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Stripe Shirt Shop" amount:total];
    return @[shirtItem, shippingMethod, totalItem];
}

- (BOOL)applePayEnabled {
    PKPaymentRequest *paymentRequest = [self buildPaymentRequest];
    if (paymentRequest) {
        return [Stripe canSubmitPaymentRequest:paymentRequest];
    }
    return NO;
}

- (PKPaymentRequest *)buildPaymentRequest {
    if ([PKPaymentRequest class]) {
        PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:MY_MERCHANT_ID
                                                                                country:@"US"
                                                                               currency:@"USD"];
        [paymentRequest setRequiredShippingAddressFields:PKAddressFieldPostalAddress];
        [paymentRequest setRequiredBillingAddressFields:PKAddressFieldPostalAddress];
        paymentRequest.shippingMethods = [self.shippingManager defaultShippingMethods];
        paymentRequest.paymentSummaryItems = [self summaryItemsForShippingMethod:paymentRequest.shippingMethods.firstObject];
        return paymentRequest;
    }
    return nil;
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate
/*
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingAddress:(ABRecordRef)address completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> *, NSArray<PKPaymentSummaryItem *> *))completion {
    [self.shippingManager fetchShippingCostsForAddress:address
                                            completion:^(NSArray *shippingMethods, NSError *error) {
                                                if (error) {
                                                    completion(PKPaymentAuthorizationStatusFailure, @[], @[]);
                                                    return;
                                                }
                                                completion(PKPaymentAuthorizationStatusSuccess,
                                                           shippingMethods,
                                                           [self summaryItemsForShippingMethod:shippingMethods.firstObject]);
                                            }];
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingMethod:(PKShippingMethod *)shippingMethod completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
    completion(PKPaymentAuthorizationStatusSuccess, [self summaryItemsForShippingMethod:shippingMethod]);
}*/

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    [[STPAPIClient sharedClient] createTokenWithPayment:payment
                                             completion:^(STPToken *token, NSError *error) {
                                                 [self createBackendChargeWithSource:token.tokenId
                                                                                   completion:^(STPBackendChargeResult status, NSError *error) {
                                                                                       if (status == STPBackendChargeResultSuccess) {
                                                                                           self.applePaySucceeded = YES;
                                                                                           completion(PKPaymentAuthorizationStatusSuccess);
                                                                                       } else {
                                                                                           self.applePayError = error;
                                                                                           completion(PKPaymentAuthorizationStatusFailure);
                                                                                       }
                                                                                   }];
                                             }];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.applePaySucceeded) {
                [self checkViewController:self didFinishWithMessage:@"Payment successfully created"];
            } else if (self.applePayError) {
                [self checkViewController:self didFinishWithError:self.applePayError];
            }
            self.applePaySucceeded = NO;
            self.applePayError = nil;
        }];
    });
}

- (void) showErrorMsg:(NSString*)errCode{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:errCode preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // action 1
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
#pragma mark - SIMChargeViewController delegate

-(void)chargeCardCancelled {
    
    //User cancelled the SIMChargeCardViewController
    [self.chargeController dismissViewControllerAnimated:YES completion:nil];
}

-(void)creditCardTokenFailedWithError:(NSError *)error {
    
    //There was a problem generating the token
    NSLog(@"Card Token Generation failed with error:%@", error);
    
    SIMResponseViewController *viewController = [[SIMResponseViewController alloc]initWithSuccess:NO title:@"Error!" description:@"Something went wrong with your order. If you really want to spend a bunch of money, go ahead and try that again." iconImage:nil backgroundImage:self.logoImg  tintColor:PRIMARY_COLOR];
    viewController.buttonColor = [UIColor buttonBackgroundColorEnabled];
    viewController.buttonText = @"Try again";
    viewController.buttonTextColor = [UIColor whiteColor];
    
    //Further customize your response view controller interface colors and text
    //viewController.titleMessageColor;
    //viewController.titleDescriptionColor;
    
    //Example of a simpler response view controller
    //viewController = [[SIMResponseViewController alloc]initWithSuccess:NO tintColor:[UIColor redColor]];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - PKPay

#pragma mark PKPaymentAuthorizationViewControllerDelegate
-(void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    NSError *error = nil;
    SIMSimplify* simplify = [[SIMSimplify alloc] initWithPublicKey:self.publicKey error:&error];
    
    if (error) {
        completion(PKPaymentAuthorizationStatusFailure);
    } else {
#if TARGET_IPHONE_SIMULATOR
        if ([@"Simulated Identifier" isEqualToString:payment.token.transactionIdentifier]) {
            
            [controller dismissViewControllerAnimated:YES completion:^{
                NSLog(@"You will need to run this on a device in order to actually test Apple Pay. Simulated Apple Pay:%@", simplify.description);
            }];
        }
#else
        [simplify createCardTokenWithPayment:payment completionHandler:^(SIMCreditCardToken *cardToken, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [controller dismissViewControllerAnimated:YES completion:^{
                     
                     [self dismissViewControllerAnimated:YES completion:^{
                         if (error) {
                             completion(PKPaymentAuthorizationStatusFailure);
                             [self creditCardTokenFailedWithError:error];
                         } else {
                             completion(PKPaymentAuthorizationStatusSuccess);
                             [self creditCardTokenProcessed:cardToken];
                         }
                     }];
                 }];
             });
         }];
#endif
    }
}

-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//6. This method will be called on your class whenever the user presses the Charge Card button and tokenization succeeds
-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token {
    //Token was generated successfully, now you must use it
    //Process Request on your own server
    //See https://github.com/simplifycom/simplify-php-server for a sample implementation.
    
    NSURL *url= [NSURL URLWithString:@"https://p2fd.herokuapp.com//charge.php"];//http://p2fooddelivery.com/simplify-payment/charge.php
    
    SIMWaitingView *waitingView = [[SIMWaitingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:waitingView];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"simplifyToken=%@&amount=%@", token.token, self.mTotalPrice];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *paymentTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [waitingView removeFromSuperview];
            
            if (error || ![responseObject[@"status"] isEqualToString:@"APPROVED"]) {
                
                PayConfirmView *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PayConfirmView"];
                vc.mOrder = @"";
                vc.mStatus = @"NO";
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                PayConfirmView *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PayConfirmView"];
                vc.mOrder = [NSString stringWithFormat:@"%ld", self.data.count];
                vc.mStatus = @"YES";
                [self.navigationController pushViewController:vc animated:YES];
                [self sendOrderRequest:token.token];
            }
        });
    }];
    
    [paymentTask resume];
}*/

- (void)sendOrderRequest:(NSString *)token{
    self.mRest.comment = [self.mInstructionText.attributedText string];
    
    NSDictionary* json_dic = [self makeDictionaryForList];
    NSError * error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json_dic options:NSJSONReadingMutableContainers error:&error];
    NSString *orderStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *inst_str = ((Food*)(self.data[0])).instruction;
    for(int i=1;i<self.data.count;i++){
        inst_str = [NSString stringWithFormat:@"%@,%@", inst_str, ((Food*)(self.data[i])).instruction];
    }
    //totalprice = subprice + DELIVERY_TAX * subprice + self.mDeliveryFee + self.mtipFee;
    NSString* subPrice = [NSString stringWithFormat:@"%.2f", subprice];
    NSString* totalPrice = [NSString stringWithFormat:@"%.2f", totalprice];
    NSString* restId = ((Food*)(self.data[0])).restId;
    NSString* delFee = [NSString stringWithFormat:@"%.2f", self.mDeliveryFee];
    NSString* tipPrice = [NSString stringWithFormat:@"%.2f", self.mtipFee];
    NSString* location = [NSString stringWithFormat:@"%@,%@", g_latitude, g_longitude];
    //===========================================
    NSString* uFirstName = self.mUserFirstName.text;
    NSString* uLastName = self.mUserLastName.text;
    NSString* uPhone = self.mUserPhone.text;
    NSString* uAddress = self.mDeliveryAddress.text;
    [SVProgressHUD show];
    [[HttpApi sharedInstance] doOrderByCustomerId:(NSString *)customer.customerId
                                          foodIds:(NSString *)orderStr
                                       totalPrice:(NSString *)totalPrice
                                          comment:(NSString *)self.mRest.comment
                                           restId:(NSString *)restId
                                          Address:(NSString *)uAddress
                                         SubPrice:(NSString *)subPrice
                                      DeliveryFee:(NSString *)delFee
                                         TipPrice:(NSString *)tipPrice
                                         FromTime:(NSString *)g_deliveryTime
                                         Location:(NSString *)location
                                         TouFirst:(NSString *)uFirstName
                                          TouLast:(NSString *)uLastName
                                         TouPhone:(NSString *)uPhone
                                      Instruction:(NSString *)inst_str
                                            Token:(NSString *)token
                                        Completed:^(NSString* result){
                                            [SVProgressHUD dismiss];
                                            UIAlertController * alert = [UIAlertController
                                                                         alertControllerWithTitle:@"Success!"
                                                                         message:@"Order sent successfully."
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                            
                                            UIAlertAction* yesButton = [UIAlertAction
                                                                        actionWithTitle:@"OK"
                                                                        style:UIAlertActionStyleDefault
                                                                        handler:^(UIAlertAction * action)
                                                                        {
                                                                            //Handel your yes please button action here
                                                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                                                            
                                                                        }];
                                            [alert addAction:yesButton];
                                            [self presentViewController:alert animated:YES completion:nil];
                                            
                                            [helper deleteOrderByRestId:restId];
                                            g_isRestOrder = false;
                                            g_isMistakeOrder = false;
                                            //[self.navigationController popToRootViewControllerAnimated:YES];
                                            [self.navigationController popToViewController: self.navigationController.viewControllers[self.navigationController.viewControllers.count-4] animated:YES];
                                            
                                        }Failed:^(NSString *strError) {
                                            [SVProgressHUD showErrorWithStatus:strError];
                                        }];
}

#pragma mark - STPBackendCharging

- (void)createBackendChargeWithSource:(NSString *)sourceID completion:(STPSourceSubmissionHandler)completion {
    if (!BackendBaseURL) {
        NSError *error = [NSError errorWithDomain:StripeDomain
                                             code:STPInvalidRequestError
                                         userInfo:@{NSLocalizedDescriptionKey: @"You must set a backend base URL in Constants.m to create a charge."}];
        completion(STPBackendChargeResultFailure, error);
        return;
    }
    
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *urlString = [BackendBaseURL stringByAppendingPathComponent:@"create_charge"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postBody = [NSString stringWithFormat:@"source=%@&amount=%@", sourceID, self.mTotalPrice];//@"1099"
    //[self showErrorMsg:sourceID];
    NSData *data = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    self.paytoken = sourceID;
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:data
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                          if (!error && httpResponse.statusCode != 200) {
                                                              error = [NSError errorWithDomain:StripeDomain
                                                                                          code:STPInvalidRequestError
                                                                                      userInfo:@{NSLocalizedDescriptionKey: @"There was an error connecting to your payment backend."}];
                                                          }
                                                          if (error) {
                                                              completion(STPBackendChargeResultFailure, error);
                                                          } else {
                                                              completion(STPBackendChargeResultSuccess, nil);
                                                          }
                                                      }];
    
    [uploadTask resume];
}

#pragma mark - CheckViewControllerDelegate

- (void)checkViewController:(UIViewController *)controller didFinishWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        PayConfirmView *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PayConfirmView"];
        vc.mOrder = [NSString stringWithFormat:@"%ld", self.data.count];
        vc.mStatus = @"YES";
        [self.navigationController pushViewController:vc animated:YES];
        [self sendOrderRequest:self.paytoken];
        /*UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [controller presentViewController:alertController animated:YES completion:nil];*/
    });
}

- (void)checkViewController:(UIViewController *)controller didFinishWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        PayConfirmView *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PayConfirmView"];
        vc.mOrder = @"";
        vc.mStatus = @"NO";
        [self.navigationController pushViewController:vc animated:YES];
        /*UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [controller presentViewController:alertController animated:YES completion:nil];*/
    });
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
    //NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    //NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}

- (NSDictionary*) makeDictionaryForList{
    NSMutableArray *order_array = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < self.data.count; i++){
        Food *one_food = self.data[i];
        NSMutableArray *order_menus = [[NSMutableArray alloc] init];
        for(int j = 0; j < one_food.extrafoods.count; j++){
            ExtraMenu* one_menu = one_food.extrafoods[j];
            NSMutableArray *order_extras = [[NSMutableArray alloc] init];
            for(int k = 0; k < one_menu.extrafoods.count; k++ ){
                ExtraFood* one = one_menu.extrafoods[k];
                NSDictionary *one_dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:one.eid, one.count, nil] forKeys:[NSArray arrayWithObjects:@"efood_id", @"amount", nil]];
                [order_extras addObject:one_dic];
            }
            NSDictionary *menu_dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:one_menu.menuId, order_extras, nil] forKeys:[NSArray arrayWithObjects:@"menu_id", @"extrafoods", nil]];
            [order_menus addObject:menu_dic];
        }
        NSDictionary *food_dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:one_food.foodId,[one_food.count stringValue], order_menus, nil] forKeys:[NSArray arrayWithObjects:@"food_id", @"amount", @"extramenus", nil]];
        [order_array addObject:food_dic];
    }
    
    NSDictionary * result_dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:order_array, nil] forKeys:[NSArray arrayWithObjects:@"foods", nil]];
    return result_dic;
}

@end
