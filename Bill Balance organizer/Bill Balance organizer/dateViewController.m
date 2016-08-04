//
//  dateViewController.m
//  Bill Balance organizer
//
//  Created by Anthony on 7/29/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "dateViewController.h"
#import "Global.h"
#import "Bill.h"
#import "StatisticsViewController.h"
#import "AddViewController.h"
#import "billDetailViewController.h"
#import "settingDeleteViewController.h"

@interface dateViewController ()

@end

@implementation dateViewController
@synthesize m_Maximum,m_Date,m_Delegate,m_Type,m_Minimum;

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
    
    self.view.backgroundColor = [Global Rgb2UIColor:240 with:240 with:240];
    m_TopDateView.backgroundColor = [UIColor whiteColor];
    m_DatePickerView.datePickerMode = UIDatePickerModeDate;

    // Do any additional setup after loading the view.
    //self.navigationItem.leftBarButtonItem = self.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:false];
    
    m_DisplayDateLabel.text = [Bill dateToNSString:m_Date];
    [m_DatePickerView setDate:m_Date animated:NO];
    [m_DatePickerView setMaximumDate:self.m_Maximum];
    
    if (m_Type == DATEVIEW_DELETEVIEW_DATEEND) {
        m_DatePickerView.minimumDate = m_Minimum;
    }
    else
        m_DatePickerView.minimumDate = nil;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    if (m_Type == DATEVIEW_CUSTOM_DATE) {
        StatisticsViewController *controller = (StatisticsViewController*)m_Delegate;
        controller.dateDisplayLabel.text = m_DisplayDateLabel.text;
        [Global getInstance].m_CustomDate = [Bill setBeginningOfTheDate:[m_DatePickerView date]];
        
        NSDate *date = [Global getInstance].m_CustomDate;
        date =[date dateByAddingTimeInterval:-1000];
        NSMutableArray *bills = [Global getInstance].m_Bills;
        float total = [Bill calculateTotal:bills withLastIndex:[Bill findInsertIndex:bills withDate:date]-1];
        UILabel *totalLabel = (UILabel*)[controller.m_titleView viewWithTag:50];
        totalLabel.text = [NSString stringWithFormat:@"%.02f",total];
        
        if (total > 10000000) {
            totalLabel.font = [UIFont fontWithName:@"Chalkduster" size:16];
        }
        else
            totalLabel.font = [UIFont fontWithName:@"Chalkduster" size:25];
        
        [totalLabel sizeToFit];
        
        float rightMargin =10;
        
        float frameY = controller.m_titleView.frame.size.height/2+3;
        
        if (total > 10000000) {
            frameY = controller.m_titleView.frame.size.height/2+8;
        }
        
        totalLabel.frame = CGRectMake(controller.m_titleView.frame.size.width-totalLabel.frame.size.width-rightMargin, frameY, totalLabel.frame.size.width, totalLabel.frame.size.height);
       
        [controller.m_titleView viewWithTag:60].frame = CGRectMake(totalLabel.frame.origin.x-37, totalLabel.frame.origin.y-4, 25, 30);
        
        [controller makeCategoryView];
        
    }
    else if (m_Type == DATEVIEW_ADDVIEW)
    {
        AddViewController *controller = (AddViewController *)m_Delegate;
        controller.dateLabel.text = m_DisplayDateLabel.text;
        controller.dateSelected = [Bill setBeginningOfTheDate:[m_DatePickerView date]];
       
    }
    else if (m_Type == DATEVIEW_DETAILVIEW)
    {
        billDetailViewController *controller = (billDetailViewController *)m_Delegate;
        controller.dateLabel.text = m_DisplayDateLabel.text;
        controller.dateSelected = [Bill setBeginningOfTheDate:[m_DatePickerView date]];
    }
    else if (m_Type == DATEVIEW_DELETEVIEW_DATEAFTER)
    {
        settingDeleteViewController *controller = (settingDeleteViewController *)m_Delegate;
        controller.dateAfterLabel.text = m_DisplayDateLabel.text;
        controller.dateAfter = [Bill setBeginningOfTheDate:[m_DatePickerView date]];
        [controller countAfter];
    }
    else if (m_Type == DATEVIEW_DELETEVIEW_DATESTART)
    {
        settingDeleteViewController *controller = (settingDeleteViewController *)m_Delegate;
        controller.dateStartLabel.text = m_DisplayDateLabel.text;
        controller.dateStart = [Bill setBeginningOfTheDate:[m_DatePickerView date]];
        [controller countPeriod];
    }
    else if (m_Type == DATEVIEW_DELETEVIEW_DATEEND)
    {
        settingDeleteViewController *controller = (settingDeleteViewController *)m_Delegate;
        controller.dateEndLabel.text = m_DisplayDateLabel.text;
        controller.dateEnd = [Bill setBeginningOfTheDate:[m_DatePickerView date]];
        [controller countPeriod];
    }
   
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

- (IBAction)datePickerChang:(id)sender {
    m_DisplayDateLabel.text = [Bill dateToNSString:[m_DatePickerView date]];
}
@end
