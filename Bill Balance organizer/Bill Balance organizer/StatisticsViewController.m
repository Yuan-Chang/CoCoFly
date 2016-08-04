//
//  StatisticsViewController.m
//  Bill Balance organizer
//
//  Created by Anthony on 6/29/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "StatisticsViewController.h"
#import "Bill.h"
#import "Global.h"
#import "dateViewController.h"

#import "PieGraphElement.h"
#import "PieGraph.h"

enum{
    TODAY,
    WEEKLY,
    MONTHLY,
    YEARLY,
    CUSTOM
};

@interface StatisticsViewController ()

@end



@implementation StatisticsViewController
{
    
    NSArray *labelNameList;
    
    int oneDayIndex;
    int oneWeekIndex;
    int oneMonthIndex;
    int oneYearIndex;
    int customDateIndex;
    
    NSDate *_oneDay;
    NSDate *_oneWeek;
    NSDate *_oneMonth;
    NSDate *_oneYear;
    NSDate *_customDay;
    
    float totalAmount;
    
    NSMutableArray *bills;
    
    UIScrollView *scrollView;
    
}

@synthesize dateDisplayLabel,m_titleView,m_graphView;
@synthesize m_mainScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;


}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    //self.automaticallyAdjustsScrollViewInsets = true;
    
    //m_mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    m_mainScrollView.frame = CGRectMake(0, 68, self.view.frame.size.width, m_mainScrollView.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = false;
    
    bills = [Global getInstance].m_Bills;
    //[data setObject:nil forKey:@"Bills"];
    
    dateDisplayLabel.text = [Bill dateToNSString:[Global getInstance].m_CustomDate];
    
    m_graphView.frame = CGRectMake(m_graphView.frame.origin.x, m_graphView.frame.origin.y, m_graphView.frame.size.width,10000);
    
    m_segmentView.selectedSegmentIndex = [Global getInstance].m_summary_mode_index;
    [self setUpTitleView];
    [self makeCategoryView];
}

