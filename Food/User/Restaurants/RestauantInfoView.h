//
//  RestauantInfoView.h
//  Food
//
//  Created by meixiang wu on 6/2/17.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "EDStarRating.h"
#import <MapKit/MapKit.h>

@interface RestauantInfoView : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mMapView;
@property (strong, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) IBOutlet UILabel *mEmailLabel;
@property (strong, nonatomic) IBOutlet UILabel *mPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *mWorkTimeLabel;
@property (strong, nonatomic) IBOutlet UITextView *mDescText;
@property (strong, nonatomic) IBOutlet UILabel *mAddress;
@property (strong, nonatomic) IBOutlet EDStarRating *mRateView;
@property (strong, nonatomic) IBOutlet UILabel *mRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *mReviewLabel;
@property (strong, nonatomic) IBOutlet UIButton *m_favorite;
@property (strong, nonatomic) IBOutlet UIButton *mCallBtn;
@property (strong, nonatomic) IBOutlet UILabel *mTitleLabel;

@property (strong, nonatomic) Restaurant *mRestaurant;
@property (strong, nonatomic) NSArray *colors;

- (IBAction)isFavoriteClick:(id)sender;
- (IBAction)onNavigateClick:(id)sender;
- (IBAction)onCallClick:(id)sender;
- (IBAction)onBackClick:(id)sender;

@end
