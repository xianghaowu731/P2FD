//
//  RestaurantsCVC.m
//  Food
//
//  Created by weiquan zhang on 6/16/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "RestaurantsCVC.h"
#import "Config.h"
#import "Common.h"
#import "RestaurantCTVC.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "Customer.h"
#import "FMDBHelper.h"
#import "CartListVC.h"
#import "ZSAnnotation.h"
#import "ZSPinAnnotation.h"
#import "RestaurantCVC.h"
#import "RestaurantMCVC.h"
#import "CLPlacemark+HNKAdditions.h"
#import "RatingReviewVC.h"


extern FMDBHelper *helper;
extern Customer* customer;

static NSString *const kHNKDemoSearchResultsCellIdentifier = @"HNKDemoSearchResultsCellIdentifier";

@interface RestaurantsCVC() <MKMapViewDelegate, MKOverlay, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{
    BOOL bListView;
    NSMutableArray *m_annotations;
    MKPlacemark *m_dest,*m_sour;
    NSInteger m_selInd;
    NSArray *pickerData;
    NSInteger mFilterInd;
    UIImage *cartImg;
}

@end


@implementation RestaurantsCVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bListView = true;
    self.mMapView.delegate = self;
    //============Search Address =======================
    self.mMapSearchBar.delegate = self;
    self.mSearchTable.delegate = self;
    self.mSearchTable.dataSource = self;
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    //===================================================
    self.mMyAddress = g_address;
    CLLocationDegrees onelat = [g_latitude floatValue];
    CLLocationDegrees onelon = [g_longitude floatValue];
    self.mMyCoordinate = CLLocationCoordinate2DMake(onelat, onelon);
    //======================================================
    pickerData = @[@"Restaurant Name", @"Delivery Fee", @"Star Rating", @"Reviews"];
    self.mPickerView.delegate = self;
    self.mPickerView.dataSource = self;
    self.mFilterText.delegate = self;
    self.mPickerView.hidden = true;
    mFilterInd = 0;
    self.mFilterText.text = pickerData[mFilterInd];
    //=================================================================
    cartImg = [Common imageWithImage:[UIImage imageNamed:@"ic_cart"] scaledToSize:CGSizeMake(28.0, 28.0)];
    [self.mCartBtn setImage:cartImg forState:UIControlStateNormal];
    //[self getData];
    self.data = [[NSMutableArray alloc] init];
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.data count]];
    
    self.refreshController = [[RCRTableViewRefreshController alloc] initWithTableView:self.mTableView refreshHandler:^{
        [self getData];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rChangeFavorite:) name:@"RChangedFavorite" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveReviewClick:)
                                                 name:NOTIFICATION_REVIEW_VIEW
                                               object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) viewWillAppear:(BOOL)animated {
    helper = [FMDBHelper sharedInstance];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [helper getAllOrders];
    int count = 0;
    for(int i=0;i<array.count; i++){
        Food* f = [[Food alloc] init];
        f = array[i];
        count += [f.count intValue];
    }
    
    [self.mCartBtn setTitle:[NSString stringWithFormat:@" (%d)", count] forState:UIControlStateNormal];
    //[customButton sizeToFit];
    //[customButton addTarget:self action:@selector(onCartIconClick:) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    //self.navigationItem.rightBarButtonItem = customBarButtonItem;
    //[self.navigationItem.rightBarButtonItem setTarget:self];
    //[self.navigationItem.rightBarButtonItem setAction:@selector(onCartIconClick:)];
    [self getData];
    if(bListView){
        self.mTitleLabel.text = @"List";
        self.mUIView.hidden = YES;
        self.mListView.hidden = NO;
        //[self.mChangeViewBtn setImage:[UIImage imageNamed:@"ic_list_btn.png"] forState:UIControlStateNormal];
    }else{
        //self.navigationController.navigationBar.topItem.title = @"Map";
        self.mTitleLabel.text = @"Map";
        self.mUIView.hidden = NO;
        self.mListView.hidden = YES;
        //[self.mChangeViewBtn setImage:[UIImage imageNamed:@"ic_map_btn.png"] forState:UIControlStateNormal];
    }
}

- (void)rChangeFavorite:(NSNotification*)msg{
    
    NSDictionary* dic = msg.userInfo;
    NSNumber* objectID = dic[@"cellTag"];
    NSNumber* isfavorite = dic[@"isfavorite"];
    ((Restaurant*)(self.data[[objectID longValue]])).isfavorite = isfavorite;
    
}

