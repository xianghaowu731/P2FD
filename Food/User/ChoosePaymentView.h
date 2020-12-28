//
//  ChoosePaymentView.h
//  Food
//
//  Created by meixiang wu on 21/07/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePaymentView : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *mAppleImg;
@property (strong, nonatomic) IBOutlet UIImageView *mCardImg;
@property (strong, nonatomic) IBOutlet UIImageView *mDSImg;

- (IBAction)onApplePayClick:(id)sender;
- (IBAction)onCardPayClick:(id)sender;
- (IBAction)onDSPayClick:(id)sender;
-(void)ShowPopover:(UIViewController*)parent ShowAtPoint:(CGPoint)point DismissHandler:(void (^)())block;

@end
