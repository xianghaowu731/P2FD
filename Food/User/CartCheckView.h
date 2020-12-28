//
//  CartCheckView.h
//  Food
//
//  Created by meixiang wu on 7/14/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

@interface CartCheckView : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Restaurant *mRest;
@property (strong, nonatomic) NSMutableArray* data;
@property (nonatomic) float mDeliveryFee;

@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *mAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *mContinueBtn;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UILabel *mTipPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTipPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *mTipFirstBtn;
@property (weak, nonatomic) IBOutlet UIButton *mTipSecondBtn;
@property (weak, nonatomic) IBOutlet UIButton *mTipThirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *mTipForthBtn;
@property (weak, nonatomic) IBOutlet UIButton *mTipCustomBtn;
@property (weak, nonatomic) IBOutlet UIView *mTipBtnView;
//@property (weak, nonatomic) IBOutlet UIView *mSearchView;
@property (weak, nonatomic) IBOutlet UIButton *mHideBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;
@property (strong, nonatomic) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UILabel *mDeliveryLabel;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onDateChangeClick:(id)sender;
- (IBAction)onAddItemsClick:(id)sender;
- (IBAction)onContinueClick:(id)sender;
- (IBAction)onTipCustomClick:(id)sender;
- (IBAction)onTipFirstClick:(id)sender;
- (IBAction)onTipSecondClick:(id)sender;
- (IBAction)onTipThirdClick:(id)sender;
- (IBAction)onTipForthClick:(id)sender;
- (IBAction)onEditAddressClick:(id)sender;
- (IBAction)onHideClick:(id)sender;


@end
