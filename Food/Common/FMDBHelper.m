//
//  FMDBHelper.m
//  BoatTicketBooking
//
//  Created by Jin_Q on 5/28/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "FMDBHelper.h"
#import <FMDatabase.h>
#import "Food.h"
#import "OrderGroup.h"
#import "ExtraMenu.h"

FMDBHelper *helper = nil;
FMDatabase *database;

@implementation FMDBHelper {

}

+ (id)sharedInstance{
    if(!helper)
    {
        helper = [[FMDBHelper alloc] initWithFMDB];
    }
    
    return helper;
}

-(id) initWithFMDB{
    helper = [[FMDBHelper alloc] init];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"cart.sqlite"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:@"CREATE TABLE cart (id INTEGER PRIMARY KEY AUTOINCREMENT ,  foodId VARCHAR DEFAULT NULL,   foodName VARCHAR DEFAULT NULL,   price VARCHAR DEFAULT NULL,   restId VARCHAR DEFAULT NULL,   restName VARCHAR DEFAULT NULL, count INTEGER DEFAULT 1, datetime VARCHAR DEFAULT NULL, instruction VARCHAR DEFAULT NULL)"];
    [database executeUpdate:@"CREATE TABLE extra_menu (id INTEGER PRIMARY KEY AUTOINCREMENT ,  menu_id VARCHAR DEFAULT NULL,  food_id VARCHAR DEFAULT NULL,   menu_name VARCHAR DEFAULT NULL,   count IVARCHAR DEFAULT NULL)"];
    [database executeUpdate:@"CREATE TABLE extra_food (id INTEGER PRIMARY KEY AUTOINCREMENT ,  eid VARCHAR DEFAULT NULL,   menu_id VARCHAR DEFAULT NULL,   food_name VARCHAR DEFAULT NULL,   price VARCHAR DEFAULT NULL, count INTEGER DEFAULT 1)"];
    [database close];
    return helper;
}

- (NSMutableArray*) getAllOrders {
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT * FROM cart"];
    while([results next]) {
        Food* food = [[Food alloc] init];
        food.fId = [results stringForColumn:@"id"];
        food.foodId = [results stringForColumn:@"foodId"];
        food.name = [results stringForColumn:@"foodName"];
        food.price = [f numberFromString:[results stringForColumn:@"price"]];
        food.restId = [results stringForColumn:@"restId"];
        food.restName = [results stringForColumn:@"restName"];
        int c = [results intForColumn:@"count"];
        if(c ==0) c=1;
        food.count = [NSNumber numberWithInt:c];
        food.datetime = [results dateForColumn:@"datetime"];
        food.instruction = [results stringForColumn:@"instruction"];
        
        NSMutableArray *menu_array = [[NSMutableArray alloc] init];
        FMResultSet* menu_results = [database executeQuery:@"SELECT * FROM extra_menu WHERE food_id= ?", [NSString stringWithFormat:@"%@",food.fId]];
        while([menu_results next]) {
            ExtraMenu* one_menu = [[ExtraMenu alloc] init];
            one_menu.mId = [menu_results stringForColumn:@"id"];
            one_menu.menuId = [menu_results stringForColumn:@"menu_id"];
            one_menu.foodId = [menu_results stringForColumn:@"food_id"];
            one_menu.menuName = [menu_results stringForColumn:@"menu_name"];
            one_menu.count = [menu_results stringForColumn:@"count"];
            
            NSMutableArray* food_array = [[NSMutableArray alloc] init];
            FMResultSet* food_results = [database executeQuery:@"SELECT * FROM extra_food WHERE menu_id= ?", [NSString stringWithFormat:@"%@",one_menu.mId]];
            while([food_results next]) {
                ExtraFood* one_food = [[ExtraFood alloc] init];
                one_food.mId = [food_results stringForColumn:@"id"];
                one_food.eid = [food_results stringForColumn:@"eid"];
                one_food.menuId = [food_results stringForColumn:@"menu_id"];
                one_food.foodname = [food_results stringForColumn:@"food_name"];
                one_food.price = [food_results stringForColumn:@"price"];
                one_food.count = [food_results stringForColumn:@"count"];
                [food_array addObject:one_food];
            }
            one_menu.extrafoods = food_array;
            [menu_array addObject:one_menu];
        }
        food.extrafoods = menu_array;
        
        [array addObject:food];
    }
    [database close];
    
    return array;
}

