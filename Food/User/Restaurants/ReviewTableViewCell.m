//
//  ReviewTableViewCell.m
//  Food
//
//  Created by meixiang wu on 21/02/2018.
//  Copyright © 2018 Odelan. All rights reserved.
//

#import "ReviewTableViewCell.h"

@implementation ReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.colors = @[ [UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0f], [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f], [UIColor colorWithRed:0.1f green:1.0f blue:0.1f alpha:1.0f]];
    // Setup control using iOS7 tint Color
    self.mRateView.backgroundColor  = self.colors[1];//[UIColor whiteColor];
    self.mRateView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRateView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRateView.maxRating = 5.0;
    self.mRateView.delegate = (id)self;
    self.mRateView.horizontalMargin = 2.0;
    self.mRateView.editable=YES;
    float rating = 4.65f;
    self.mRateView.rating= rating;
    self.mRateView.displayMode=EDStarRatingDisplayAccurate;
    [self.mRateView  setNeedsDisplay];
    self.mRateView.tintColor = self.colors[0];
    
    CALayer *imageLayer = self.mMarkLabel.layer;
    [imageLayer setCornerRadius:18];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setLayout:(ReviewModel*)f {
    self.mRateView.rating = [f.ranking floatValue];
    self.mDateLabel.text = f.posttime;
    self.mNameLabel.text = f.username;
    if([f.username length] > 0){
        NSString *markstr = [f.username substringToIndex:1];
        self.mMarkLabel.text = [markstr uppercaseString];
    }
    self.mContentLabel.text = f.comment;
    
    CGFloat fixedWidth = self.mContentLabel.frame.size.width;
    CGSize newSize = [self.mContentLabel sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.mContentLabel.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    self.mContentLabel.frame = newFrame;
}
@end
