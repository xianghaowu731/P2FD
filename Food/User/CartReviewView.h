//
//  CartReviewView.h
//  Food
//
//  Created by meixiang wu on 7/17/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "UITextView+Placeholder.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
//====================================================================
#import <Stripe/Stripe.h>

typedef NS_ENUM(NSInteger, STPBackendChargeResult) {
    STPBackendChargeResultSuccess,
    STPBackendChargeResultFailure,
};

typedef void (^STPSourceSubmissionHandler)(STPBackendChargeResult status, NSError *error);

@protocol CheckViewControllerDelegate <NSObject>

- (void)checkViewController:(UIViewController *)controller didFinishWithMessage:(NSString *)message;
- (void)checkViewController:(UIViewController *)controller didFinishWithError:(NSError *)error;
- (void)createBackendChargeWithSource:(NSString *)sourceID completion:(STPSourceSubmissionHandler)completion;
@end
//==================================

@interface CartReviewView : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Restaurant *mRest;
@property (strong, nonatomic) NSMutableArray* data;
@property (nonatomic) float mDeliveryFee;
@property (nonatomic) float mtipFee;
@property (weak, nonatomic) IBOutlet UITextField *mUserFirstName;
@property (weak, nonatomic) IBOutlet UITextField *mUserLastName;
@property (weak, nonatomic) IBOutlet UITextField *mUserPhone;
@property (weak, nonatomic) IBOutlet UITextView *mDeliveryAddress;
@property (weak, nonatomic) IBOutlet UITextView *mInstructionText;
@property (weak, nonatomic) IBOutlet UILabel *mDeliveryTime;
//@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *mPlaceBtn;
@property (weak, nonatomic) IBOutlet UIButton *mPayTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *mRestName;
@property (weak, nonatomic) IBOutlet UIImageView *mMarkImg;
@property (weak, nonatomic) IBOutlet UIImageView *mAppleOptionImg;
@property (weak, nonatomic) IBOutlet UIImageView *mCreditOptionImg;
@property (weak, nonatomic) IBOutlet UIView *mCreditCardView;
@property (weak, nonatomic) IBOutlet UIView *mApplePayView;
@property (weak, nonatomic) IBOutlet UIButton *mHideBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;
@property (strong, nonatomic) NSArray *searchResults;

- (IBAction)onAddressEditClick:(id)sender;
- (IBAction)onApplePayClick:(id)sender;
- (IBAction)onCreditPayClick:(id)sender;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onPlaceClick:(id)sender;
- (IBAction)onPayTypeChange:(id)sender;
- (IBAction)onHideViewClick:(id)sender;

@end
