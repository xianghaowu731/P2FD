//
//  DOrderDetailVC.m
//  Food
//
//  Created by meixiang wu on 19/09/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "DOrderDetailVC.h"
#import "RFoodTVCell.h"
#import "OrderDetailUserInfoRTVC.h"
#import "Deliver.h"
#import "Config.h"
#import "OrderedFood.h"
#import "ExtraFood.h"
#import "ExtraMenu.h"
#import "TableFood.h"

extern Deliver* deliver;
@interface DOrderDetailVC ()<MKMapViewDelegate, MKOverlay>{
    MKPlacemark *m_dest;
    NSMutableArray* tablearray;
    float totalprice, subprice;
}

@end

@implementation DOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Order Detail";
    self.mMapView.delegate = self;
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLayout{
    self.fooddata = self.data.orderedfoods;
    self.mOrderNumLabel.text = [NSString stringWithFormat:@"Order ID:%@", self.data.orderId];
    self.mFirstNameLabel.text = self.data.tofirst;
    self.mLastNameLabel.text = self.data.tolast;
    self.mEmailLabel.text = self.data.user.email;
    self.mPhoneLabel.text = self.data.tophone;
    self.mAddressLabel.text = self.data.address;
    self.mInstructionTxt.text = self.data.comment;
    self.mPriceLabel.text = [NSString stringWithFormat:@"$%@", self.data.totalPrice];
    
    self.mResrNameLabel.text = self.data.restName;
    self.mRestPhoneLabel.text = self.data.restPhone;
    self.mRestEmailLabel.text = self.data.restEmail;
    self.mRestAddressLabel.text = self.data.restAddress;
    
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
        self.mPickTimeLabel.text = [NSString stringWithFormat:@"Time: %@", [dateFormat stringFromDate:real_date]];
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
    self.mEstLabel.text = [NSString stringWithFormat:@"Est. Delivery:%@-%@",[dateFormat stringFromDate:real_date] , [timeFormat stringFromDate:real_date1]];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    int h = 50;
    if([tablearray count] == indexPath.row){
        h = 100;
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
        cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_DTotalCell" forIndexPath:indexPath];
        
        UILabel *subLabel = [cell viewWithTag:13];
        NSString* tprice = [NSString stringWithFormat:@"%.2f", subprice];
        subLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
        UILabel *taxLabel = [cell viewWithTag:12];
        tprice = [NSString stringWithFormat:@"%.2f", (DELIVERY_TAX * subprice)];
        taxLabel.text = [NSString stringWithFormat:@"%@%@", @"$", tprice];
        UILabel *totalLabel = [cell viewWithTag:11];
        totalLabel.text = [NSString stringWithFormat:@"%@%@", @"$", self.data.totalPrice];
        UILabel *feeLabel = [cell viewWithTag:14];
        feeLabel.text = [NSString stringWithFormat:@"$%@", self.data.deliveryFee];
        UILabel *tipLabel = [cell viewWithTag:15];
        tipLabel.text = [NSString stringWithFormat:@"$%@", self.data.tipPrice];
    } else {
        
        TableFood* item = tablearray[indexPath.row];
        if(item.type == 1){
            cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_DFoodLineCell" forIndexPath:indexPath];
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
            //UILabel* instLabel = [cell viewWithTag:5];
            //instLabel.text = [NSString stringWithFormat:@"%@", item.instruction];
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
    
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCustomerCall:(id)sender {
    NSString *phoneNumber = [self.mPhoneLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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

- (IBAction)onRestaurantCall:(id)sender {
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

- (IBAction)onUserMap:(id)sender {
    CLLocationCoordinate2D otherloc = [self getLocationFromAddressString:self.mAddressLabel.text];
    NSString *loc= [NSString stringWithFormat:@"%f,%f", otherloc.latitude, otherloc.longitude];
    [self drawRoute:loc];
}

- (IBAction)onRestMap:(id)sender {
    CLLocationCoordinate2D otherloc = [self getLocationFromAddressString:self.mRestAddressLabel.text];
    NSString *loc= [NSString stringWithFormat:@"%f,%f", otherloc.latitude, otherloc.longitude];
    [self drawRoute:loc];
}

- (void)drawRoute:(NSString *)oneLoc
{
    NSArray* foo = [oneLoc componentsSeparatedByString: @","];
    
    CLLocationCoordinate2D coordinateArray[2];
    //    coordinateArray[0] = self.mHomeCoordinate;
    coordinateArray[1] = CLLocationCoordinate2DMake([foo[0] doubleValue], [foo[1] doubleValue]);
    
    MKPlacemark *placemark1  = [[MKPlacemark alloc] initWithCoordinate:coordinateArray[1] addressDictionary:nil];
    m_dest = placemark1;
    
    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:placemark1];
    
    [mapItem1 openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = mapItem1;
    
    //    request.destination = mapItem;
    //request.requestsAlternateRoutes = NO;
    [request setTransportType:MKDirectionsTransportTypeAny]; // This can be limited to automobile and walking directions.
    [request setRequestsAlternateRoutes:YES]; // Gives you several route options.
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"ERROR");
             NSLog(@"%@",[error localizedDescription]);
         } else {
             [self showRoute:response];
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.mMapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 3.0;
    return renderer;
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