- (void)receiveReviewClick:(NSNotification*)msg{
    NSDictionary* dic = msg.userInfo;
    Restaurant *sel_rest = [dic objectForKey:@"rest"];
    if(![customer.customerId isEqualToString:@"0"]){
        RatingReviewVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_RatingReviewVC"];
        mVC.mRestaurant = sel_rest;
        [self.navigationController pushViewController:mVC animated:YES];
    }
}

- (void)getData{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getRestByCustomerId:(NSString *)customer.customerId
                                            Completed:^(NSArray *array){
                                               [SVProgressHUD dismiss];
                                               
                                                self.tempdata = [[NSMutableArray alloc] init];
                                                for(int i=0;i<array.count;i++){
                                                    Restaurant* rest = [[Restaurant alloc] initWithDictionary:array[i]];
                                                    if([rest.address length] > 0)
                                                        [self.tempdata addObject:rest];
                                                }
                                                self.data = [NSMutableArray arrayWithArray:self.tempdata];
                                                g_Restaurants = self.data;
                                                [self setAnnotation];
                                                [self filterData];
                                                [self.mTableView reloadData];
                                                
                                           }Failed:^(NSString *strError) {
                                               [SVProgressHUD showErrorWithStatus:strError];
                                           }];
    [self dataHasRefreshed];
    
}

- (void) refreshData{
    [self setAnnotation];
    [self filterData];
    [self.mTableView reloadData];
}

- (void)filterData{
    if(mFilterInd == 0){
        self.data = [NSMutableArray arrayWithArray:self.tempdata];
    } else{
        [self sortData];
    }
}

- (void)sortData{
    NSArray *sortedArray = [self.data sortedArrayUsingComparator:^NSComparisonResult(Restaurant *firstObject, Restaurant *secondObject) {
        switch (mFilterInd) {
            case 1:
                if(firstObject.mDistance == 0)
                    return NSOrderedDescending;
                else if(secondObject.mDistance == 0)
                    return NSOrderedAscending;
                else if (firstObject.mDistance < secondObject.mDistance)
                    return NSOrderedAscending;
                else if (firstObject.mDistance > secondObject.mDistance)
                    return NSOrderedDescending;
                else
                    return NSOrderedSame;
                break;
            case 2:
                if ([firstObject.ranking floatValue]< [secondObject.ranking floatValue])
                    return NSOrderedAscending;
                else if ([firstObject.ranking floatValue]> [secondObject.ranking floatValue])
                    return NSOrderedDescending;
                else
                    return NSOrderedSame;
                break;
            case 3:
                if (firstObject.reviews < secondObject.reviews)
                    return NSOrderedAscending;
                else if (firstObject.reviews > secondObject.reviews)
                    return NSOrderedDescending;
                else
                    return NSOrderedSame;
                break;
            default:
                return NSOrderedSame;
        }
    }];
    [self.data setArray:sortedArray];
}

- (void)dataHasRefreshed {
    // Ensure we're on the main queue as we'll be updating the UI (not strictly necessary for this example, but will likely be essential in less trivial scenarios and so is included for illustrative purposes)
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // At some point later, when we're done getting our new data, tell our refresh controller to end refreshing
        [self.refreshController endRefreshing];
        
        // Finally get the table view to reload its data
        [self.mTableView reloadData];
        
    });
}

