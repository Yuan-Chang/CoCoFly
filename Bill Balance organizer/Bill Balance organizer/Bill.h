//
//  Bill.h
//  Bill Balance organizer
//
//  Created by Anthony on 7/1/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bill : NSObject <NSCoding>
{
    NSString *title;
    NSString *description;
    NSString *category;
    float total;
    NSDate *date;
    NSString *imageFileName;
    
    int billID;
    int indexInCategory;
    int tmpIndexInMainTable;
}

+ (int)dateCompate:(NSMutableArray *) bills withIndex:(int)index withDate:(NSDate *)date;
+ (int)findInsertIndex:(NSMutableArray *) bills withDate:(NSDate *)date;
+ (NSString*)dateToNSString:(NSDate*)date;
+ (NSString*)dateToNSStringSimple:(NSDate*)date;
+ (NSString*)dateToNSStringToSecond:(NSDate*)date;

+ (int)getCategoryIndex:(NSArray *)list withName:(NSString *)name;
+ (float)calculateTotal:(NSMutableArray *) bills withLastIndex:(int)index;
+ (NSDate *)getFirstDayOfCurrentWeek;
+ (NSDate *)getLastDayOfCurrentWeek;
+ (NSString *)getCurrentMonthName;
+ (NSString *)getCurrentYear;
+ (NSDate *)setBeginningOfTheDate:(NSDate *)date;
+ (NSDate *)setTheEndOfTheDate:(NSDate *)date;
+ (void)insertToCategory:(NSMutableArray *)category withBill:(Bill *)bill;
+ (void)removeFromCategory:(NSMutableArray *)category withBill:(Bill *)bill;

@property(nonatomic) NSString *title;
@property NSString *description;
@property float total;
@property NSDate *date;
@property NSString *category;
@property int tmpIndexInMainTable;
@property NSString *imageFileName;
@property int billID;

@end