- (NSMutableArray*) getRestIds {

    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT * FROM cart GROUP BY restId"];
    while([results next]) {
        NSString* restId = [results stringForColumn:@"restId"];
        [array addObject:restId];
    }
    [database close];
    
    return array;
}

- (NSMutableArray*) getOrdersByRestID:(NSString*)restId {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT * FROM cart WHERE restId= ?", [NSString stringWithFormat:@"%@", restId]];
    while([results next]) {
        Food* food = [[Food alloc] init];
        food.fId = [results stringForColumn:@"id"];
        food.foodId = [results stringForColumn:@"foodId"];
        food.name = [results stringForColumn:@"foodName"];
        food.price = [f numberFromString:[results stringForColumn:@"price"]];
        food.restId = [results stringForColumn:@"restId"];
        food.restName = [results stringForColumn:@"restName"];
        int c = [results intForColumn:@"count"];
        if(c ==0) c=1;
        food.count = [NSNumber numberWithInt:c];
        food.datetime = [results dateForColumn:@"datetime"];
        food.instruction = [results stringForColumn:@"instruction"];
        
        NSMutableArray *menu_array = [[NSMutableArray alloc] init];
        FMResultSet* menu_results = [database executeQuery:@"SELECT * FROM extra_menu WHERE food_id= ?", [NSString stringWithFormat:@"%@",food.fId]];
        while([menu_results next]) {
            ExtraMenu* one_menu = [[ExtraMenu alloc] init];
            one_menu.mId = [menu_results stringForColumn:@"id"];
            one_menu.menuId = [menu_results stringForColumn:@"menu_id"];
            one_menu.foodId = [menu_results stringForColumn:@"food_id"];
            one_menu.menuName = [menu_results stringForColumn:@"menu_name"];
            one_menu.count = [menu_results stringForColumn:@"count"];
            
            NSMutableArray* food_array = [[NSMutableArray alloc] init];
            FMResultSet* food_results = [database executeQuery:@"SELECT * FROM extra_food WHERE menu_id= ?", [NSString stringWithFormat:@"%@",one_menu.mId]];
            while([food_results next]) {
                ExtraFood* one_food = [[ExtraFood alloc] init];
                one_food.mId = [food_results stringForColumn:@"id"];
                one_food.eid = [food_results stringForColumn:@"eid"];
                one_food.menuId = [food_results stringForColumn:@"menu_id"];
                one_food.foodname = [food_results stringForColumn:@"food_name"];
                one_food.price = [food_results stringForColumn:@"price"];
                one_food.count = [food_results stringForColumn:@"count"];
                [food_array addObject:one_food];
            }
            one_menu.extrafoods = food_array;
            [menu_array addObject:one_menu];
        }
        food.extrafoods = menu_array;
        [array addObject:food];
    }
    [database close];
    
    return array;
}

- (NSMutableArray*) getOrdersGroup {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSMutableArray* restIds = [helper getRestIds];
    for(int i=0;i<restIds.count;i++){
        NSMutableArray* orders = [[NSMutableArray alloc] init];
        orders = [helper getOrdersByRestID:restIds[i]];
        OrderGroup* og = [[OrderGroup alloc] init];
        og.mRestName = ((Food*)(orders[0])).restName;
        og.mRestId = ((Food*)(orders[0])).restId;
        og.mDate = ((Food*)(orders[0])).datetime;
        int count = 0;
        for(int j=0;j<orders.count;j++){
            Food* f = orders[j];
            count+=[f.count intValue];
        }
        
        og.mCount = [NSNumber numberWithInteger:count];
        [array addObject:og];
    }
    return array;
}

