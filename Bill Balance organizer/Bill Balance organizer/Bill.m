//
//  Bill.m
//  Bill Balance organizer
//
//  Created by Anthony on 7/1/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "Bill.h"

@implementation Bill

@synthesize title;
@synthesize description;
@synthesize total;
@synthesize date;
@synthesize category;
@synthesize tmpIndexInMainTable;
@synthesize imageFileName;
@synthesize billID;


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.category = [aDecoder decodeObjectForKey:@"category"];
        self.total = [aDecoder decodeFloatForKey:@"total"];
        self.description = [aDecoder decodeObjectForKey:@"description"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.tmpIndexInMainTable = [aDecoder decodeIntForKey:@"tmpIndexInMainTable"];
        self.imageFileName = [aDecoder decodeObjectForKey:@"imageFileName"];
        self.billID = [aDecoder decodeIntForKey:@"billID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:category forKey:@"category"];
    [aCoder encodeFloat:total forKey:@"total"];
    [aCoder encodeObject:description forKey:@"description"];
    [aCoder encodeObject:date forKey:@"date"];
    [aCoder encodeInt:tmpIndexInMainTable forKey:@"tmpIndexInMainTable"];
    [aCoder encodeObject:imageFileName forKey:@"imageFileName"];
    [aCoder encodeInt:billID forKey:@"billID"];
}

+ (int)findInsertIndex:(NSMutableArray *) bills withDate:(NSDate *)date
{
    if (bills == nil) {
        return 0;
    }
    
    int end = (int)([bills count]-1);
    int start = 0;
    date = [self setBeginningOfTheDate:date];
    
    while (start <= end) {
        
        int middle = (start+end)/2;
        Bill *bill = [bills objectAtIndex:middle];
        NSDate *billDate = bill.date;

        if ([date compare:billDate] == NSOrderedAscending) {
            //earlier
            if(start == end){
                return end+1;
            }
            
            start = middle +1 ;
      
        }
        else if ([date compare:billDate] == NSOrderedDescending)
        {
            //later
            if (start == end) {
                return start;
            }
            
            end = middle -1;
        }
        else
        {
            if (middle -1 >= 0) {
                middle -- ;
                Bill *pre = [bills objectAtIndex:middle];
                NSDate *billDate2 = pre.date;
                
                while ([billDate compare:billDate2] == NSOrderedSame) {
                    if (middle -1 == -1) {
                        return 0;
                    }
                    middle --;
                    pre = [bills objectAtIndex:middle];
                    billDate2 = pre.date;
                }
                middle ++ ;
            }
            
            return middle;
        }
    }
    
    return start;

}

+ (int)dateCompate:(NSMutableArray *) bills withIndex:(int)index withDate:(NSDate *)date
{
    Bill *bill = [bills objectAtIndex:index];
    
    return [date compare:bill.date];
}

+ (NSString*)dateToNSString:(NSDate*)date
{
    NSDate *date1 = [self setBeginningOfTheDate:date];
    NSDate *date2 = [self setBeginningOfTheDate:[NSDate date]];
    if ([date1 compare:date2] == NSOrderedSame) {
        return @"Today";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"M-d-yyyy"];
    return [formatter stringFromDate:date];
}

+ (NSString*)dateToNSStringToSecond:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-yyyy-mm-ss"];
    return [formatter stringFromDate:date];
}

+ (NSString*)dateToNSStringSimple:(NSDate*)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"M/d"];
    return [formatter stringFromDate:date];
}

+ (NSString *)getCurrentMonthName
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:now];
    
}

+ (NSString *)getCurrentYear
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    return [formatter stringFromDate:now];
}


+ (int)getCategoryIndex:(NSArray *)list withName:(NSString *)name
{
    int i=-1;
    for (NSString *s in list) {
        i++;
        if([s isEqualToString:name])
            return i;
    }
    
    return -1;
}

+ (float)calculateTotal:(NSMutableArray *) bills withLastIndex:(int)index
{
    int i=0;
    float total=0;
    
    for (i=0; i<= index; i++) {
        Bill *bill = [bills objectAtIndex:i];
        total+=bill.total;
    }
    
    return total;
}

+ (NSDate*)getFirstDayOfCurrentWeek
{
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit
                                                       fromDate:today];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract
                                                         toDate:today options:0];
    
    /*
     Optional step:
     beginningOfWeek now has the same hour, minute, and second as the original date (today).
     To normalize to midnight, extract the year, month, and day components and create a new date from those components.
     */
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: beginningOfWeek];
    beginningOfWeek = [gregorian dateFromComponents:components];
    
    return beginningOfWeek;
}

+ (NSDate *)getLastDayOfCurrentWeek
{
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit
                                                       fromDate:today];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 7 - ([weekdayComponents weekday]-1) ];
    
    NSDate *LastOfWeek = [gregorian dateByAddingComponents:componentsToSubtract
                                                         toDate:today options:0];
    
    /*
     Optional step:
     beginningOfWeek now has the same hour, minute, and second as the original date (today).
     To normalize to midnight, extract the year, month, and day components and create a new date from those components.
     */
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: LastOfWeek];
    LastOfWeek = [gregorian dateFromComponents:components];
    
    return [LastOfWeek dateByAddingTimeInterval:-1];

}

+ (NSDate *)setBeginningOfTheDate:(NSDate *)date
{
    NSDate *time = date;
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&time interval:nil forDate:time];
    
    return time;
}

+ (NSDate *)setTheEndOfTheDate:(NSDate *)date
{
    NSDate *today = [[NSDate alloc] init];
    //set to beginning of the day
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&today interval:nil forDate:today];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    NSDate *nextDay = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    return [nextDay dateByAddingTimeInterval:-1];
}

+ (void)insertToCategory:(NSMutableArray *)category withBill:(Bill *)bill
{
    if ([category count] == 0 )
    {
        [category addObject:bill];
        return;
    }
    
    if ([category count] == 1) {
        [category insertObject:bill atIndex:1];
        return;
    }
    
    int end = (int)([category count]-1);
    int start = 0;
    
    while (start <= end) {
        
        int middle = (start+end)/2;
        Bill *bill2 = [category objectAtIndex:middle];
        
        if (bill.billID > bill2.billID) {
            
            start = middle+1;
        }
        else if (bill.billID < bill2.billID)
        {
            end = middle-1;
        }
       
    }
    
    [category insertObject:bill atIndex:start];
    
}

+ (void)removeFromCategory:(NSMutableArray *)category withBill:(Bill *)bill
{
    if ([category count] == 0 )
    {
        return;
    }
    
    int end = (int)([category count]-1);
    int start = 0;
    
    while (start <= end) {
        
        int middle = (start+end)/2;
        Bill *bill2 = [category objectAtIndex:middle];
        
        if (bill.billID > bill2.billID) {
            start = middle+1 ;
            
        }
        else if (bill.billID < bill2.billID)
        {
            end = middle-1;
        }
        else{
            [category removeObjectAtIndex:middle];
            break;
        }
        
    }
    
}

@end
