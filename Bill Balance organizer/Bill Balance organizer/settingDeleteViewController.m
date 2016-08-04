//
//  settingDeleteViewController.m
//  Bill Balance organizer
//
//  Created by Anthony on 7/20/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "settingDeleteViewController.h"
#import "Bill.h"
#import "Global.h"
#import "dateViewController.h"

@interface settingDeleteViewController ()
{
    
    
    int dateLabelSelected;
}
@end

@implementation settingDeleteViewController

@synthesize dateAfter,dateEnd,dateStart,dateAfterLabel,dateEndLabel,dateStartLabel;

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
    
    scrollView.scrollEnabled = true;
    scrollView.userInteractionEnabled = true;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan:)];
    [scrollView addGestureRecognizer:tap3];
    [scrollView setContentSize:CGSizeMake(320, 480)];
    
    int width = scrollView.frame.size.width;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(width*0.05, 30, width*0.9, 80)];
    
    [self initView:view1];
    
    UILabel *label = (UILabel *)[view1 viewWithTag:41];
    
    totalReceiptsNumLabel =[ [UILabel alloc] initWithFrame: CGRectMake(label.frame.origin.x+label.frame.size.width+2, label.frame.origin.y-2, 30, 30)];
    totalReceiptsNumLabel.font = [UIFont boldSystemFontOfSize:18];
    totalReceiptsNumLabel.text = @"empty";
    totalReceiptsNumLabel.tag = 2;
    [totalReceiptsNumLabel sizeToFit];
    [view1 addSubview:totalReceiptsNumLabel];
    
    label = (UILabel *)[view1 viewWithTag:42];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteAllBtn:)];
    [label addGestureRecognizer:tap1];
    
    view1.tag = 50;
    [scrollView addSubview:view1];
    
    //view2 position
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(width*0.05, 130, width*0.9, 118)];
    
    [self initView:view2];
    label = (UILabel*)[view2 viewWithTag:40];
    label.text = @"Delete bills before";
    [label sizeToFit];
    
    //number of bills label
    label = (UILabel*)[view2 viewWithTag:41];
    label.frame = CGRectMake(label.frame.origin.x, 65, label.frame.size.width, label.frame.size.height);
    [label sizeToFit];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x, 30, 1000, 1000)];
    label2.text =@"Date : ";
    label2.font = [UIFont systemFontOfSize:14];
    [label2 sizeToFit];
    [view2 addSubview:label2];
    
    //Delete button
    label = (UILabel*)[view2 viewWithTag:42];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y+35, label.frame.size.width, label.frame.size.height);
    tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteAfterBtn:)];
    [label addGestureRecognizer:tap1];
    
    dateAfterLabel = [[UILabel alloc]initWithFrame:CGRectMake(label2.frame.origin.x+45, label2.frame.origin.y-3, 80, 20)];
    dateAfterLabel.font = [UIFont systemFontOfSize:14];
    dateAfterLabel.layer.borderWidth = .5f;
    dateAfterLabel.layer.cornerRadius = 5;
    dateAfterLabel.textAlignment = NSTextAlignmentCenter;
    dateAfterLabel.text = [Bill dateToNSString:[NSDate date]];
    dateAfterLabel.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePicker0:)];
    [dateAfterLabel addGestureRecognizer:tap];
    UIView *labelView = [Global getDropDownViewByLabel:dateAfterLabel withImageName:@"dropDown#6"];
    [labelView addGestureRecognizer:tap];
    [view2 addSubview:labelView];
    
    label2 = (UILabel *)[view2 viewWithTag:41];
    afterReceiptsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(label2.frame.origin.x+label2.frame.size.width+2, label2.frame.origin.y - 3, 1000, 1000)];
    afterReceiptsNumLabel.font = [UIFont boldSystemFontOfSize:18];
    afterReceiptsNumLabel.textAlignment = NSTextAlignmentCenter;
    afterReceiptsNumLabel.text = [NSString stringWithFormat:@"%d",0];
    [afterReceiptsNumLabel sizeToFit];
    [view2 addSubview:afterReceiptsNumLabel];
    
    view2.tag = 51;
    [scrollView addSubview:view2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(width*0.05, 268, width*0.9, 175)];
    [self initView:view3];
    label = (UILabel*)[view3 viewWithTag:40];
    label.text = @"Delete bills between dates";
    [label sizeToFit];
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x, 34, 1000, 1000)];
    label2.text = @"From : ";
    label2.font = [UIFont systemFontOfSize:14];
    [label2 sizeToFit];
    [view3 addSubview:label2];
    
    dateStartLabel = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.origin.x + label2.frame.size.width +5, label2.frame.origin.y -3, 80, 20)];
    
    dateStartLabel.font = [UIFont systemFontOfSize:14];
    dateStartLabel.layer.borderWidth = .5f;
    dateStartLabel.layer.cornerRadius = 5;
    dateStartLabel.textAlignment = NSTextAlignmentCenter;
    dateStartLabel.text = [Bill dateToNSString:[NSDate date]];
    dateStartLabel.userInteractionEnabled = true;
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePicker1:)];
    [dateStartLabel addGestureRecognizer:tap];
    labelView = [Global getDropDownViewByLabel:dateStartLabel withImageName:@"dropDown#6"];
    [labelView addGestureRecognizer:tap];
    [view3 addSubview:labelView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(label2.frame.origin.x, label2.frame.origin.y + 45, 1000, 1000)];
    label.text = @"To : ";
    [label sizeToFit];
    [view3 addSubview:label];
    
    dateEndLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelView.frame.origin.x, label.frame.origin.y-3 ,80 , 20)];
    
    dateEndLabel.font = [UIFont systemFontOfSize:14];
    dateEndLabel.layer.borderWidth = .5f;
    dateEndLabel.layer.cornerRadius = 5;
    dateEndLabel.textAlignment = NSTextAlignmentCenter;
    dateEndLabel.text = [Bill dateToNSString:[NSDate date]];
    dateEndLabel.userInteractionEnabled = true;
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePicker2:)];
    [dateEndLabel addGestureRecognizer:tap];
    labelView = [Global getDropDownViewByLabel:dateEndLabel withImageName:@"dropDown#6"];
    [labelView addGestureRecognizer:tap];
    [view3 addSubview:labelView];
    
    //total number label
    label = (UILabel *)[view3 viewWithTag:41];
    label.frame = CGRectMake(label.frame.origin.x, 120, label.frame.size.width, label.frame.size.height);
    
    //delete label
    label2 = (UILabel *)[view3 viewWithTag:42];
    label2.frame = CGRectMake(label2.frame.origin.x, 145, label2.frame.size.width, label2.frame.size.height);
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deletePeriodBtn:)];
    [label2 addGestureRecognizer:tap];
    
    periodReceiptsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width+3, label.frame.origin.y - 3, label.frame.size.width, label.frame.size.height)];
    periodReceiptsNumLabel.font = [UIFont boldSystemFontOfSize:18];
    periodReceiptsNumLabel.textAlignment = NSTextAlignmentCenter;
    periodReceiptsNumLabel.text = [NSString stringWithFormat:@"%d",0];
    [periodReceiptsNumLabel sizeToFit];
    [view3 addSubview:periodReceiptsNumLabel];
    
    view3.tag = 52;
    [scrollView addSubview:view3];
    
    [self.view addSubview:scrollView];
    
    navigationBar.title = @"Delete";
    
    NSDate *today = [Bill setBeginningOfTheDate:[NSDate date]];
    dateStart = dateEnd = dateAfter = today;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSArray *table = [Global getInstance].m_Bills;
    
    totalReceiptsNumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[table count]];
    
    [self countAfter];
    [self countPeriod];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchUserInteraction:(BOOL)value
{
    dateAfterLabel.userInteractionEnabled = value;
    dateStartLabel.userInteractionEnabled = value;
    dateEndLabel.userInteractionEnabled = value;

    UIView *view = [scrollView viewWithTag:50];
    UILabel *label = (UILabel *)[view viewWithTag:42];
    label.userInteractionEnabled = value;
    
    view = [scrollView viewWithTag:51];
    label = (UILabel *)[view viewWithTag:42];
    label.userInteractionEnabled = value;
    
    view = [scrollView viewWithTag:52];
    label = (UILabel *)[view viewWithTag:42];
    label.userInteractionEnabled = value;
}

