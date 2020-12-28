//
//  CardViewController.h
//  Custom Integration (ObjC)
//
//  Created by Ben Guo on 2/22/17.
//  Copyright © 2017 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckViewControllerDelegate;

@interface CardViewController : UIViewController
- (IBAction)onBackClick:(id)sender;
- (IBAction)onPay:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *mCardImg;
@property (weak, nonatomic) IBOutlet UIView *payTextView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (nonatomic, weak) id<CheckViewControllerDelegate> delegate;

@end