- (void) deleteOrderByRestId:(NSString*) restId {
    [database open];
    NSString* query_menu = @"";
    FMResultSet *results = [database executeQuery:@"SELECT * FROM cart WHERE restId= ?", [NSString stringWithFormat:@"%@", restId]];
    while([results next]) {
        Food* food = [[Food alloc] init];
        food.fId = [results stringForColumn:@"id"];
        FMResultSet* menu_results = [database executeQuery:@"SELECT * FROM extra_menu WHERE food_id= ?", [NSString stringWithFormat:@"%@",food.fId]];
        while([menu_results next]) {
            ExtraMenu* one_menu = [[ExtraMenu alloc] init];
            one_menu.mId = [menu_results stringForColumn:@"id"];
            query_menu = @"DELETE FROM extra_food WHERE ";
            query_menu = [NSString stringWithFormat:@"%@%@%@", query_menu, @"menu_id=", one_menu.mId];
            [database executeUpdate:query_menu];
        }
        query_menu = @"DELETE FROM extra_menu WHERE ";
        query_menu = [NSString stringWithFormat:@"%@%@%@", query_menu, @"food_id=", food.fId];
        [database executeUpdate:query_menu];
    }
    [database executeUpdate:@"DELETE FROM cart WHERE restId = ?", restId];
    [database close];
}

- (void) deleteExtFood:(ExtraFood*) extfood{
    [database open];
    //NSInteger count = [extfood.count integerValue];
    //if(count == 1){
        NSString* query_menu = @"DELETE FROM extra_food WHERE ";
        query_menu = [NSString stringWithFormat:@"%@%@%@", query_menu, @"id=", extfood.mId];
        [database executeUpdate:query_menu];
    /*} else{
        NSNumber *new_count = [NSNumber numberWithInt:(int)(count-1)];
        [database executeUpdate:@"UPDATE extra_food SET count=? WHERE eid=?", new_count, [NSString stringWithFormat:@"%@", extfood.eid]];
    }*/
    [database close];
}

- (void) deleteFood:(Food*) food{
    [database open];
    //NSInteger count = [food.count integerValue];
    //if(count == 1){
        NSString* query_menu = @"DELETE FROM extra_menu WHERE ";
        query_menu = [NSString stringWithFormat:@"%@%@%@", query_menu, @"food_id=", food.fId];
        [database executeUpdate:query_menu];
        for(int i = 0; i < food.extrafoods.count; i++){
            ExtraMenu* one_menu = food.extrafoods[i];
            query_menu = @"DELETE FROM extra_food WHERE ";
            query_menu = [NSString stringWithFormat:@"%@%@%@", query_menu, @"menu_id=", one_menu.mId];
            [database executeUpdate:query_menu];
        }
        NSString* query = @"DELETE FROM cart WHERE ";
        query = [NSString stringWithFormat:@"%@%@%@", query, @"id=", food.fId];
        [database executeUpdate:query];
    /*} else{
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm"];
        NSDate *datetime = [NSDate date];
        food.count = [NSNumber numberWithInt:(int)(count-1)];
        [database executeUpdate:@"UPDATE cart SET foodId=?, foodName=?, price=?, restId=?, restName=?, count=?, datetime=?, instruction=? WHERE foodId=?", food.foodId, food.name, [food.price stringValue], food.restId, food.restName, food.count, datetime, food.instruction, [NSString stringWithFormat:@"%@", food.foodId]];
    }*/
    [database close];
}

- (void) addFood:(Food*) food {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm"];
    NSDate *datetime = [NSDate date];
    [database open];
    [database executeUpdate:@"INSERT INTO cart (foodId, foodName, price, restId, restName, count, datetime, instruction) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", food.foodId, food.name, [food.price stringValue], food.restId, food.restName, food.count, datetime, food.instruction];
    
    [database close];
}

- (int) getFoodCountByFoodID:(NSString*)foodId {
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    int count = 0;
    [database open];
    FMResultSet* results = [database executeQuery:@"SELECT * FROM cart WHERE foodId= ?", [NSString stringWithFormat:@"%@",foodId]];
    while([results next]) {
        count = [results intForColumn:@"count"];
        if(count == 0) count = 1;
    }
    [database close];
    return count;
}

