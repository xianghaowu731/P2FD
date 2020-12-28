//
//  DeliverProfile.m
//  Food
//
//  Created by meixiang wu on 21/09/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "DeliverProfile.h"
#import "Config.h"
#import "DownPicker.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "ImageChooser.h"
#import "Common.h"
#import "ChangePasswdVC.h"
#import "HNKMapViewController.h"
#import "AppDelegate.h"

extern Deliver* deliver;

@interface DeliverProfile ()
@property (strong, nonatomic) DownPicker *downPicker;
@property(strong, nonatomic) UIImage* image;
@end

@implementation DeliverProfile{
    ImageChooser* imgChooser;
    NSString* imageUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mDescText.layer;
    [imageLayer setCornerRadius:7];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    self.mDescText.textContainerInset = UIEdgeInsetsMake(20, 10, 10, 10);
    
    CGRect rect = self.mScrollView.frame;
    rect.size.height = 655;
    self.mScrollView.contentSize = rect.size;
    
    NSMutableArray* bandArray = [[NSMutableArray alloc] init];
    
    // add some sample data
    [bandArray addObject:STATUS_OPEN];
    [bandArray addObject:STATUS_CLOSE];
    [bandArray addObject:STATUS_BUSY];
    // bind yourTextField to DownPicker
    self.downPicker = [[DownPicker alloc] initWithTextField:self.mStatusTV withData:bandArray];
    
    g_isUpdatedLocation = false;
    g_address = deliver.address;
    if( [deliver.location length] > 0 ){
        NSArray *foo = [deliver.location componentsSeparatedByString:@","];
        g_longitude = foo[1];
        g_latitude = foo[0];
    }
    
    imageUrl = deliver.img;
    [self setLayout:deliver];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    //[self setLayout:owner];
    if([g_address length] > 0) {
        [self.mLocationBtn setTitle:g_address forState:UIControlStateNormal];
    } else{
        [self.mLocationBtn setTitle:@"Choose your location" forState:UIControlStateNormal];
    }
}


- (void)setLayout:(Deliver*)d {
    
    self.mEmailLabel.text = d.email;
    self.mNameText.text = d.name;
    if(d.worktime == (id)[NSNull null]) d.worktime=@"";
    self.mWorkTimeText.text = d.worktime;
    if(d.phone == (id)[NSNull null]) d.phone = @"";
    self.mPhoneText.text = d.phone;
    if(d.desc == (id)[NSNull null]) d.desc = @"";
    NSAttributedString* desc = [[NSAttributedString alloc] initWithData:[d.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.mDescText.attributedText = desc;
    self.mDescText.textAlignment = NSTextAlignmentLeft;
    [self.mDescText setFont:[UIFont systemFontOfSize:15]];
    if([d.status isEqualToString:STATUS_OPEN])
        [self.downPicker setText:STATUS_OPEN];
    else if([d.status isEqualToString:STATUS_CLOSE])
        [self.downPicker setText:STATUS_CLOSE];
    else
        [self.downPicker setText:STATUS_BUSY];
    NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, RESTAURANT_IMAGE_BASE_URL, d.img];
    [self.mImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    self.image = [self.mImageView image];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onImageBtnClick:(id)sender {
    
    imgChooser = [[ImageChooser alloc] init];
    [imgChooser showActionSheet:self Completed:^(UIImage* img){
        [self.mImageView setImage:img];
        self.image = img;
    }];
}

- (IBAction)onChangePasswdClick:(id)sender {
    ChangePasswdVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChangePasswdVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onLogoutClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onUpdateBtn:(id)sender {
    [SVProgressHUD show];
    UIImage *small = [Common resizeImage:self.image];
    NSData *postData = UIImagePNGRepresentation(small);
    imageUrl = deliver.img;
    [[HttpApi sharedInstance] restImagePost:postData id:deliver.dId Completed:^(NSString *image) {
        imageUrl = image;
        [self updateRest];
    }
                                     Failed:^(NSString *strError) {
                                         //[SVProgressHUD dismiss];
                                         [SVProgressHUD showErrorWithStatus:strError];
                                     }];
    
}

- (IBAction)onLocationPick:(id)sender {
    HNKMapViewController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_HNKMapViewController"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (void) updateRest {
    NSString *m_location = deliver.location;
    if(![g_address isEqualToString:@""]) {
        if(g_isUpdatedLocation) {
            CLLocationCoordinate2D location = [self getLocationFromAddressString:g_address];
            g_latitude = [NSString stringWithFormat:@"%f", location.latitude];
            g_longitude = [NSString stringWithFormat:@"%f", location.longitude];
            NSLog(@"[%@, %@]", g_latitude, g_longitude);
            m_location = [NSString stringWithFormat:@"%@, %@",g_latitude,g_longitude];
            g_isUpdatedLocation = false;
        }
        
        if([self checkProfileInfo]){
            [[HttpApi sharedInstance] uploadRestByRestId:(NSString *)deliver.dId
                                                    name:(NSString *)self.mNameText.text
                                                   email:(NSString *)self.mEmailLabel.text
                                             Description:(NSString *)self.mDescText.text
                                                   phone:(NSString *)self.mPhoneText.text
                                                worktime:(NSString *)self.mWorkTimeText.text
                                                  status:(NSString *)self.mStatusTV.text
                                                   image:(NSString *)imageUrl
                                                 Address:(NSString *)g_address
                                                Location:(NSString *)m_location
                                               Completed:^(NSString *array){
                                                   [SVProgressHUD dismiss];
                                                   //NSDictionary* data = (NSDictionary*) array;
                                                   
                                                   deliver.img = imageUrl;
                                                   deliver.name = self.mNameText.text;
                                                   deliver.email = self.mEmailLabel.text;
                                                   deliver.desc = self.mDescText.text;
                                                   deliver.phone = self.mPhoneText.text;
                                                   deliver.worktime = self.mWorkTimeText.text;
                                                   deliver.status = self.mStatusTV.text;
                                                   [self setLayout:deliver];
                                                   
                                                   UIAlertController * alert=   [UIAlertController
                                                                                 alertControllerWithTitle:@"Success"
                                                                                 message:@"Successfully updted."
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                   
                                                   UIAlertAction* yesButton = [UIAlertAction
                                                                               actionWithTitle:@"Ok"
                                                                               style:UIAlertActionStyleDefault
                                                                               handler:^(UIAlertAction * action)
                                                                               {
                                                                                   ///[self.navigationController popViewControllerAnimated:YES];
                                                                                   
                                                                               }];
                                                   [alert addAction:yesButton];
                                                   [self presentViewController:alert animated:YES completion:nil];
                                                   return;
                                               }Failed:^(NSString *strError) {
                                                   [SVProgressHUD showErrorWithStatus:strError];
                                               }];
        }
    } else {
        [self showAlert:@"Choose the address" Title:@"Alert!"];
    }
    
}

-(BOOL) checkProfileInfo{
    if( [self.mNameText.text length] == 0) {
        [self showAlert:@"Enter the deliver name" Title:@"Warning!"];
        return false;
    } else if([self.mWorkTimeText.text length] == 0){
        [self showAlert:@"Enter the working time" Title:@"Warning!"];
        return false;
    } else if([g_address length] == 0){
        [self showAlert:@"Choose the location" Title:@"Warning!"];
        return false;
    }
    return true;
}

-(void)showAlert:(NSString *)content
           Title:(NSString *)title{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:content
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

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
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
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
}

@end
