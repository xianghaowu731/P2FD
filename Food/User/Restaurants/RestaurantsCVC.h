//
//  RestaurantsCVC.h
//  Food
//
//  Created by weiquan zhang on 6/16/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "RCRTableViewRefreshController.h"
#import <MapKit/MapKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

@interface RestaurantsCVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSMutableArray* data;
@property (strong, nonatomic) NSMutableArray* tempdata;
@property (strong, nonatomic) NSMutableArray* searchResults;
@property (strong, nonatomic) NSMutableArray* mAddressSearchResults;
@property (nonatomic) CLLocationCoordinate2D mMyCoordinate;
@property (nonatomic) NSString *mMyAddress;

@property (nonatomic, strong) RCRTableViewRefreshController *refreshController;

@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;

@property (strong, nonatomic) IBOutlet UIView *mListView;
@property (strong, nonatomic) IBOutlet UIView *mUIView;
@property (strong, nonatomic) IBOutlet MKMapView *mMapView;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (strong, nonatomic) IBOutlet UIButton *mChangeViewBtn;
@property (strong, nonatomic) IBOutlet UISearchBar *mMapSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *mSearchTable;
@property (strong, nonatomic) IBOutlet UIButton *mCartBtn;
@property (strong, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *mPickerView;
@property (weak, nonatomic) IBOutlet UITextField *mFilterText;


- (IBAction)onChangeView:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onCartClick:(id)sender;

@end
