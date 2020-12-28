//
//  Common.m
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import "Common.h"
#import "BaseItem.h"

NSMutableArray *allFoods;
NSMutableArray *favoriteFoodIds;
BOOL isLikeStatusChanged;

@implementation Common
+ (NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

+ (NSString *) getValueKey:(NSString *)key {
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if ([preferences objectForKey:key] == nil)
    {
        //  Doesn't exist.
        return nil;
    }
    else
    {
        //  Get current level
        NSString *value = [preferences stringForKey:key];
        return value;
    }
}

+ (void) saveValueKey:(NSString *)key
                Value:(NSString *)value {
    if(value==nil){
        value = @"";
    }
    if(value==(id)[NSNull null]){
        value = @"";
    }
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    [preferences setObject:value forKey:key];
    
    //  Save to disk
    const BOOL didSave = [preferences synchronize];
    
    if (!didSave)
    {
        //  Couldn't save (I've never seen this happen in real world testing)
    }
    
}

+(NSString *)replaceStringwithString:(NSString *)mainString strTobeReplaced:(NSString *)strTobeReplaced stringReplaceWith:(NSString *)stringReplaceWith
{
    return [mainString stringByReplacingOccurrencesOfString:strTobeReplaced withString:stringReplaceWith];
}

+(NSString *)removeSpaces:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(UIAlertView *)simpleAlert:(NSString *)title desc:(NSString *)descr
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:descr delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    return alert;
}

+ (id) getObjectWithKey:(NSString *)key {
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if ([preferences objectForKey:key] == nil)
    {
        return nil;
    }
    else
    {
        NSDictionary *info = [preferences objectForKey:key];
        return info;
    }
}


+ (void) saveObjectWithKey:(NSString *)key
                     Value:(id)value {
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    [preferences setObject:value forKey:key];
    
    const BOOL didSave = [preferences synchronize];
    
    if (!didSave)
    {
    }
    
}



+ (NSMutableArray *) getMutableArrayWithKey:(NSString *)key Class:(BaseItem *) item {
    
    return [Common getMutableArrayWithString:[Common getValueKey:key] Class:item];
    
    /*NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
     
     if ([preferences objectForKey:key] == nil)
     {
     return nil;
     }
     else
     {
     NSMutableArray *array = [NSMutableArray arrayWithArray:[preferences objectForKey:key]];
     return array;
     }*/
}

+ (NSMutableArray *) getMutableArrayWithString:(NSString *)value Class:(BaseItem *) item
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if(![value isEqualToString:@""]){
        NSArray* foo = [value componentsSeparatedByString: @"#*#"];
        for(int i=0; i<foo.count; i++){
            [result addObject:[item initWithString:foo[i]]];
        }
    }
    return result;
}



+ (void) saveMutableArrayWithKey:(NSString *)key
                           Value:(NSMutableArray *)value {
    
    [Common saveValueKey:key Value:[Common getStringWithMutableArray:value]];
    
    /*NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
     
     [preferences setObject:value forKey:key];
     
     const BOOL didSave = [preferences synchronize];
     
     if (!didSave)
     {
     }*/
    
}

+ (NSString *) getStringWithMutableArray:(NSMutableArray *)value
{
    
    NSInteger index = 0;
    if(value.count==0) return @"";
    
    BaseItem *product = [value objectAtIndex:index];
    NSString *result = [product getStringOfItem];
    
    for(int i=1; i<value.count; i++){
        index = i;
        result = [NSString stringWithFormat:@"%@#*#%@", result, [((BaseItem *)[value objectAtIndex:index]) getStringOfItem]];
    }
    
    return result;
}


+ (BOOL)isStringEmpty:(NSString *)string {
    if([string length] == 0) { //string is empty or nil
        return YES;
    }
    
    if(![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}

///////// getting favorite food ids.///////////
+ (void) initFavoriteFoodIds{
    favoriteFoodIds = [Common getArrayWithString:[Common getFavorIds]];
}

+ (NSString *) getFavorIds{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if ([preferences objectForKey:@"favorite"] == nil)
    {
        //  Doesn't exist.
        return @"";
    }
    else
    {
        //  Get current level
        NSString *value = [preferences stringForKey:@"favorite"];
        return value;
    }

}

+ (void) saveFavorIdsWithValue:(NSString *)value{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    [preferences setObject:value forKey:@"favorite"];
    
    //  Save to disk
    const BOOL didSave = [preferences synchronize];
    
    if (!didSave)
    {
        //  Couldn't save (I've never seen this happen in real world testing)
    }
}

+ (void) addFavorId:(NSString *) value{
    BOOL isAlreadyExist = NO;
    for(int i=0; i<favoriteFoodIds.count; i++){
        NSString *favorId = [favoriteFoodIds objectAtIndex:i];
        if([favorId isEqualToString:value]){
            isAlreadyExist = YES;
        }
    }
    if(!isAlreadyExist){
        [favoriteFoodIds addObject:value];
        [Common saveFavorIdsWithValue:[Common getStringWithArray:favoriteFoodIds]];
    }
}

+ (void) removeFavorId:(NSString *) value{
    for (int i=0;i<[favoriteFoodIds count]; i++) {
        NSString *item = [favoriteFoodIds objectAtIndex:i];
        if ([item isEqualToString:value]) {
            [favoriteFoodIds removeObject:item];
        }
    }
    [Common saveFavorIdsWithValue:[Common getStringWithArray:favoriteFoodIds]];
}

+ (NSMutableArray *) getArrayWithString:(NSString *)value
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if(![value isEqualToString:@""]){
        NSArray* foo = [value componentsSeparatedByString: @","];
        result = [NSMutableArray arrayWithArray:foo];
    }
    
    return result;
}

+ (NSString *) getStringWithArray:(NSMutableArray *)value
{
    
    NSInteger index = 0;
    NSString *product = [value objectAtIndex:index];
    NSString *result = product;
    
    for(int i=1; i<value.count; i++){
        index = i;
        result = [NSString stringWithFormat:@"%@,%@", result, value[i]];
    }
    
    return result;
}

+ (BOOL) getLikeStatus:(NSString *)foodId{
    for(int i=0; i<[favoriteFoodIds count]; i++){
        if([(NSString *)[favoriteFoodIds objectAtIndex:i] isEqualToString:foodId]){
            return YES;
        }
    }
    
    return NO;
}

+ (NSMutableArray*) getCategories{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    //result = [Common getMutableArrayWithKey:@"categories" Class:[FoodCategory alloc]];
    return result;
}

+ (void) saveCategories:(NSMutableArray*) array{
    [Common saveMutableArrayWithKey:@"categories" Value:array];
}

+(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300.0;
    float maxWidth = 300.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
    
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
