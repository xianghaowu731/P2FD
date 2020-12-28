//
//  CardViewController.m
//  Custom Integration (ObjC)
//
//  Created by Ben Guo on 2/22/17.
//  Copyright © 2017 Stripe. All rights reserved.
//

#import <Stripe/Stripe.h>
#import "CardViewController.h"
#import "CartReviewView.h"

/**
 This example demonstrates creating a payment with a credit/debit card. It creates a token
 using card information collected with STPPaymentCardTextField, and then sends the token
 to our example backend to create the charge request.
 */
@interface CardViewController () <STPPaymentCardTextFieldDelegate>
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;
@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    STPPaymentCardTextField *paymentTextField = [[STPPaymentCardTextField alloc] init];
    paymentTextField.delegate = self;
    paymentTextField.cursorColor = [UIColor purpleColor];
    //paymentTextField.postalCodeEntryEnabled = YES;
    self.paymentTextField = paymentTextField;
    [self.paymentTextField setFrame:CGRectMake(0, 0, self.payTextView.frame.size.width, self.payTextView.frame.size.height)];
    [self.payTextView addSubview:paymentTextField];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator = activityIndicator;
    [self.view addSubview:activityIndicator];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat padding = 15;
    CGRect bounds = self.view.bounds;
    self.activityIndicator.center = CGPointMake(CGRectGetMidX(bounds),
                                                CGRectGetMaxY(self.paymentTextField.frame) + padding*2);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.paymentTextField becomeFirstResponder];
}

- (void)paymentCardTextFieldDidChange:(nonnull STPPaymentCardTextField *)textField {
    
}


- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPay:(id)sender {
    if (![self.paymentTextField isValid]) {
        return;
    }
    if (![Stripe defaultPublishableKey]) {
        [self.delegate checkViewController:self didFinishWithMessage:@"Please set a Stripe Publishable Key in Config.h"];
        return;
    }
    [self.activityIndicator startAnimating];
    [[STPAPIClient sharedClient] createTokenWithCard:self.paymentTextField.cardParams
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
                                                  [self.delegate checkViewController:self didFinishWithError:error];
                                              }
                                              [self.delegate createBackendChargeWithSource:token.tokenId completion:^(STPBackendChargeResult result, NSError *error) {
                                                  if (error) {
                                                      [self.delegate checkViewController:self didFinishWithError:error];
                                                      return;
                                                  }
                                                  [self.delegate checkViewController:self didFinishWithMessage:@"Payment successfully created"];
                                              }];
                                          }];
}

- (void)paymentContextDidChange:(STPPaymentContext *)paymentContext {
    //self.activityIndicator.animating = paymentContext.loading;
    self.payButton.enabled = paymentContext.selectedPaymentMethod != nil;
    //self.paymentLabel.text = paymentContext.selectedPaymentMethod.label;
    self.mCardImg.image = paymentContext.selectedPaymentMethod.image;
}
@end
