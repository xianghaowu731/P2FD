//
//  HNKMapViewController.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Tom OMalley on 8/11/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "HNKMapViewController.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <MapKit/MapKit.h>

#import "CLPlacemark+HNKAdditions.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

static NSString *const kHNKDemoSearchResultsCellIdentifier = @"HNKDemoSearchResultsCellIdentifier";

@interface HNKMapViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation HNKMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    [self.mapView setDelegate:self];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    
    [self.mapView addGestureRecognizer:lpgr];
    
    if (![g_latitude isEqualToString:@""] && ![g_longitude isEqualToString:@""]) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(g_latitude.doubleValue, g_longitude.doubleValue);
        annotation.coordinate = location;
        if (![g_address isEqualToString:@""]) {
            annotation.title = g_address;
        }
        [self.mapView addAnnotation:annotation];
        [self recenterMapRegion:location];
    } else if (self.m_CurCoordinate.latitude != 0 && self.m_CurCoordinate.longitude != 0) {
        
        [self getAddressFromLocation:self.m_CurCoordinate];
        
        /*[self.mapView removeAnnotations:self.mapView.annotations];
         MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
         CLLocationCoordinate2D location = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
         annotation.coordinate = location;
         if (![g_address isEqualToString:@""]) {
         annotation.title = g_address;
         }
         [self.mapView addAnnotation:annotation];
         [self recenterMapRegion:location];*/
    }
    
    [self showToast:@"Please search address or choose location manually on the map."];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)showToast:(NSString *)content{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:content
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    int duration = 3; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    [self getAddressFromLocation:touchMapCoordinate];
}

- (void) getAddressFromLocation:(CLLocationCoordinate2D)location {
    [SVProgressHUD show];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude]; //insert your coordinates
    
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  if (placemark) {
                      
                      
                      NSLog(@"placemark %@",placemark);
                      //String to hold address
                      NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                      NSLog(@"addressDictionary %@", placemark.addressDictionary);
                      
                      NSLog(@"placemark %@",placemark.region);
                      NSLog(@"placemark %@",placemark.country);  // Give Country Name
                      NSLog(@"placemark %@",placemark.locality); // Extract the city name
                      NSLog(@"location %@",placemark.name);
                      NSLog(@"location %@",placemark.ocean);
                      NSLog(@"location %@",placemark.postalCode);
                      NSLog(@"location %@",placemark.subLocality);
                      
                      NSLog(@"location %@",placemark.location);
                      //Print the location to console
                      NSLog(@"I am currently at %@",locatedAt);
                      
                      [self.mapView removeAnnotations:self.mapView.annotations];
                      MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                      annotation.coordinate = location;
                      annotation.title = locatedAt;
                      
                      [self.mapView addAnnotation:annotation];
                      [self recenterMapRegion:location];
                      g_address = locatedAt;
                      g_latitude = [NSString stringWithFormat:@"%f", location.latitude];
                      g_longitude = [NSString stringWithFormat:@"%f", location.longitude];
                      g_isUpdatedLocation = true;
                      [SVProgressHUD dismiss];
                  }
                  else {
                      [SVProgressHUD dismiss];
                      UIAlertController * alert=   [UIAlertController
                                                    alertControllerWithTitle:@"Warning!"
                                                    message:@"Google can not find address from your location. Please choose nearby location"
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
                                           [self addPlacemarkAnnotationToMap:placemark addressString:addressString];
                                           [self recenterMapToPlacemark:placemark];
                                           g_address = addressString;
                                           g_isUpdatedLocation = true;
                                           [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                                       }  else {
                                           UIAlertController * alert=   [UIAlertController
                                                                         alertControllerWithTitle:@"Warning!"
                                                                         message:@"Google can not find location from your address. Please choose location manually on the map"
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
                                       [SVProgressHUD dismiss];
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

#pragma mark - Helpers

- (void)addPlacemarkAnnotationToMap:(CLPlacemark *)placemark addressString:(NSString *)address
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = placemark.location.coordinate;
    annotation.title = address;
    
    [self.mapView addAnnotation:annotation];
}

- (void)recenterMapRegion:(CLLocationCoordinate2D)location
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    
    region.span = span;
    region.center = location;
    
    [self.mapView setRegion:region animated:YES];
}

- (void)recenterMapToPlacemark:(CLPlacemark *)placemark
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    
    region.span = span;
    region.center = placemark.location.coordinate;
    
    [self.mapView setRegion:region animated:YES];
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

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
