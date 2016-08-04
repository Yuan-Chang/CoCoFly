//
//  SearchViewController.m
//  Bill Balance organizer
//
//  Created by Anthony on 6/29/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "SearchViewController.h"
#import "Bill.h"
#import "billDetailViewController.h"
#import "Global.h"

enum{
    SEG_TITLE,
    SEG_CATECORY,
    SEG_NOTE,
    SEG_TOTAL,
    SEG_DATE,
    SEG_ALL
};

@interface SearchViewController ()
{
    NSMutableArray *table;
    NSMutableArray *categoryIndexOfCell;
    
    NSDate *threeDays;
    NSDate *oneWeek;
    NSDate *oneMonth;
    NSDate *threeMonths;
    
    int threeDaysIndex;
    int oneWeekIndex;
    int oneMonthIndex;
    int threeMonthsIndex;
    
    int threeDaysNum;
    int oneWeekNum;
    int oneMonthNum;
    int threeMonthsNum;
    int moreNum;
    
    BOOL searchBarBool;
    UISearchBar *searchBar;
    UIView *searchBarView;
    
    NSMutableArray *searchResult;
    
}


@end

@implementation SearchViewController

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
    
    threeDaysIndex = 0;
    oneWeekIndex = 0;
    oneMonthIndex = 0;
    threeMonthsIndex = 0;
    
    //add the searh bar to the navigation bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    searchBar.delegate = self;

    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
    
    searchBarBool = NO;
    searchResult = [[NSMutableArray alloc]init];
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10.0f]};
    [segmentView setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
      
    table = [[NSMutableArray alloc]init];
    categoryIndexOfCell = [[NSMutableArray alloc]init];
    
    NSDate *today = [[NSDate alloc] init];
    //set to beginning of the day
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&today interval:nil forDate:today];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-3];
    threeDays = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setWeek:-1];
    oneWeek = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1];
    oneMonth = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-3];
    threeMonths = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    //get the date index
    table = [Global getInstance].m_Bills;
    
    if (searchBarBool) {
        [self searchBar:searchBar textDidChange:searchBar.text];
    }
    else{
        [self initializeIndexAndNum:table];
        [tableView reloadData];
    }
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int i=0;
    
    if (threeDaysIndex > 0) {
        i++;
    }
        
    if (oneWeekIndex-threeDaysIndex > 0) {
        i++;
    }
        
    if (oneMonthIndex-oneWeekIndex > 0) {
        i++;
    }
    
    if (threeMonthsIndex-oneMonthIndex > 0) {
        i++;
    }
    
    if (searchBarBool) {
        if (searchResult.count - threeMonthsIndex > 0) {
            i++;
        }
    }
    else if (table.count - threeMonthsIndex > 0) {
        i++;
    }
    
    return i;
}

