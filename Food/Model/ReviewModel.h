//
//  ReviewModel.h
//  ReviewModel
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewModel : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSNumber *ranking;
@property (nonatomic, strong) NSString *posttime;
@property (nonatomic, strong) NSString *comment;


- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