-(IBAction)showDatePicker0:(id)sender
{
    dateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"dateView"];
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    controller.m_Maximum = [Bill setBeginningOfTheDate:[NSDate date]];
    controller.m_Date = [Bill setBeginningOfTheDate:dateAfter];
    controller.m_Type = DATEVIEW_DELETEVIEW_DATEAFTER;
    controller.m_Delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    /*
    datePickerView.hidden = false;
    datePickerView.maximumDate = [NSDate date];
    datePickerView.minimumDate = nil;
    datePickerView.date = dateAfter;
    UIView *view = [scrollView viewWithTag:52];
    view.hidden = true;
    datePickerView.frame = CGRectMake(0, 185, scrollView.frame.size.width, 200);
    
    [self switchUserInteraction:false];
    
    dateLabelSelected = 0;
    
    [scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
    */
}


-(IBAction)showDatePicker1:(id)sender
{
    dateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"dateView"];
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    controller.m_Maximum = [Bill setBeginningOfTheDate:dateEnd];
    controller.m_Date = [Bill setBeginningOfTheDate:dateStart];
    controller.m_Type = DATEVIEW_DELETEVIEW_DATESTART;
    controller.m_Delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
   /*
    datePickerView.hidden = false;
    datePickerView.maximumDate = dateEnd;
    datePickerView.minimumDate = nil;
    datePickerView.date = dateStart;
    datePickerView.frame = CGRectMake(0, 315, scrollView.frame.size.width, 200);
    
    [self switchUserInteraction:false];
    
    dateLabelSelected = 1;
    
    [scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
    */
}