- (int) getHeaderString:(int)order
{
    int i=0;
    
    if (threeDaysNum > 0) {
        i++;
        if (order == i) {
            return  0;
        }
    }
    
    if (oneWeekNum > 0){
        i++;
        if (order == i) {
            return 1;
        }
    }
    
    if (oneMonthNum > 0){
        i++;
        if (order == i) {
            return 2;
        }
    }
    
    if (threeMonthsNum > 0){
        i++;
        if (order == i) {
            return 3;
        }
    }
    
    if (moreNum > 0){
        i++;
        if (order == i) {
            return 4;
        }
    }
    
    return -1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 22.0)];
    
    //UIImage *image = [UIImage imageNamed:@"Background_320x22"];
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    
    // create the button object
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor blueColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    headerLabel.frame = CGRectMake(0.0, 0.0, 320.0, 22.0);
    
    NSArray *text = [[NSArray alloc]initWithObjects:@"In three days",@"Three days ago",@"One week ago",@"One month ago",@"Three months ago", nil];
    
    if (section == 0)
    {
        headerLabel.text = [text objectAtIndex:[self getHeaderString:1]];
    }
    else if (section == 1)
    {
        headerLabel.text = [text objectAtIndex:[self getHeaderString:2]];
    }
    else if (section == 2)
    {
        headerLabel.text = [text objectAtIndex:[self getHeaderString:3]];
    }
    else if (section == 3)
    {
        headerLabel.text = [text objectAtIndex:[self getHeaderString:4]];
    }
    else
    {
        headerLabel.text = [text objectAtIndex:[self getHeaderString:5]];
    }
    
    //[customView addSubview:imageView];
    [customView addSubview:headerLabel];
    
    return customView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResult count];
    }*/
    
    int nums[5]={threeDaysNum,oneWeekNum,oneMonthNum,threeMonthsNum,moreNum};
    
    if (section == 0)
    {
        return nums[[self getHeaderString:1]];
    }
    else if (section == 1)
    {
        return nums[[self getHeaderString:2]];
    }
    else if (section == 2)
    {
        return nums[[self getHeaderString:3]];
    }
    else if (section == 3)
    {
        return nums[[self getHeaderString:4]];
    }
    else
    {
        return moreNum;
    }

    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)local_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    Bill *bill=nil;
    NSInteger index;
    
    UITableViewCell *cell = [local_tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:simpleTableIdentifier];
        
    }
    
    NSInteger nums[5]={indexPath.row,threeDaysIndex+indexPath.row,oneWeekIndex+indexPath.row,oneMonthIndex+indexPath.row,threeMonthsIndex+indexPath.row};
    
    switch (indexPath.section) {
        case 0:
            index = nums[[self getHeaderString:1]];
            break;
        case 1:
            index = nums[[self getHeaderString:2]];
            break;
        case 2:
            index = nums[[self getHeaderString:3]];
            break;
        case 3:
            index = nums[[self getHeaderString:4]];
            break;
        default:
            index = nums[[self getHeaderString:5]];
            break;
    }
    
    if (searchBarBool) {
        bill = [searchResult objectAtIndex:index];
    }
    else
        bill = [table objectAtIndex:index];
    
    if([bill.title length] > 25)
    {
        NSString *tmp = [bill.title substringToIndex:24];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",tmp,@"..."];
    }
    else
        cell.textLabel.text = bill.title;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@ [%@]",cell.textLabel.text,[Bill dateToNSString:bill.date],bill.category];
    
    /*
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.02f",bill.total];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor redColor];
    */
    
    cell.detailTextLabel.text = nil;
    
    //remove the total label
    id item =[ cell viewWithTag:70];
    [item removeFromSuperview];
    
    //add new total label
    NSString *totalString = [NSString stringWithFormat:@"$%.02f",bill.total];
    CGSize stringSize = [Global getStringSizeWithString:totalString withFontSize:12];
    
    //set width bound
    if (stringSize.width > 90) {
        stringSize.width = 90;
    }
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width - stringSize.width - 30, 7, stringSize.width, stringSize.height)];
    totalLabel.text = totalString;
    totalLabel.font = [UIFont systemFontOfSize:12];
    totalLabel.tag = 70;
    totalLabel.textColor = [UIColor redColor];
    [cell addSubview:totalLabel];
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
   // int indexOfCell = [tableView indexPathForCell:cell].row;
    
    
    if (indexPath.row % 2 == 0) {
        //_cellColor = 1;
        cell.backgroundColor = Rgb2UIColor(204, 255, 246);
    }
    else
    {
        //_cellColor = 0;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchResult removeAllObjects];
    
    if (searchText.length == 0) {
        searchBarBool = NO;
        [self initializeIndexAndNum:table];
        [tableView reloadData];
        return;
    }
    else
        searchBarBool = YES;
    
    int i = 0;
    for (Bill *bill in table) {
        
        if (segmentView.selectedSegmentIndex == SEG_ALL) {
            NSInteger compareTitle = [bill.title rangeOfString:searchText options:NSCaseInsensitiveSearch].location;
            NSInteger compareDate = [[Bill dateToNSString:bill.date] rangeOfString:searchText options:NSCaseInsensitiveSearch].location;
            NSInteger compareCategory = [bill.category rangeOfString:searchText options:NSCaseInsensitiveSearch].location;
            NSInteger compareNote = [bill.description rangeOfString:searchText options:NSCaseInsensitiveSearch].location;
            NSInteger compareTotal = [[NSString stringWithFormat:@"%0.2f",bill.total] rangeOfString:searchText options:NSCaseInsensitiveSearch].location;
           
            if (compareTitle != NSNotFound || compareDate != NSNotFound || compareCategory != NSNotFound || compareNote != NSNotFound || compareTotal != NSNotFound) {

                bill.tmpIndexInMainTable = i;
                [searchResult addObject:bill];
            }
        }
        else if (segmentView.selectedSegmentIndex == SEG_TITLE)
        {
            NSInteger compareTitle = [bill.title rangeOfString:searchText options:NSCaseInsensitiveSearch].location;
            
            if (compareTitle != NSNotFound) {
                bill.tmpIndexInMainTable = i;
                [searchResult addObject:bill];
            }
        }
        else if (segmentView.selectedSegmentIndex == SEG_CATECORY)
        {
            NSInteger compareCategory = [bill.category rangeOfString:searchText options:NSCaseInsensitiveSearch].location;
            
            if (compareCategory != NSNotFound) {
                bill.tmpIndexInMainTable = i;
                [searchResult addObject:bill];
            }
        }
        else if (segmentView.selectedSegmentIndex == SEG_NOTE)
        {
            NSInteger compareNote = [bill.description rangeOfString:searchText options:NSCaseInsensitiveSearch].location;
            
            if (compareNote != NSNotFound) {
                bill.tmpIndexInMainTable = i;
                [searchResult addObject:bill];
            }
        }
        else if (segmentView.selectedSegmentIndex == SEG_TOTAL)
        {
            NSInteger compareTotal = [[NSString stringWithFormat:@"%0.2f",bill.total] rangeOfString:searchText options:NSCaseInsensitiveSearch].location;
            
            if (compareTotal != NSNotFound) {
                bill.tmpIndexInMainTable = i;
                [searchResult addObject:bill];
            }
        }
        else if (segmentView.selectedSegmentIndex == SEG_DATE)
        {
            NSInteger compareDate = [[Bill dateToNSString:bill.date] rangeOfString:searchText options:NSCaseInsensitiveSearch].location;
            
            if (compareDate != NSNotFound) {
                bill.tmpIndexInMainTable = i;
                [searchResult addObject:bill];
            }
        }

        
        
        i++;
    }
    
    [self initializeIndexAndNum:searchResult];
    [tableView reloadData];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"billDetail"]) {
   
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        NSInteger index= 0;
        
        NSInteger nums[5]={indexPath.row,threeDaysIndex+indexPath.row,oneWeekIndex+indexPath.row,oneMonthIndex+indexPath.row,threeMonthsIndex+indexPath.row};
        
        switch (indexPath.section) {
            case 0:
                index = nums[[self getHeaderString:1]];
                break;
            case 1:
                index = nums[[self getHeaderString:2]];
                break;
            case 2:
                index = nums[[self getHeaderString:3]];
                break;
            case 3:
                index = nums[[self getHeaderString:4]];
                break;
            default:
                index = nums[[self getHeaderString:5]];
                break;
        }
        
        Bill *bill;
        if (searchBarBool) {
            bill = [searchResult objectAtIndex:index];
        }
        else
        {
            bill = [table objectAtIndex:index];
            bill.tmpIndexInMainTable = (int)index;
        }
        

        [segue.destinationViewController setBill:bill];
        [segue.destinationViewController setRefresh:true];
    }
}

-(void)initializeIndexAndNum:(NSMutableArray *)_table
{
    
    
    threeDaysIndex = [Bill findInsertIndex:_table withDate:threeDays];
    oneWeekIndex = [Bill findInsertIndex:_table withDate:oneWeek];
    oneMonthIndex = [Bill findInsertIndex:_table withDate:oneMonth];
    threeMonthsIndex = [Bill findInsertIndex:_table withDate:threeMonths];
    
    threeDaysNum= threeDaysIndex;
    oneWeekNum = oneWeekIndex-threeDaysIndex;
    oneMonthNum = oneMonthIndex - oneWeekIndex;
    threeMonthsNum = threeMonthsIndex - oneMonthIndex;
    moreNum = (int)[_table count]-threeMonthsIndex;
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [tableView setUserInteractionEnabled:NO];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchBar endEditing:true];
    [tableView setUserInteractionEnabled:YES];
}

- (IBAction)segmentAction:(id)sender {
}
@end
