//
//  PayConfirmView.m
//  Food
//
//  Created by meixiang wu on 06/09/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "PayConfirmView.h"

@interface PayConfirmView ()

@end

@implementation PayConfirmView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLayout{
    if([self.mStatus isEqualToString:@"YES"]){
        self.mInformLabel.text = @"Thank You For Your Order!\n Your Estimated Delivery Time Is 60~90 Minutes.";
        self.mOrderNumberLabel.text = [NSString stringWithFormat:@"Foods Received: %@", self.mOrder];
    }else{
        self.mInformLabel.text = @"Unable to complete order. Go ahead and try that again.";
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickOK:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