-(IBAction)showDatePicker2:(id)sender
{
    dateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"dateView"];
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    controller.m_Maximum = [Bill setBeginningOfTheDate:[NSDate date]];
    controller.m_Minimum = dateStart;
    controller.m_Date = [Bill setBeginningOfTheDate:dateEnd];
    controller.m_Type = DATEVIEW_DELETEVIEW_DATEEND;
    controller.m_Delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    /*
    datePickerView.hidden = false;
    datePickerView.maximumDate = [NSDate date];
    datePickerView.minimumDate = dateStart;
    datePickerView.date = dateEnd;
    datePickerView.frame = CGRectMake(0, 315, scrollView.frame.size.width, 200);
    
    [self switchUserInteraction:false];
    
    dateLabelSelected = 2;
    
    [scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
*/
}

-(IBAction)touchesBegan:(id)sender
{/*
    if (dateAfterLabel.userInteractionEnabled == false && dateLabelSelected == 0) {
        
        datePickerView.hidden = true;
        
        [self switchUserInteraction:true];
        
        UIView *view = [scrollView viewWithTag:52];
        view.hidden = false;
        
        dateAfter = [Bill setBeginningOfTheDate:[datePickerView date]];
        dateAfterLabel.text = [Bill dateToNSString:dateAfter];
        
        [self countAfter];
    }
    else if (dateStartLabel.userInteractionEnabled == false && dateLabelSelected == 1) {
        
        datePickerView.hidden = true;
        
        [self switchUserInteraction:true];
        
        dateStart = [Bill setBeginningOfTheDate:[datePickerView date]];
        dateStartLabel.text = [Bill dateToNSString:dateStart];
        
        [self countPeriod];
        
    }
    else if (dateEndLabel.userInteractionEnabled == false && dateLabelSelected == 2)
    {
        datePickerView.hidden = true;
        
        [self switchUserInteraction:true];
        
        dateEnd = [Bill setBeginningOfTheDate:[datePickerView date]];
        dateEndLabel.text = [Bill dateToNSString:dateEnd];
        
        [self countPeriod];
    }
*/
}

-(void)countAfter
{
    NSMutableArray *Bills = [Global getInstance].m_Bills;
    int number = [Bill findInsertIndex:Bills withDate:dateAfter];
    number = (int)([Bills count] - number);
    afterReceiptsNumLabel.text = [NSString stringWithFormat:@"%d",number];
}

-(void)countPeriod
{
    
    NSDate *oneDayBefore = [dateStart dateByAddingTimeInterval:-86400];
    
    NSMutableArray *Bills =[Global getInstance].m_Bills;
    
    int number = [Bill findInsertIndex:Bills withDate:oneDayBefore] - [Bill findInsertIndex:Bills withDate:dateEnd];
    periodReceiptsNumLabel.text = [NSString stringWithFormat:@"%d",number];
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

- (void)initView:(UIView *)view
{
    view.layer.borderWidth = 0.5f;
    view.layer.cornerRadius = 5;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, 1000, 1000)];
    label.text = @"Delete all bills";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.tag = 40;
    [label sizeToFit];
    [view addSubview:label];
    
    label =[[UILabel alloc]initWithFrame:CGRectMake(5, 28, view.frame.size.width*0.4, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"Total number of bills :";
    label.tag = 41;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    [view addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(5, 53, 50, 23)];
    label.text = @"Delete";
    label.tag = 42;
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.layer.borderWidth = 1;
    label.layer.cornerRadius = 5;
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteAllBtn:)];
    label.userInteractionEnabled = true;
    [label addGestureRecognizer:tap];
    [view addSubview:label];
    
}

