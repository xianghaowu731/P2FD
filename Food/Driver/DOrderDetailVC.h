//
//  DOrderDetailVC.h
//  Food
//
//  Created by meixiang wu on 19/09/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import <MapKit/MapKit.h>

@interface DOrderDetailVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *mOrderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *mFirstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mLastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *mInstructionTxt;
@property (weak, nonatomic) IBOutlet UILabel *mResrNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRestEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRestPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRestAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPickTimeLabel;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mMapView;
@property (weak, nonatomic) IBOutlet UILabel *mEstLabel;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onCustomerCall:(id)sender;
- (IBAction)onRestaurantCall:(id)sender;
- (IBAction)onUserMap:(id)sender;
- (IBAction)onRestMap:(id)sender;

@property (strong, nonatomic) Order* data;
@property (strong, nonatomic) NSMutableArray* fooddata;
@end