- (Food*)getFoodbyID:(NSString *)foodId{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [database open];
    
    FMResultSet* results = [database executeQuery:@"SELECT * FROM cart WHERE foodId= ?", [NSString stringWithFormat:@"%@",foodId]];
    Food* food = [[Food alloc] init];
    while([results next]) {
        food.fId = [results stringForColumn:@"id"];
        food.foodId = [results stringForColumn:@"foodId"];
        food.name = [results stringForColumn:@"foodName"];
        food.price = [f numberFromString:[results stringForColumn:@"price"]];
        food.restId = [results stringForColumn:@"restId"];
        food.restName = [results stringForColumn:@"restName"];
        int c = [results intForColumn:@"count"];
        if(c ==0) c=1;
        food.count = [NSNumber numberWithInt:c];
        food.datetime = [results dateForColumn:@"datetime"];
        food.instruction = [results stringForColumn:@"instruction"];
        
        NSMutableArray *menu_array = [[NSMutableArray alloc] init];
        FMResultSet* menu_results = [database executeQuery:@"SELECT * FROM extra_menu WHERE food_id= ?", [NSString stringWithFormat:@"%@",foodId]];
        while([menu_results next]) {
            ExtraMenu* one_menu = [[ExtraMenu alloc] init];
            one_menu.mId = [menu_results stringForColumn:@"id"];
            one_menu.menuId = [menu_results stringForColumn:@"menu_id"];
            one_menu.foodId = [menu_results stringForColumn:@"food_id"];
            one_menu.menuName = [menu_results stringForColumn:@"menu_name"];
            one_menu.count = [menu_results stringForColumn:@"count"];
            
            NSMutableArray* food_array = [[NSMutableArray alloc] init];
            FMResultSet* food_results = [database executeQuery:@"SELECT * FROM extra_food WHERE menu_id= ?", [NSString stringWithFormat:@"%@",one_menu.menuId]];
            while([food_results next]) {
                ExtraFood* one_food = [[ExtraFood alloc] init];
                one_food.mId = [food_results stringForColumn:@"id"];
                one_food.eid = [food_results stringForColumn:@"eid"];
                one_food.menuId = [food_results stringForColumn:@"menu_id"];
                one_food.foodname = [food_results stringForColumn:@"food_name"];
                one_food.price = [food_results stringForColumn:@"price"];
                one_food.count = [food_results stringForColumn:@"count"];
                [food_array addObject:one_food];
            }
            one_menu.extrafoods = food_array;
            [menu_array addObject:one_menu];
        }
        food.extrafoods = menu_array;
    }
    [database close];
    
    return food;
}

- (BOOL) isExistMenuByID:(NSString*)menuId {
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    BOOL bret = false;
    [database open];
    FMResultSet* results = [database executeQuery:@"SELECT * FROM extra_menu WHERE menu_id=?", [NSString stringWithFormat:@"%@",menuId]];
    while([results next]) {
        bret = true;
    }
    [database close];
    return bret;
}

- (int) getExtraFoodByID:(NSString*)foodID {
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    int count = 0;
    [database open];
    FMResultSet* results = [database executeQuery:@"SELECT * FROM extra_food WHERE eid= ?", [NSString stringWithFormat:@"%@",foodID]];
    while([results next]) {
        count = [results intForColumn:@"count"];
        if(count == 0) count = 1;
    }
    [database close];
    return count;
}