- (IBAction)deleteAllBtn:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Delete all of the stored bills ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 1;
    [alert show];
}

- (IBAction)deletePeriodBtn:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:[NSString stringWithFormat:@"Delete bills between dates %@ and %@ ?",[Bill dateToNSString:dateStart],[Bill dateToNSString:dateEnd]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 3;
    [alert show];
}

- (IBAction)deleteAfterBtn:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:[NSString stringWithFormat:@"Delete bills before  date %@ ?",[Bill dateToNSString:dateAfter]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 2;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    Global *instance = [Global getInstance];
    NSMutableArray *Bills = instance.m_Bills;
    float total = [Global getInstance].m_Total;
    
    if (alertView.tag == 1 && buttonIndex == 1) {
        
        //delete all
        
        for (Bill *bill in Bills) {
            [Global removeImageWithFileName:bill.imageFileName];
        }
        
        [Bills removeAllObjects];
        [instance.m_Categories removeAllObjects];
        instance.m_Total = 0;
        
        [instance.m_IDPool removeAllObjects];
        NSNumber *num = [NSNumber numberWithInt:0];
        [instance.m_IDPool addObject:num];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Delete successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        alert.tag = 10;
        [alert show];
    }
    else if (alertView.tag == 2 && buttonIndex == 1)
    {
        //delete after
        int index = [Bill findInsertIndex:Bills withDate:dateAfter];
        
        Bill *bill = nil;
        
        for (int i = (int)([Bills count]-1); i >= index; i--) {
            bill = [Bills objectAtIndex:[Bills count]-1];
            
            //put id back for reuse
            [[Global getInstance]putIDBackToPool:bill.billID];
            
            //remove image
            [Global removeImageWithFileName:bill.imageFileName];
            
            NSMutableDictionary *_categories = [Global getInstance].m_Categories;
            NSMutableArray *_category = [[_categories objectForKey:bill.category]mutableCopy];
            //[_category removeObjectAtIndex:bill.indexInCategory];
            [Bill removeFromCategory:_category withBill:bill];
            
            if ([_category count] == 0) {
                [_categories removeObjectForKey:bill.category];
            }
            else
                [_categories setObject:_category forKey:bill.category];
           
            total -= bill.total;
            [Bills removeLastObject];
        }
        
        if ([Bills count]==0) {
            [Global getInstance].m_Total = 0;
        }
        else
        {
            [Global getInstance].m_Total = total;
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Delete successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        alert.tag = 10;
        [alert show];
    }
    else if (alertView.tag == 3 && buttonIndex == 1)
    {
        //delete period
        dateEnd = [Bill setBeginningOfTheDate:dateEnd];
        dateStart = [Bill setBeginningOfTheDate:dateStart];
        
        int start = [Bill findInsertIndex:Bills withDate:dateEnd];
        
        NSDate *oneDayBefor = [dateStart dateByAddingTimeInterval:-10];
        int end = [Bill findInsertIndex:Bills withDate:oneDayBefor]-1;
        
        Bill *bill = nil;
        
        for (int i = start; i <= end; i++) {
            bill =[Bills objectAtIndex:start];
            
            //remove image file
            [Global removeImageWithFileName:bill.imageFileName];
            
            //put id back for reuse
            [[Global getInstance]putIDBackToPool:bill.billID];
            
            //remove from category list
            NSMutableDictionary *_categories = [Global getInstance].m_Categories;
            NSMutableArray *_category = [[_categories objectForKey:bill.category]mutableCopy];
            //[_category removeObjectAtIndex:bill.indexInCategory];
            [Bill removeFromCategory:_category withBill:bill];
            
            if ([_category count] == 0) {
                [_categories removeObjectForKey:bill.category];
            }
            else
                [_categories setObject:_category forKey:bill.category];
            
            total -= bill.total;
            [Bills removeObjectAtIndex:start];
        }
        
        if ([Bills count]==0) {
            [Global getInstance].m_Total = 0;
        }
        else
        {
            [Global getInstance].m_Total = total;
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Delete successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        alert.tag = 10;
        [alert show];
    }
    else if (alertView.tag == 10)
    {
        [self viewWillAppear:YES];
    }
}

@end
