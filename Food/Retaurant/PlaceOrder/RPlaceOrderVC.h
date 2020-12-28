//
//  RPlaceOrderVC.h
//  Food
//
//  Created by meixiang wu on 24/02/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+Placeholder.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

@interface RPlaceOrderVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *mCartBtn;
@property (weak, nonatomic) IBOutlet UIView *mCateView;
@property (weak, nonatomic) IBOutlet UITextField *mToFirstNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mToLastNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mToPhoneTxt;
@property (weak, nonatomic) IBOutlet UITextView *mToAddressTxt;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *mHideBtn;
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;
@property (strong, nonatomic) NSArray *searchResults;
@property (nonatomic) UIImage *cartImg;
@property (nonatomic) NSInteger cartCount;

- (IBAction)onAddressEditClick:(id)sender;
- (IBAction)onCartClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onHideSearchView:(id)sender;
@end
