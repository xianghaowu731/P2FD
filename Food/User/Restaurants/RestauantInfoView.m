//
//  RestauantInfoView.m
//  Food
//
//  Created by meixiang wu on 6/2/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "RestauantInfoView.h"
#import <SVProgressHUD.h>
#import "HttpApi.h"
#import "Customer.h"
#import "Config.h"
#import <UIImageView+WebCache.h>

extern Customer *customer;

@interface RestauantInfoView ()<MKMapViewDelegate, MKOverlay>{
    MKPlacemark *m_dest;
}


@end

@implementation RestauantInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mMapView.delegate = self;
    
    self.colors = @[ [UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0f], [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f], [UIColor colorWithRed:0.1f green:1.0f blue:0.1f alpha:1.0f]];
    // Setup control using iOS7 tint Color
    self.mRateView.backgroundColor  = self.colors[1];//[UIColor whiteColor];
    self.mRateView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRateView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRateView.maxRating = 5.0;
    self.mRateView.delegate = (id)self;
    self.mRateView.horizontalMargin = 2.0;
    self.mRateView.editable=YES;
    float rating = 4.65f;
    self.mRateView.rating= rating;
    self.mRateView.displayMode=EDStarRatingDisplayAccurate;
    [self.mRateView  setNeedsDisplay];
    self.mRateView.tintColor = self.colors[0];
    self.mRateLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    CALayer *imageLayer = self.mDescText.layer;
    [imageLayer setCornerRadius:7];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    self.mDescText.textContainerInset = UIEdgeInsetsMake(20, 10, 10, 10);
    [self setLayout:self.mRestaurant];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [self getData];
}

- (void)getData{
    
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getRestInfoByRestId:(NSString *)self.mRestaurant.restaurantId
                                       CustomerId:(NSString *)customer.customerId
                                        Completed:^(NSDictionary *dic){
                                            [SVProgressHUD dismiss];
                                            
                                            self.mRestaurant = [[Restaurant alloc] initWithDictionary:dic[@"rest"]];
                                            [self setLayout:self.mRestaurant];
                                        }Failed:^(NSString *strError) {
                                            [SVProgressHUD showErrorWithStatus:strError];
                                        }];    
}


