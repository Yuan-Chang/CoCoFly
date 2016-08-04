//
//  addCategoryViewController.m
//  Bill Balance organizer
//
//  Created by Anthony on 7/27/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "addCategoryViewController.h"
#import "Bill.h"
#import "Global.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface addCategoryViewController ()
{
    NSMutableArray *_categoryList;
    UITextField *_addTextField;
}

@end

@implementation addCategoryViewController

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
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 40)];
    view.backgroundColor = Rgb2UIColor(248, 248, 248);
    _addTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, (view.frame.size.height-25)/2, view.frame.size.width*3/5, 25)];
    _addTextField.backgroundColor = [UIColor whiteColor];
    _addTextField.layer.cornerRadius = 5;
    _addTextField.layer.borderWidth = .5f;
    _addTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _addTextField.delegate = self;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 43, _addTextField.frame.origin.y+3, 40, 20)];
    [btn setTitle:@"Add" forState:UIControlStateNormal];
    [btn setTitleColor:Rgb2UIColor(0, 122, 255) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addToCategoryList:)];
    [btn addGestureRecognizer:tap];
    btn.userInteractionEnabled = true;
   
    [view addSubview:_addTextField];
    [view addSubview:btn];
    [self.view addSubview:view];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    //UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseKeyBoard:)];
    //[m_tableView addGestureRecognizer:tap2];
    
    //m_tableView.userInteractionEnabled = false;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    _categoryList = [Global getInstance].m_CategoryList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_tableView.userInteractionEnabled = false;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    m_tableView.userInteractionEnabled = true;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_categoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [_categoryList objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return false;
    }
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self moveCategoryToOtherCategory:[_categoryList objectAtIndex:indexPath.row] withOther:@"General Expense"];
        [_categoryList removeObjectAtIndex:indexPath.row];
        
        [m_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    // attaching custom actions here
    if (editing) {
        // we're in edit mode
        m_tableView.editing = true;
        
    } else {
        // we're not in edit mode
        m_tableView.editing = false;
    }
}

-(void)moveCategoryToOtherCategory:(NSString*)categoryName withOther:(NSString *)otherName
{
    
    NSMutableDictionary *categories =[Global getInstance].m_Categories;
    NSMutableArray *category = [[categories objectForKey:categoryName]mutableCopy];
    
    NSMutableArray *otherCategory = [[categories objectForKey:otherName]mutableCopy];
    
    if ([category count] > 0) {
        if (otherCategory == nil) {
            otherCategory = [[NSMutableArray alloc]init];
        }
    }
    
    NSString *title = [NSString stringWithFormat:@"(%@)",categoryName];
    
    
    for (Bill *bill in category) {
        
        bill.category = otherName;
        
        if ([bill.title isEqualToString:title]) {
            bill.title = [NSString stringWithFormat:@"(%@)",otherName];
        }
        
        [otherCategory addObject:bill];
    }
    
    [categories removeObjectForKey:categoryName];
    [categories setObject:otherCategory forKey:otherName];
    
}

-(IBAction)addToCategoryList:(id)sender
{
    NSMutableArray *categoryList = [Global getInstance].m_CategoryList;
    
    [_addTextField endEditing:true];
    
    if ([_addTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Category name cannot be empty" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];
        return;
    }
    
    BOOL tag = false;
    for (NSString *s in categoryList) {
        if ([s isEqualToString:_addTextField.text]) {
            tag = true;
            break;
        }
    }
    
    if (tag == false) {
        [categoryList addObject:_addTextField.text];
        [m_tableView reloadData];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Added" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Category name already exists" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];
    
    }
    
    _addTextField.text = @"";
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_addTextField resignFirstResponder];
}

-(IBAction)tapToCloseKeyBoard:(id)sender
{
    if (_addTextField.editing) {
        [_addTextField endEditing:true];
    }
}

@end
