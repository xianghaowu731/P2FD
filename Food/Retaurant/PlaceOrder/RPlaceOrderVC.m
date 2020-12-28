//
//  RPlaceOrderVC.m
//  Food
//
//  Created by meixiang wu on 24/02/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import "RPlaceOrderVC.h"
#import "Restaurant.h"
#import "FMDBHelper.h"
#import "AppDelegate.h"
#import <CLPlacemark+HNKAdditions.h>
#import "Common.h"
#import "UserCategoryView.h"
#import "CartDetailVC.h"
#import "Customer.h"

extern Customer *customer;
extern Restaurant *owner;
extern FMDBHelper *helper;

static NSString *const kHNKDemoSearchResultsCellIdentifier = @"AddressSearchResultsCellIdentifier";

@interface RPlaceOrderVC ()<UISearchBarDelegate>

@end

@implementation RPlaceOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAddOrder:) name:@"PlusOrder" object:nil];
    
    customer = [[Customer alloc] init];
    customer.customerId = owner.restaurantId;
    customer.userName = owner.name;
    customer.firstName = @"";
    customer.lastName = @"";
    customer.email = owner.email;
    customer.phone = owner.phone;
    customer.address = owner.address;
    
    self.searchBar.hidden = YES;
    self.mHideBtn.hidden = YES;
    self.searchBar.delegate = self;
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    self.mToAddressTxt.placeholder = @"Street, Address, City, State";
    
    CALayer *imageLayer = self.mToAddressTxt.layer;
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor blackColor].CGColor];
    
    imageLayer = self.tableView.layer;
    [imageLayer setBorderWidth:1];
    [imageLayer setCornerRadius:5];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor grayColor].CGColor];
    
    self.cartImg = [Common imageWithImage:[UIImage imageNamed:@"ic_cart"] scaledToSize:CGSizeMake(28.0, 28.0)];
    [self.mCartBtn setImage:self.cartImg forState:UIControlStateNormal];
    self.cartCount = 0;  
    
    UserCategoryView *userTreeview = [[UserCategoryView alloc] init];
    userTreeview.mRestaurant = owner;
    [self addChildViewController:userTreeview];
    CGRect frame = userTreeview.view.frame;
    frame.size.height = self.mCateView.bounds.size.height;
    userTreeview.view.frame = frame;//[[UIScreen mainScreen] bounds];
    [self.mCateView addSubview:userTreeview.view];
    [userTreeview didMoveToParentViewController:self];
    [self setLayout];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [self setLayout];
}

- (void)viewWillDisappear
{
    g_toPhone = self.mToPhoneTxt.text;
    g_toFirst = self.mToFirstNameTxt.text;
    g_toLast = self.mToLastNameTxt.text;    
}

-(void) receiveAddOrder:(NSNotification *)notification{
    [self setLayout];
}

- (void)setLayout{
    helper = [FMDBHelper sharedInstance];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [helper getOrdersByRestID:owner.restaurantId];
    int count = 0;
    for(int i=0;i<array.count; i++){
        Food* f = [[Food alloc] init];
        f = array[i];
        if([f.restId isEqualToString:owner.restaurantId])
            count += [f.count intValue];
    }
    [self.mCartBtn setTitle:[NSString stringWithFormat:@" (%d)", count] forState:UIControlStateNormal];
    self.cartCount = count;
    if(g_isMistakeOrder){
        self.mToPhoneTxt.text = g_toPhone;
        self.mToFirstNameTxt.text = g_toFirst;
        self.mToLastNameTxt.text = g_toLast;
        self.mToAddressTxt.text = g_address;
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

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHNKDemoSearchResultsCellIdentifier forIndexPath:indexPath];
    
    HNKGooglePlacesAutocompletePlace *thisPlace = self.searchResults[indexPath.row];
    cell.textLabel.text = thisPlace.name;
    return cell;
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
                                           [self.tableView setHidden: YES];
                                           if (placemark) {
                                               g_address = addressString;
                                               g_latitude = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
                                               g_longitude = [NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
                                               [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                                               self.mToAddressTxt.text = g_address;
                                               g_isRestOrder = true;
                                               g_toPhone = self.mToPhoneTxt.text;
                                               g_toFirst = self.mToFirstNameTxt.text;
                                               g_toLast = self.mToLastNameTxt.text;
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
//==============================================

- (IBAction)onAddressEditClick:(id)sender {
    self.searchBar.hidden = NO;
    self.mHideBtn.hidden = NO;
}

- (IBAction)onCartClick:(id)sender {
    if(self.cartCount == 0) return;
    g_isRestOrder = true;
    g_toPhone = self.mToPhoneTxt.text;
    g_toFirst = self.mToFirstNameTxt.text;
    g_toLast = self.mToLastNameTxt.text;
    CartDetailVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CartDetailVC"];
    mVC.navigationController = self.navigationController;
    mVC.restId = owner.restaurantId;
    mVC.mRest = owner;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onBackClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_InitNC"];
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (IBAction)onHideSearchView:(id)sender {
    self.searchBar.hidden = YES;
    self.mHideBtn.hidden = YES;
    self.tableView.hidden = YES;
}
@end