- (void) dismissKeyboard{
    [self.mSearchBar resignFirstResponder];
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.mFilterText.text = pickerData[row];
    mFilterInd = row;
    self.mPickerView.hidden = true;
    [self filterData];
    [self.mTableView reloadData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.mFilterText) {
        self.mPickerView.hidden = false;
        self.mFilterText.text = @"";
        [self textFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //=========Search Address =============
    if(tableView == self.mSearchTable){
        return self.mAddressSearchResults.count;
    }
    //======================================
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    } else {
        return [self.data count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //========== Search Address ====================
    if(tableView == self.mSearchTable)
        return 44;
    else
        return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //========== Search Address ====================
    if(tableView == self.mSearchTable){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHNKDemoSearchResultsCellIdentifier forIndexPath:indexPath];
        
        HNKGooglePlacesAutocompletePlace *thisPlace = self.mAddressSearchResults[indexPath.row];
        cell.textLabel.text = thisPlace.name;
        return cell;
    }
    //-----------------------------------------------
    else{
        RestaurantCTVC *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_RestaurantCTVC" forIndexPath:indexPath];
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            [cell setLayout:self.searchResults[indexPath.row]];
        } else {
            Restaurant* r = self.data[indexPath.row];
            r.cID = [NSNumber numberWithLong:indexPath.row];
            [cell setLayout:self.data[indexPath.row]];
        }
        
        return cell;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //========== Search Address ====================
    if(tableView == self.mSearchTable){
        [self.mMapSearchBar setShowsCancelButton:NO animated:YES];
        [self.mMapSearchBar resignFirstResponder];
        
        HNKGooglePlacesAutocompletePlace *selectedPlace = self.mAddressSearchResults[indexPath.row];
        
        [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace
                                           apiKey: self.searchQuery.apiKey
                                       completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
                                           if (placemark) {
                                               [self.mSearchTable setHidden: YES];
                                               self.mMyAddress = addressString;
                                               self.mMyCoordinate = placemark.location.coordinate;
                                               g_address = addressString;
                                               g_latitude = [NSString stringWithFormat:@"%f", self.mMyCoordinate.latitude];
                                               g_longitude = [NSString stringWithFormat:@"%f", self.mMyCoordinate.longitude];
                                               [self addPlacemarkAnnotationToMap:placemark addressString:addressString];
                                               [self recenterMapToPlacemark:placemark];
                                               [self.mSearchTable deselectRowAtIndexPath:indexPath animated:NO];
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
    //---------------------------------------------
    else{
        //RestaurantCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_RestaurantCVC"];
        RestaurantMCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_RestaurantMCVC"];
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            mVC.mRestaurant = self.searchResults[indexPath.row];
        } else {
            mVC.mRestaurant = self.data[indexPath.row];
        }
        
        [self.navigationController pushViewController:mVC animated:YES];
    }
    
}

#pragma mark - UISearchBar Delegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if(searchBar == self.mMapSearchBar)
        [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchBar == self.mMapSearchBar){
        if(searchText.length > 0)
        {
            [self.mSearchTable setHidden:NO];
            [self.searchQuery fetchPlacesForSearchQuery: searchText
                                             completion:^(NSArray *places, NSError *error) {
                                                 if (error) {
                                                     NSLog(@"ERROR: %@", error);
                                                     [self handleSearchError:error];
                                                 } else {
                                                     self.mAddressSearchResults = [[NSMutableArray alloc] initWithArray:places];
                                                     [self.mSearchTable reloadData];
                                                 }
                                             }];
        }
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if(searchBar == self.mMapSearchBar){
        searchBar.text = @"";
        [searchBar setShowsCancelButton:NO animated:YES];
        [searchBar resignFirstResponder];
        [self.mSearchTable setHidden:YES];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    if(bListView){
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
        self.searchResults = [[NSMutableArray alloc] initWithArray:[self.data filteredArrayUsingPredicate:resultPredicate]];
    }
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if(bListView){
        [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    }
    
    return YES;
}


- (void)onCartIconClick:(id)sender {
    CartListVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartListVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}
- (IBAction)onChangeView:(id)sender {
    bListView = !bListView;
    if(bListView){
        self.mTitleLabel.text = @"List";
        self.mUIView.hidden = YES;
        self.mListView.hidden = NO;
    } else {
        self.mTitleLabel.text = @"Map";
        self.mUIView.hidden = NO;
        self.mListView.hidden = YES;
    }
}

- (IBAction)onBackClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_InitNC"];
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (IBAction)onCartClick:(id)sender {
    CartListVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartListVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

-(void) setAnnotation{
    if(m_annotations.count > 0)
        [self.mMapView removeAnnotations:m_annotations];
    m_annotations = [[NSMutableArray alloc] init];
    for(int i= 0 ; i < self.data.count ; i++)
    {
        Restaurant *one = [[Restaurant alloc] init];
        one = self.data[i];
        if([one.address length] > 0 && [one.location length] == 0) {
            CLLocationCoordinate2D otherloc = [self getLocationFromAddressString:one.address];
            one.location = [NSString stringWithFormat:@"%f,%f", otherloc.latitude, otherloc.longitude];
            if(otherloc.latitude==0 && otherloc.longitude==0){
                one.location = @"";
            }
        }
        
        if([one.address length] >0 && [one.location length] > 0 )
        {
            //========calculation distance
            if([self.mMyAddress length] != 0){
                CLLocationDegrees onelat = [g_latitude floatValue];
                CLLocationDegrees onelon = [g_longitude floatValue];
                CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:onelat longitude:onelon];
                NSArray *foo1 = [one.location componentsSeparatedByString: @","];
                CLLocationDegrees otherlat = [foo1[0] floatValue];
                CLLocationDegrees otherlon = [foo1[1] floatValue];
                CLLocation *oneLocation = [[CLLocation alloc] initWithLatitude:otherlat longitude:otherlon];
                CLLocationDistance distance = [myLocation distanceFromLocation:oneLocation] * 1.323;
                one.mDistance = fabs(distance);
                
                [[HttpApi sharedInstance] getLocationByRestId:one.restaurantId Location:one.location
                                                    Completed:^(NSString *array){
                                                    }Failed:^(NSString *strError) {
                                                    }];
            }
            
            NSString *oneLocation = one.location;
            NSArray* foo = [oneLocation componentsSeparatedByString: @","];
            ZSAnnotation *annotation = [[ZSAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake([foo[0] doubleValue], [foo[1] doubleValue]);
            annotation.color = ANNOTATION_RESTAURANT_COLOR;
            annotation.type = ZSPinAnnotationTypeStandard;
            annotation.title = one.name;
            annotation.subtitle = one.status;
            
            annotation.tag = i;
            
            [self.mMapView addAnnotation:annotation];
            [m_annotations addObject:annotation];
        }
    }
    //========center position ==============
    //NSString *latitude = @"49.0611";
    //NSString *longitude = @"15.9000";
    //self.mHomeCoordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        
    if([self.mMyAddress length] != 0){
        [self.mMapView setCenterCoordinate:self.mMyCoordinate animated:NO];
        
        MKCoordinateRegion region = MKCoordinateRegionMake(self.mMyCoordinate, MKCoordinateSpanMake(0.5, 0.5));
        
        MKCoordinateRegion adjustedRegion = [self.mMapView regionThatFits:region];
        [self.mMapView setRegion:adjustedRegion animated:YES];
        
        ZSAnnotation *annotationC = [[ZSAnnotation alloc] init];
        annotationC.coordinate = self.mMyCoordinate;
        annotationC.color = ANNOTATION_SELF_COLOR;
        annotationC.type = ZSPinAnnotationTypeDisc;//ZSPinAnnotationTypeTag;
        annotationC.title = self.mMyAddress;
        annotationC.subtitle = @"Current Location";
        annotationC.tag = -1;
        [self.mMapView addAnnotation:annotationC];
        [m_annotations addObject:annotationC];
    }
    
    [self.mMapView showAnnotations:m_annotations animated:YES];
    [self.mTableView reloadData];
}

#pragma mark - MapKit

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // Don't mess with user location
    if(![annotation isKindOfClass:[ZSAnnotation class]])
        return nil;
    
    ZSAnnotation *a = (ZSAnnotation *)annotation;
    static NSString *defaultPinID = @"StandardIdentifier";
    
    // Create the ZSPinAnnotation object and reuse it
    ZSPinAnnotation *pinView = (ZSPinAnnotation *)[self.mMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (pinView == nil){
        pinView = [[ZSPinAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    
    // Set the type of pin to draw and the color
    pinView.annotationType = a.type;
    pinView.annotationColor = a.color;
    pinView.tag = a.tag;
    
    //========default  =====================================
    UIButton *disclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [disclosure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disclosureTapped)]];
    pinView.rightCalloutAccessoryView = disclosure;
    
    //[pinView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disclosureTapped)]];
    
    pinView.canShowCallout = YES;
    
    return pinView;
}

- (void)disclosureTapped{
    if(m_selInd == -1) return;
    //RestaurantCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_RestaurantCVC"];
    RestaurantMCVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_RestaurantMCVC"];
    mVC.mRestaurant = self.data[m_selInd];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSInteger index = view.tag;
    if(index == -1)
        return;
    m_selInd = index;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        routeRenderer.lineWidth = 5.0;
        [self.mMapView setVisibleMapRect:route.boundingMapRect animated:YES];
        return routeRenderer;
    }
    else return nil;
}

#pragma mark - Helpers

- (void)addPlacemarkAnnotationToMap:(CLPlacemark *)placemark addressString:(NSString *)address
{
    [self.mMapView removeAnnotations:self.mMapView.annotations];
    
    [self setAnnotation];
}

- (void)recenterMapRegion:(CLLocationCoordinate2D)location
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.5;
    span.longitudeDelta = 0.5;
    
    region.span = span;
    region.center = location;
    
    [self.mMapView setRegion:region animated:YES];
}

- (void)recenterMapToPlacemark:(CLPlacemark *)placemark
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 1.0;
    span.longitudeDelta = 1.0;
    
    region.span = span;
    region.center = placemark.location.coordinate;
    
    [self.mMapView setRegion:region animated:YES];
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

- (void) getAddressFromLocation:(CLLocationCoordinate2D)location {
    [SVProgressHUD showWithStatus:@"Getting Address"];
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
                      self.mMyAddress = locatedAt;
                      g_address = self.mMyAddress;
                      g_latitude = [NSString stringWithFormat:@"%f", self.mMyCoordinate.latitude];
                      g_longitude = [NSString stringWithFormat:@"%f", self.mMyCoordinate.longitude];
                      [self setAnnotation];
                  }
                  else {
                      [SVProgressHUD dismiss];
                  }
              }
     ];
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

@end
