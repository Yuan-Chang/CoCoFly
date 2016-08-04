//
//  CategoryViewController.m
//  Bill Balance organizer
//
//  Created by Anthony on 7/30/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "CategoryViewController.h"
#import "AddViewController.h"
#import "billDetailViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

@synthesize m_CategoryName,m_Delegate,m_Type;

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
    self.view.backgroundColor = [Global Rgb2UIColor:240 with:240 with:240];
    m_TopView.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    m_CategoryDisplayLabel.text = m_CategoryName;
    
    int index =(int)[[Global getInstance].m_CategoryList indexOfObject:m_CategoryName];
    [m_CategoryPicker selectRow:index inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m_CategoryDisplayLabel.text = [[Global getInstance].m_CategoryList objectAtIndex:row];
    
    if (m_Type == CATEGORYVIEW_ADDVIEW) {
        AddViewController *controller = (AddViewController*)m_Delegate;
        controller.categoryLabel.text = m_CategoryDisplayLabel.text;
    }
    else if(m_Type == CATEGORYVIEW_DETAILVIEW)
    {
        billDetailViewController *controller = (billDetailViewController*)m_Delegate;
        controller.categoryLabel.text = m_CategoryDisplayLabel.text;
    }
    
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return[[Global getInstance].m_CategoryList objectAtIndex:row];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[Global getInstance].m_CategoryList count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//set the detail of picker view label
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 260)]; // your frame, so picker gets "colored"
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    label.text = [[Global getInstance].m_CategoryList objectAtIndex :row];
    return label;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    //return 162.0f;
    return 25.0f;
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

@end