-(void)setUpTitleView
{
    
    totalAmount = [Global getInstance].m_Total;
    
    [[m_titleView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (m_segmentView.selectedSegmentIndex == CUSTOM) {
        m_titleView.backgroundColor = [[UIColor alloc]initWithPatternImage:[Global convertImageSizeToFit:@"SummaryCellBGCustom#4.png" withFrame:m_titleView.frame]];
    }
    else
    {
        m_titleView.backgroundColor = [[UIColor alloc]initWithPatternImage:[Global convertImageSizeToFit:@"SummaryCellBGCustom#3.png" withFrame:m_titleView.frame]];
    }
    
    NSDate *today = [[NSDate alloc] init];
    
    //set to beginning of the day
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&today interval:nil forDate:today];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    //date displayed in title view
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 2, 120, 30)];
    dateLabel.tag = 40;
    
    //total amount displayed in title view
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    totalLabel.tag = 50;
    
    //calculate result
    float count;
    
    if (m_segmentView.selectedSegmentIndex == TODAY) {
        
        [offsetComponents setDay:-1];
        _oneDay = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
        
        dateLabel.text = [Bill dateToNSStringSimple:[NSDate date]];
        
        if (totalAmount > 0.0f) {
            oneDayIndex = [Bill findInsertIndex:bills withDate:_oneDay]-1;
        }
        else
        {
            oneDayIndex = -1;
        }
        
        count = [Bill calculateTotal:bills withLastIndex:oneDayIndex];
    }
    else if (m_segmentView.selectedSegmentIndex == WEEKLY)
    {
        [offsetComponents setWeek:-1];
        _oneWeek = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
        
        dateLabel.text = [NSString stringWithFormat:@"%@-%@",[Bill dateToNSStringSimple:[Bill getFirstDayOfCurrentWeek]],[Bill dateToNSStringSimple:[Bill getLastDayOfCurrentWeek]]];
        
        if (totalAmount > 0.0f) {
            oneWeekIndex = [Bill findInsertIndex:bills withDate:_oneWeek]-1;
        }
        else
        {
            oneWeekIndex = -1;
        }
        
        count = [Bill calculateTotal:bills withLastIndex:oneWeekIndex];
        
    }
    else if (m_segmentView.selectedSegmentIndex == MONTHLY)
    {
        [offsetComponents setMonth:-1];
        _oneMonth = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
        
        dateLabel.text = [Bill getCurrentMonthName];
        
        if (totalAmount > 0.0f) {
            oneMonthIndex = [Bill findInsertIndex:bills withDate:_oneMonth]-1;
        }
        else
        {
            oneMonthIndex = -1;
        }
        
        count = [Bill calculateTotal:bills withLastIndex:oneMonthIndex];
    }
    else if (m_segmentView.selectedSegmentIndex == YEARLY)
    {
        [offsetComponents setYear:-1];
        _oneYear = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
        
        dateLabel.text = [Bill getCurrentYear];
        
        if (totalAmount > 0.0f) {
            oneYearIndex = [Bill findInsertIndex:bills withDate:_oneYear]-1;
        }
        else
        {
            oneYearIndex = -1;
        }
        
        count = [Bill calculateTotal:bills withLastIndex:oneYearIndex];
    }
    else if (m_segmentView.selectedSegmentIndex == CUSTOM)
    {
        _customDay = [[Global getInstance].m_CustomDate dateByAddingTimeInterval:-1000];
        customDateIndex = [Bill findInsertIndex:bills withDate:_customDay]-1;
        
        dateLabel.text = [Bill dateToNSString:[Global getInstance].m_CustomDate];
        
        count = [Bill calculateTotal:bills withLastIndex:customDateIndex];
        
        UILabel *dropDownLabel = [[UILabel alloc]initWithFrame:CGRectMake(109, 7, 80, 20)];
        dropDownLabel.tag = 41;
        dropDownLabel.text = dateLabel.text;
        
        dropDownLabel.userInteractionEnabled = true;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDate:)];
        [dropDownLabel addGestureRecognizer:tapGesture];
        dropDownLabel.textAlignment = NSTextAlignmentCenter;
        dateDisplayLabel = dropDownLabel;
        
        UIView *dropDownView =[Global getDropDownViewByLabel:dropDownLabel withImageName:@"dropDown#6.png"];
        [dropDownView addGestureRecognizer:tapGesture];
        [m_titleView addSubview:dropDownView];

        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 100, 20)];
        textLabel.text = @"Start From : ";
        textLabel.font = [UIFont boldSystemFontOfSize:16];
        textLabel.textColor = [Global Rgb2UIColor:0 with:122 with:255];
        [m_titleView addSubview:textLabel];
    }
    
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont systemFontOfSize:16];
    
    totalLabel.text = [NSString stringWithFormat:@"%.02f", count];
    totalLabel.textColor = [UIColor blackColor];
    
    if (count > 10000000) {
        totalLabel.font = [UIFont fontWithName:@"Chalkduster" size:16];
    }
    else
        totalLabel.font = [UIFont fontWithName:@"Chalkduster" size:25];
    
    //add underline
    totalLabel.attributedText = [[NSAttributedString alloc]initWithString:totalLabel.text attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    
    [totalLabel sizeToFit];
    
    float rightMargin =10;
    
    float frameY = m_titleView.frame.size.height/2+3;
    
    if (count > 10000000) {
        frameY = m_titleView.frame.size.height/2+8;
    }
    
    totalLabel.frame = CGRectMake(m_titleView.frame.size.width-totalLabel.frame.size.width-rightMargin, frameY, totalLabel.frame.size.width, totalLabel.frame.size.height);
    UIImage *image = [Global convertImageSizeToFit:@"moneyBag#1" withFrame:CGRectMake(totalLabel.frame.origin.x-30, totalLabel.frame.origin.y, 25, 30)];
    UIImageView *moneyBag = [[UIImageView alloc]initWithImage:image];
    moneyBag.tag = 60;
    moneyBag.frame = CGRectMake(totalLabel.frame.origin.x-37, totalLabel.frame.origin.y-4, 25, 30);
    
    if (m_segmentView.selectedSegmentIndex != CUSTOM) {
        [m_titleView addSubview:dateLabel];
    }
    
    [m_titleView addSubview:totalLabel];
    [m_titleView addSubview:moneyBag];
}

