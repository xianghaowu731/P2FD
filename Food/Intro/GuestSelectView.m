//
//  GuestSelectView.m
//  Food
//
//  Created by meixiang wu on 7/3/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "GuestSelectView.h"
#import "AppDelegate.h"
#import "CLPlacemark+HNKAdditions.h"
#import <SVProgressHUD.h>

static NSString *const kHNKDemoSearchResultsCellIdentifier = @"AddressSearchResultsCellIdentifier";
@interface GuestSelectView ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>{
    CLLocationManager *m_locationManager;
    CLLocationCoordinate2D mMyCoordinate;
}

@end

@implementation GuestSelectView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    
    //Location Manager
    m_locationManager = [[CLLocationManager alloc] init];
    m_locationManager.delegate = self;
    m_locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    m_locationManager.distanceFilter = kCLDistanceFilterNone;//100;
    /*if([m_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [m_locationManager requestAlwaysAuthorization];
    }*/
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        if([m_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [m_locationManager requestWhenInUseAuthorization];
        }
    }
    [m_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSearchLocationClick:(id)sender {
    [self getAddressFromLocation:mMyCoordinate];
}

- (void)goUserTabView{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_CustomerTabBar"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getAddressFromLocation:(CLLocationCoordinate2D)location {
    [SVProgressHUD showWithStatus:@"Getting Address..."];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude]; //insert your coordinates
    
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  if (placemark) {
                      [SVProgressHUD dismiss];
                      NSLog(@"placemark %@",placemark);
                      //String to hold address
                      NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                      //Print the location to console
                      NSLog(@"I am currently at %@",locatedAt);
                      g_address = locatedAt;
                      g_latitude = [NSString stringWithFormat:@"%f", mMyCoordinate.latitude];
                      g_longitude = [NSString stringWithFormat:@"%f", mMyCoordinate.longitude];
                      [self goUserTabView];
                      
                  }
                  else {
                      [SVProgressHUD dismiss];
                      UIAlertController * alert=   [UIAlertController
                                                    alertControllerWithTitle:@"Warning!"
                                                    message:@"App can not find your address from location. Please try again."
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
              }
     ];
}

#pragma mark - LOCATION MANAGER

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    mMyCoordinate = location.coordinate;
}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHNKDemoSearchResultsCellIdentifier forIndexPath:indexPath];
    
    HNKGooglePlacesAutocompletePlace *thisPlace = self.searchResults[indexPath.row];
    cell.textLabel.text = thisPlace.name;
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                                           [self goUserTabView];
                                           
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

@end