- (void) setLayout:(Restaurant*) r {
    self.mTitleLabel.text = self.mRestaurant.name;
    NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, RESTAURANT_IMAGE_BASE_URL, r.img];
    [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    float rating = [r.ranking floatValue];
    self.mRateView.rating = rating;
    self.mRateLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    if(r.isfavorite.intValue == 1){
        [self.m_favorite setImage:[UIImage imageNamed:@"hart.png"] forState:UIControlStateNormal];
    } else {
        [self.m_favorite setImage:[UIImage imageNamed:@"hart_line.png"] forState:UIControlStateNormal];
    }
    self.mReviewLabel.text = [NSString stringWithFormat:@"(%d%@%@)", r.reviews.intValue, @" ", @"reviews"];
    
    //======================================
    self.mEmailLabel.text = r.email;
    self.mAddress.text = r.address;
    self.mCallBtn.hidden = YES;
    if(![r.phone isEqual:[NSNull null]])
    {
        self.mPhoneLabel.text = r.phone;
        self.mCallBtn.hidden = NO;
    }
    self.mWorkTimeLabel.text = r.worktime;
    if(![r.desc isEqual:[NSNull null]]){
        NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[r.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.mDescText.attributedText = desc;
        self.mDescText.textAlignment = NSTextAlignmentLeft;
        [self.mDescText setFont:[UIFont systemFontOfSize:14]];
    }
    //self.mDescText.text = r.desc;
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    //NSString *ratingString = [NSString stringWithFormat:@"Rating: %.1f", rating];
    //if( [control isEqual:self.mRatingView] )
    //_starRatingLabel.text = ratingString;
    //else
    [SVProgressHUD show];
    [[HttpApi sharedInstance] doRank:(NSString *)self.mRestaurant.restaurantId
                                mark:(NSNumber* )[NSString stringWithFormat:@"%f", rating]
                           Completed:^(NSDictionary *dic){
                               [SVProgressHUD dismiss];
                               NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                               f.numberStyle = NSNumberFormatterDecimalStyle;
                               NSString* ranking = [dic objectForKey:@"ranking"];
                               NSString* reviews = [dic objectForKey:@"amount"];
                               
                               self.mRateView.rating = [ranking floatValue];
                               self.mReviewLabel.text = [NSString stringWithFormat:@"(%@%@%@)", reviews, @" ", @"reviews"];
                               self.mRateLabel.text = [NSString stringWithFormat:@"%.1f", [ranking floatValue]];
                               self.mRestaurant.ranking =  [NSNumber numberWithFloat:[ranking floatValue]];// [f numberFromString:ranking];
                               
                           }Failed:^(NSString *strError) {
                               [SVProgressHUD showErrorWithStatus:strError];
                           }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)isFavoriteClick:(id)sender {
    [SVProgressHUD show];
    [[HttpApi sharedInstance] updateRestaurantFavoriteByCustomerId:customer.customerId
                                                            RestId:self.mRestaurant.restaurantId
                                                         Completed:^(long is_favorite){
                                                             [SVProgressHUD dismiss];
                                                             
                                                             if(is_favorite) {
                                                                 [self.m_favorite setImage:[UIImage imageNamed:@"hart.png"] forState:UIControlStateNormal];
                                                                 
                                                             } else {
                                                                 [self.m_favorite setImage:[UIImage imageNamed:@"hart_line.png"] forState:UIControlStateNormal];
                                                             }
                                                             self.mRestaurant.isfavorite = [NSNumber numberWithLong:is_favorite];
                                                         }Failed:^(NSString *strError) {
                                                             [SVProgressHUD showErrorWithStatus:strError];
                                                         }];
}

- (IBAction)onNavigateClick:(id)sender {
    [self drawRoute];
}

- (IBAction)onCallClick:(id)sender {
    NSString *phoneNumber = self.mRestaurant.phone;
    //NSArray *tempStr = [phoneNumber componentsSeparatedByString: @"+"];
    NSString *numStr = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
    NSString * newNumber = [numStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *phoneUrl = [NSURL URLWithString:newNumber];
    
    numStr = [NSString stringWithFormat:@"tel://%@", phoneNumber];
    newNumber = [numStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *phoneFallbackUrl = [NSURL URLWithString:newNumber];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else if ([[UIApplication sharedApplication] canOpenURL:phoneFallbackUrl]) {
        [[UIApplication sharedApplication] openURL:phoneFallbackUrl];
    } else{
        //UIAlertView  *calert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        //[calert1 show];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Call facility is not available!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            // Ok action example
        }];        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawRoute
{
    
    NSString *oneLocation = self.mRestaurant.location;
    NSArray* foo = [oneLocation componentsSeparatedByString: @","];
    
    CLLocationCoordinate2D coordinateArray[2];
    //    coordinateArray[0] = self.mHomeCoordinate;
    coordinateArray[1] = CLLocationCoordinate2DMake([foo[0] doubleValue], [foo[1] doubleValue]);
    
    //    MKPlacemark *placemark  = [[MKPlacemark alloc] initWithCoordinate:coordinateArray[0] addressDictionary:nil];
    
    //    m_dest = placemark;
    //    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:m_dest];
    
    MKPlacemark *placemark1  = [[MKPlacemark alloc] initWithCoordinate:coordinateArray[1] addressDictionary:nil];
    m_dest = placemark1;
    
    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:placemark1];
    
    /*switch(_mode){
     case 1://Auto
     [placemark1 openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
     break;
     case 2://walking
     [mapItem1 openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
     break;
     case 3://walking
     [mapItem1 openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit}];
     break;
     case 4://walking
     [mapItem1 openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
     break;
     }*/
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
    renderer.lineWidth = 5.0;
    return renderer;
}
@end