- (IBAction)indexChanged:(id)sender
{
    [Global getInstance].m_summary_mode_index = (int)m_segmentView.selectedSegmentIndex;
    [self setUpTitleView];
    [self makeCategoryView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [labelNameList count]+1;
    //return 1;
}

/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [labelNameList count];
}*/


/*
-(UIView *)tableView:(UITableView *)local_tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    static NSString *cellName = @"headerCell";
    UITableViewCell *headerView = [local_tableView dequeueReusableCellWithIdentifier:cellName];
    
    UILabel *label = (UILabel*)[headerView viewWithTag:40];
    
    label.text = [labelNameList objectAtIndex:section];
    label.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:20];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    headerView.backgroundColor = [Global Rgb2UIColor:60 with:179 with:113];
    
    //UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 22.0)];
    
    //UIImage *image = [UIImage imageNamed:@"Background_320x22"];
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    
    // create the button object
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.frame = CGRectMake(0.0, 0.0, 320.0, 22.0);
    
    headerLabel.text = @"Summary";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    [customView addSubview:headerLabel];
 
    return headerView;
}
*/

-(void)makeCategoryView
{
     [[m_graphView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSDictionary *categories = [Global getInstance].m_Categories;
    
    NSMutableArray *textIndicators = [[categories allKeys]mutableCopy];
    NSMutableArray *Colors = [Global getInstance].m_Colors;
    float Total = 0;
    NSMutableArray *values = [[NSMutableArray alloc]init];
    int i = 0;
    for (NSString *key in textIndicators) {
        NSArray *category = [categories objectForKey:key];
        
        float total = 0;
        for (Bill *bill in category) {
            
            if (m_segmentView.selectedSegmentIndex == TODAY)
            {
                if([bill.date compare:_oneDay] == NSOrderedDescending)
                {
                    total += bill.total;
                }
            }
            else if (m_segmentView.selectedSegmentIndex == WEEKLY)
            {
                if([bill.date compare:_oneWeek] == NSOrderedDescending)
                    total += bill.total;
            }
            else if (m_segmentView.selectedSegmentIndex == MONTHLY)
            {
                if([bill.date compare:_oneMonth] == NSOrderedDescending)
                    total += bill.total;
            }
            else if (m_segmentView.selectedSegmentIndex == YEARLY)
            {
                if([bill.date compare:_oneYear] == NSOrderedDescending)
                    total += bill.total;
            }
            else if (m_segmentView.selectedSegmentIndex == CUSTOM)
            {
                _customDay = [[Global getInstance].m_CustomDate dateByAddingTimeInterval:-1000];
                if([bill.date compare:_customDay] == NSOrderedDescending)
                    total += bill.total;
            }
        }
        
        if (total > 0) {
            
            PieGraphElement *element = [[PieGraphElement alloc]initWithColor:Colors[i] withTitle:key withValue:total] ;
            
            [values addObject:element];
            
            Total += total;

        }
        i++;
    }
    
    values = [[values sortedArrayUsingComparator:^NSComparisonResult(PieGraphElement *p1, PieGraphElement *p2){
        
        return p1.m_Value < p2.m_Value;
    }]mutableCopy];
    
    PieGraph *pieGraph = [[PieGraph alloc]initWithFrame:CGRectMake(0, 0, m_graphView.frame.size.width, 1000) withValues:values withTotal:Total];
    pieGraph.frame = [pieGraph getFrame];
   
    [m_graphView addSubview:pieGraph];
    m_graphView.frame = CGRectMake(m_graphView.frame.origin.x, m_graphView.frame.origin.y, pieGraph.frame.size.width, pieGraph.frame.size.height);
    
    m_mainScrollView.contentSize = CGSizeMake(m_mainScrollView.frame.size.width, m_graphView.frame.size.height + 220);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 90;
    }
    else if (indexPath.row == 5)
    {
        return 250;
    }
    
    return 65;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showDate:(id)sender {
    
    dateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"dateView"];
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    controller.m_Maximum = [Bill setBeginningOfTheDate:[NSDate date]];
    controller.m_Date = [Global getInstance].m_CustomDate;
    controller.m_Type = DATEVIEW_CUSTOM_DATE;
    controller.m_Delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}


@end
