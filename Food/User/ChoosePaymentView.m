//
//  ChoosePaymentView.m
//  Food
//
//  Created by meixiang wu on 21/07/2017.
//  Copyright © 2017 Odelan. All rights reserved.
//

#import "ChoosePaymentView.h"
#import "AppDelegate.h"
#import <DXPopover.h>

@interface ChoosePaymentView ()
@property (nonatomic) DXPopover *popover;
@end

@implementation ChoosePaymentView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ShowPopover:(UIViewController*)parent ShowAtPoint:(CGPoint)point DismissHandler:(void (^)())block
{
    CGSize size = parent.view.frame.size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width * 3/4, 102)];
    [parent addChildViewController:self];
    [view addSubview:self.view];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = @{@"contentview":self.view};
    [view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentview]|" options:0 metrics:nil views:views]];
    [view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentview]|" options:0 metrics:nil views:views]];
    self.popover = [DXPopover popover];
    [self.popover showAtPoint:point popoverPostion:DXPopoverPositionDown withContentView:view inView:parent.view];
    self.popover.didDismissHandler = block;
}

- (void) setLayout{
    switch (g_appDelegate.mPayMethod) {
        case 0://Daily
            [self.mAppleImg setImage:[UIImage imageNamed: @"ic_choice_on.png"]];
            [self.mCardImg setImage:[UIImage imageNamed: @"ic_choice_off.png"]];
            [self.mDSImg setImage:[UIImage imageNamed: @"ic_choice_off.png"]];
            break;
        case 1:
            [self.mAppleImg setImage:[UIImage imageNamed: @"ic_choice_off.png"]];
            [self.mCardImg setImage:[UIImage imageNamed: @"ic_choice_on.png"]];
            [self.mDSImg setImage:[UIImage imageNamed: @"ic_choice_off.png"]];
            break;
        case 2:
            [self.mAppleImg setImage:[UIImage imageNamed: @"ic_choice_off.png"]];
            [self.mCardImg setImage:[UIImage imageNamed: @"ic_choice_off.png"]];
            [self.mDSImg setImage:[UIImage imageNamed: @"ic_choice_on.png"]];
            break;
        default:
            break;
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

- (IBAction)onApplePayClick:(id)sender {
    g_appDelegate.mPayMethod = 0;
    [self setLayout];
    [self.popover dismiss];
}

- (IBAction)onCardPayClick:(id)sender {
    g_appDelegate.mPayMethod = 1;
    [self setLayout];
    [self.popover dismiss];
}

- (IBAction)onDSPayClick:(id)sender {
    g_appDelegate.mPayMethod = 2;
    [self setLayout];
    [self.popover dismiss];
}

@end
