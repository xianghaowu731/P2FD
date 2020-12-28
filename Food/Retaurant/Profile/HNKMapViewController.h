//
//  HNKMapViewController.h
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Tom OMalley on 8/11/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HNKMapViewController : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D m_CurCoordinate;
- (IBAction)onBackClick:(id)sender;

@end