- (void) updateFood:(Food*) food
           Quantity:(NSInteger) mcount{
    
    BOOL success;
    //int count = [self getFoodCountByFoodID:food.foodId];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm"];
    NSDate *datetime = [NSDate date];
    NSNumber *new_count;
    
    //NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    if (![database open]) {
        NSLog(@"Failed to open database!");
        return;
    }
    /*if(count>0){
        //Food* exist = [self getFoodbyID:food.foodId];
        food.count = [NSNumber numberWithInt:(int)(count+mcount)];
        [database executeUpdate:@"UPDATE cart SET foodId=?, foodName=?, price=?, restId=?, restName=?, count=?, datetime=?, instruction=? WHERE foodId=?", food.foodId, food.name, [food.price stringValue], food.restId, food.restName, food.count, datetime, food.instruction, [NSString stringWithFormat:@"%@", food.foodId]];
        for(int i = 0; i < food.extrafoods.count; i++){
            ExtraMenu* one_menu = food.extrafoods[i];
            if([self isExistMenuByID:one_menu.menuId]){
                for(int j = 0; j < one_menu.extrafoods.count;j++){
                    ExtraFood* one_food = one_menu.extrafoods[j];
                    count = [self getExtraFoodByID:one_food.eid];
                    if(count>0){
                        if(!database.open) [database open];
                        new_count = [NSNumber numberWithInt:(int)(count+mcount)];
                        [database executeUpdate:@"UPDATE extra_food SET count=? WHERE eid=?", new_count, [NSString stringWithFormat:@"%@", one_food.eid]];
                    } else{
                        if(!database.open) [database open];
                        new_count = [NSNumber numberWithInt:(int)mcount];
                        success = [database executeUpdate:@"INSERT INTO extra_food (eid, menu_id, food_name, price, count) VALUES (?, ?, ?, ?, ?)", one_food.eid, one_food.menuId, one_food.foodname, one_food.price, new_count];
                        if(!success)
                            NSLog(@"error = %@", [database lastErrorMessage]);
                    }
                }
            } else{
                if(!database.open) [database open];
                success = [database executeUpdate:@"INSERT INTO extra_menu (menu_id, food_id, menu_name, count) VALUES (?, ?, ?, ?)", one_menu.menuId, one_menu.foodId, one_menu.menuName, one_menu.count];
                if(!success)
                    NSLog(@"error = %@", [database lastErrorMessage]);
                for(int j = 0; j < one_menu.extrafoods.count;j++){
                    ExtraFood* one_food = one_menu.extrafoods[j];
                    new_count = [NSNumber numberWithInt:(int)mcount];
                    if(!database.open) [database open];
                    success = [database executeUpdate:@"INSERT INTO extra_food (eid, menu_id, food_name, price, count) VALUES (?, ?, ?, ?, ?)", one_food.eid, one_food.menuId, one_food.foodname, one_food.price, new_count];
                    if(!success)
                        NSLog(@"error = %@", [database lastErrorMessage]);
                }
            }
        }
        
    } else {*/
        food.count = [NSNumber numberWithInt:(int)mcount];
        success = [database executeUpdate:@"INSERT INTO cart (foodId, foodName, price, restId, restName, count, datetime, instruction) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", food.foodId, food.name, [food.price stringValue], food.restId, food.restName, food.count, datetime, food.instruction];
        if(!success)
             NSLog(@"error = %@", [database lastErrorMessage]);
    NSString *food_ind = [NSString stringWithFormat:@"%lld", [database lastInsertRowId]];
        for(int i = 0; i < food.extrafoods.count; i++){
            ExtraMenu* one_menu = food.extrafoods[i];
            if(!database.open) [database open];
            success = [database executeUpdate:@"INSERT INTO extra_menu (menu_id, food_id, menu_name, count) VALUES (?, ?, ?, ?)", one_menu.menuId, food_ind, one_menu.menuName, one_menu.count];
            if(!success)
                NSLog(@"error = %@", [database lastErrorMessage]);
            NSString *menu_ind = [NSString stringWithFormat:@"%lld", [database lastInsertRowId]];
            for(int j = 0; j < one_menu.extrafoods.count;j++){
                ExtraFood* one_food = one_menu.extrafoods[j];
                new_count = [NSNumber numberWithInt:(int)mcount];
                if(!database.open) [database open];
                success = [database executeUpdate:@"INSERT INTO extra_food (eid, menu_id, food_name, price, count) VALUES (?, ?, ?, ?, ?)", one_food.eid, menu_ind, one_food.foodname, one_food.price, new_count];
                if(!success)
                    NSLog(@"error = %@", [database lastErrorMessage]);
            }
        }
    //}
    
    [database close];
}


@end

// Or with variables FMResultSet *results = [database executeQuery:@"SELECT * from tableName where fieldName= ?",[NSString stringWithFormat:@"%@", variableName]];
