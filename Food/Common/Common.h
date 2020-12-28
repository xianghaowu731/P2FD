//
//  Common.h
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Common : NSObject
+ (NSString *)convertHTML:(NSString *)html;
+ (NSString *) getValueKey:(NSString *)key;
+ (void) saveValueKey:(NSString *)key
                Value:(NSString *)value ;
+ (NSMutableArray *) getMutableArrayWithKey:(NSString *)key;
+ (void) saveMutableArrayWithKey:(NSString *)key
                           Value:(NSMutableArray *)value ;
+ (id) getObjectWithKey:(NSString *)key;
+ (void) saveObjectWithKey:(NSString *)key
                     Value:(id)value ;
+ (BOOL) isStringEmpty:(NSString *)string;
+ (NSMutableArray *) getMutableArrayWithString:(NSString *)value;
+ (NSString *) getStringWithMutableArray:(NSMutableArray *)value;

+ (NSString *) getFavorIds;
+ (void) saveFavorIdsWithValue:(NSString *)value ;
+ (void) addFavorId:(NSString *) value;
+ (void) removeFavorId:(NSString *) value;
+ (void) initFavoriteFoodIds;
+ (BOOL) getLikeStatus:(NSString *)foodId;

+ (NSMutableArray*) getCategories;
+ (void) saveCategories:(NSMutableArray*) array;
+ (UIImage *)resizeImage:(UIImage *)image;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+(NSString *)replaceStringwithString:(NSString *)mainString strTobeReplaced:(NSString *)strTobeReplaced stringReplaceWith:(NSString *)stringReplaceWith;
+(NSString *)removeSpaces:(NSString *)string;

+(UIAlertView *)simpleAlert:(NSString *)title desc:(NSString *)descr;
@end
