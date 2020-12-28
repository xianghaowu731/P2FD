//
//  CartTVC.h
//  Food
//
//  Created by weiquan zhang on 6/27/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderGroup.h"
#import "Restaurant.h"

@interface CartTVC : UITableViewCell

@property(nonatomic, strong) OrderGroup* data;
- (void) setLayout:(OrderGroup*)f;

@property (nonatomic) Restaurant *orderRest;

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mRestName;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
- (IBAction)onRemoveClick:(id)sender;

@end
