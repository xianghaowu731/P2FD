//
//  CartDetailVC.h
//  Food
//
//  Created by weiquan zhang on 6/27/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface CartDetailVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray* data;
@property (strong, nonatomic) NSString* restId;
@property (strong, nonatomic) UINavigationController* navigationController;
@property (nonatomic) Restaurant *mRest;


@property (strong, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

- (IBAction)onOrderClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onDeleteClick:(id)sender;

@end
