//
//  ReviewModel.m
//  ReviewModel
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "ReviewModel.h"

@implementation ReviewModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    ReviewModel *item = [[ReviewModel alloc] init];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    item.userid = [dicParams objectForKey:@"user_id"];
    item.username = [dicParams objectForKey:@"username"];
    item.ranking = [f numberFromString:[dicParams objectForKey:@"ranking"]];
    item.comment = [dicParams objectForKey:@"comment"];
    item.posttime = [dicParams objectForKey:@"posttime"];
    
    return item;
}

@end
