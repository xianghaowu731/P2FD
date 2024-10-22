//
//  Card3DSViewController.m
//  Custom Integration (ObjC)
//
//  Created by Ben Guo on 2/22/17.
//  Copyright © 2017 Stripe. All rights reserved.
//

#import <Stripe/Stripe.h>
#import "ThreeDSViewController.h"
#import "CartReviewView.h"

/**
 This example demonstrates using Sources to accept card payments verified using 3D Secure. First, we
 create a Source using card information collected with STPPaymentCardTextField. If the card Source
 indicates that 3D Secure is required, we create a 3D Secure Source and redirect the user to authorize the payment. 
 Otherwise, we send the ID of the card Source to our example backend to create the charge request.
 
 Because 3D Secure payments require further action from the user, we don't tell our backend to create a charge 
 request after creating a 3D Secure Source. Instead, your backend should listen to the `source.chargeable` webhook 
 event to charge the 3D Secure source. See https://stripe.com/docs/sources#best-practices for more information.
 
 Note that support for 3D Secure is in preview, and must be activated in the dashboard in order 
 for this example to work. You can request an invite at https://dashboard.stripe.com/account/payments/settings
 */
@interface ThreeDSViewController () <STPPaymentCardTextFieldDelegate>
@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;
@property (weak, nonatomic) UILabel *waitingLabel;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) STPRedirectContext *redirectContext;
@end

@implementation ThreeDSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    STPPaymentCardTextField *paymentTextField = [[STPPaymentCardTextField alloc] init];
    STPCardParams *cardParams = [STPCardParams new];
    // Only successful 3D Secure transactions on this test card will succeed.
    cardParams.number = @"4000000000003063";
    paymentTextField.cardParams = cardParams;
    paymentTextField.delegate = self;
    paymentTextField.cursorColor = [UIColor purpleColor];
    self.paymentTextField = paymentTextField;
    [self.paymentTextField setFrame:CGRectMake(0, 0, self.mPayView.frame.size.width, self.mPayView.frame.size.height)];
    [self.mPayView addSubview:paymentTextField];

    UILabel *label = [UILabel new];
    label.text = @"Waiting for payment authorization";
    [label sizeToFit];
    label.textColor = [UIColor grayColor];
    label.alpha = 0;
    [self.view addSubview:label];
    self.waitingLabel = label;

    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator = activityIndicator;
    [self.view addSubview:activityIndicator];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.paymentTextField becomeFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat padding = 15;
    CGRect bounds = self.view.bounds;
    self.activityIndicator.center = CGPointMake(CGRectGetMidX(bounds),
                                                CGRectGetMaxY(self.paymentTextField.frame) + padding*2);
    self.waitingLabel.center = CGPointMake(CGRectGetMidX(bounds),
                                           CGRectGetMaxY(self.activityIndicator.frame) + padding*2);
}

- (void)updateUIForPaymentInProgress:(BOOL)paymentInProgress {
    self.paymentTextField.userInteractionEnabled = !paymentInProgress;
    [UIView animateWithDuration:0.2 animations:^{
        self.waitingLabel.alpha = paymentInProgress ? 1 : 0;
    }];
    if (paymentInProgress) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
}

- (void)paymentCardTextFieldDidChange:(nonnull STPPaymentCardTextField *)textField {
    //self.navigationItem.rightBarButtonItem.enabled = textField.isValid;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
- (void)pay {
    if (![self.paymentTextField isValid]) {
        return;
    }
    if (![Stripe defaultPublishableKey]) {
        [self.delegate checkViewController:self didFinishWithMessage:@"Please set a Stripe Publishable Key in Config.h"];
        return;
    }
    [self updateUIForPaymentInProgress:YES];
    STPAPIClient *stripeClient = [STPAPIClient sharedClient];
    STPSourceParams *sourceParams = [STPSourceParams cardParamsWithCard:self.paymentTextField.cardParams];
    [stripeClient createSourceWithParams:sourceParams completion:^(STPSource *source, NSError *error) {
        if (source.cardDetails.threeDSecure == STPSourceCard3DSecureStatusRequired) {
            STPSourceParams *threeDSParams = [STPSourceParams threeDSecureParamsWithAmount:1099
                                                                                  currency:@"usd"
                                                                                 returnURL:@"payments-example://stripe-redirect"
                                                                                      card:source.stripeID];
            [stripeClient createSourceWithParams:threeDSParams completion:^(STPSource * source, NSError *error) {
                if (error) {
                    [self.delegate checkViewController:self didFinishWithError:error];
                } else {
                    // In order to use STPRedirectContext, you'll need to set up
                    // your app delegate to forwards URLs to the Stripe SDK.
                    // See `[Stripe handleStripeURLCallback:]`
                    self.redirectContext = [[STPRedirectContext alloc] initWithSource:source completion:^(NSString *sourceID, NSString *clientSecret, NSError *error) {
                        [[STPAPIClient sharedClient] startPollingSourceWithId:sourceID
                                                                 clientSecret:clientSecret
                                                                      timeout:10
                                                                   completion:^(STPSource *source, NSError *error) {
                                                                       [self updateUIForPaymentInProgress:NO];
                                                                       if (error) {
                                                                           [self.delegate checkViewController:self didFinishWithError:error];
                                                                       } else {
                                                                           switch (source.status) {
                                                                               case STPSourceStatusChargeable:
                                                                               case STPSourceStatusConsumed:
                                                                                   [self.delegate checkViewController:self didFinishWithMessage:@"Payment successfully created"];
                                                                                   break;
                                                                               case STPSourceStatusCanceled:
                                                                                   [self.delegate checkViewController:self didFinishWithMessage:@"Payment failed"];
                                                                                   break;
                                                                               case STPSourceStatusPending:
                                                                               case STPSourceStatusFailed:
                                                                               case STPSourceStatusUnknown:
                                                                                   [self.delegate checkViewController:self didFinishWithMessage:@"Order received"];
                                                                                   break;
                                                                           }
                                                                       }
                                                                       self.redirectContext = nil;
                                                                   }];
                    }];
                    [self.redirectContext startRedirectFlowFromViewController:self];
                }
            }];
        } else {
            [self.delegate createBackendChargeWithSource:source.stripeID completion:^(STPBackendChargeResult status, NSError *error) {
                if (error) {
                    [self.delegate checkViewController:self didFinishWithError:error];
                    return;
                }
                [self.delegate checkViewController:self didFinishWithMessage:@"Payment successfully created"];
            }];
        }
    }];
}
#pragma clang diagnostic pop

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPay:(id)sender {
    [self pay];
}
@end
