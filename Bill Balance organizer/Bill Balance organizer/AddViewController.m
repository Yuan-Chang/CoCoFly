//
//  AddViewController.m
//  Bill Balance organizer
//
//  Created by Anthony on 6/29/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "AddViewController.h"
#import "Bill.h"
#import "billDetailViewController.h"
#import "Global.h"
#import "dateViewController.h"
#import "CategoryViewController.h"

@interface AddViewController ()
{
    BOOL _imageFullScreen;
    CGRect _originalImageRect;
    CGSize _originalMainScrollViewSize;
    CGRect _originalMainScrollViewFrame;
    UIImage *_savedImage;
    UIActivityIndicatorView *_spinner;
    //UIScrollView *_imageScrollView;
}

@end

@implementation AddViewController

@synthesize category,categoryLabel,dateLabel,dateSelected;

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
    
    _imageFullScreen = false;
    _savedImage = nil;
    
    //init spinner
    _spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.navigationItem.title = @"Add new bill";
    
    [scrowView setContentSize:CGSizeMake(320, 550)];
    [self setAutomaticallyAdjustsScrollViewInsets:false];
    UITapGestureRecognizer *scrollViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan:)];
    [scrowView addGestureRecognizer:scrollViewTap];
    
    // Do any additional setup after loading the view.
    titleField.delegate=self;
    UIView *textFieldView = [Global getTextFieldViewByLabel:titleField];
    [scrowView addSubview:textFieldView];
    
    totalField.delegate=self;
    textFieldView = [Global getTextFieldViewByLabel:totalField];
    [scrowView addSubview:textFieldView];
    
    descriptionField.delegate=self;
    descriptionField.layer.borderWidth=.5f;
    descriptionField.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    descriptionField.layer.cornerRadius=5;
    dateLabel.layer.borderWidth=.5f;
    dateLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    dateLabel.layer.cornerRadius=5;
    dateLabel.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateEdit:)];
    
    [dateLabel addGestureRecognizer:tap];
    UIView *dropDownBtnView = [Global getDropDownViewByLabel:dateLabel withImageName:@"dropDown#6.png"];
    [dropDownBtnView addGestureRecognizer:tap];
    [scrowView addSubview:dropDownBtnView];
    
    categoryLabel.layer.borderWidth=.5f;
    categoryLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    categoryLabel.layer.cornerRadius=5;
    categoryLabel.userInteractionEnabled = true;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryEdit:)];
    [categoryLabel addGestureRecognizer:tap2];
    dropDownBtnView = [Global getDropDownViewByLabel:categoryLabel withImageName:@"dropDown#6.png"];
    [dropDownBtnView addGestureRecognizer:tap2];
    [scrowView addSubview:dropDownBtnView];
    
    cameraImgView.userInteractionEnabled = true;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePicture:)];
    [cameraImgView addGestureRecognizer:tap3];
    
    
    
    dateSelected = [Bill setBeginningOfTheDate:[NSDate date]];
    dateLabel.text = [Bill dateToNSString:dateSelected];
    categoryLabel.text = @"General Expense";
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButton:)];
    UIBarButtonItem *resetBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(clearButton:)];
    addBtn.style = UIBarButtonItemStyleBordered;
    //NSArray *actionBtns = @[resetBtn,addBtn];
    self.navigationItem.rightBarButtonItem = addBtn;
    self.navigationItem.leftBarButtonItem = resetBtn;
    
    
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeCameraPic:)];
    [deleteImageBtn addGestureRecognizer:tap];
    
    _originalMainScrollViewSize = scrowView.contentSize;
}

-(void)viewWillAppear:(BOOL)animated
{
    category = [Global getInstance].m_CategoryList;
    
    self.navigationItem.hidesBackButton = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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
/*
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *tView =(UILabel*)view;
    if (!tView) {
        tView = [[UILabel alloc]init];
        tView.font =[UIFont systemFontOfSize:12];
    }
    return tView;
}*/




- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)saveButton:(id)sender {
    
    //show block view
    [Global blockViewStartWithController:self withStartTag:TAG_FOR_BLOCKVIEW];
    
    //use another thread for saving data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        Bill *bill = [[Bill alloc] init];
        bill.title = titleField.text;
        
        bill.description = descriptionField.text;
        bill.total = [totalField.text floatValue];
        bill.date = [Bill setBeginningOfTheDate:dateSelected];
      
        bill.category =categoryLabel.text;
        bill.billID = [[Global getInstance] getIDFromPool];
        
        if ([bill.title isEqualToString:@""]) {
            bill.title = [NSString stringWithFormat:@"(%@)",categoryLabel.text];
        }
        
        if (_savedImage != nil) //if user took a pic
        {
            bill.imageFileName = [NSString stringWithFormat:@"%@#%@",bill.title,[Bill dateToNSStringToSecond:[NSDate date]]];
            
            //save the image
            [Global saveImage:_savedImage withFileName:bill.imageFileName];
            _savedImage = nil;
        }
        else
            bill.imageFileName = nil;
        
        if ([[Global getInstance].m_Bills count] == 0) {
            NSMutableArray *bills =[Global getInstance].m_Bills;
            NSMutableDictionary *_categories = [Global getInstance].m_Categories;
            NSMutableArray *_category = [[NSMutableArray alloc]init];
            
            [Bill insertToCategory:_category withBill:bill];
            //[_category addObject:bill];
            [_categories setObject:_category forKey:bill.category];
            
            [bills addObject:bill];
        }
        else
        {
            NSMutableDictionary *_categories = [Global getInstance].m_Categories;
            NSMutableArray *_category = [[_categories objectForKey:bill.category] mutableCopy];
            
            if (_category == nil) {
                _category = [[NSMutableArray alloc]init];
            }
            
            //[_category addObject:bill];
            [Bill insertToCategory:_category withBill:bill];
            [_categories setObject:_category forKey:bill.category];
            
            NSMutableArray *bills =[Global getInstance].m_Bills;
            int index = [Bill findInsertIndex:bills withDate:bill.date];
            
            [bills insertObject:bill atIndex:index];
        }
        
        float total = [Global getInstance].m_Total;
        total = total + bill.total;
        [Global getInstance].m_Total = total;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Global blockViewEndWithController:self withStartTag:TAG_FOR_BLOCKVIEW];

            //alert
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Bill" message:@"Bill has been saved" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            alert.tag = 40;
            [alert show];
            
            //reset
            [self reset];
            //[self.view setUserInteractionEnabled:true];
        });
    });
    
}

-(void)saveOperation
{
    
    
}

- (IBAction)clearButton:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Reset" message:@"Reset all filled fields of this bill?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    alert.tag = 41;
    
    [alert show];
    
    
}

- (IBAction)dateEdit:(id)sender {
    
    dateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"dateView"];
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    controller.m_Maximum = [Bill setBeginningOfTheDate:[NSDate date]];
    controller.m_Date = [Bill setBeginningOfTheDate:dateSelected];
    controller.m_Type = DATEVIEW_ADDVIEW;
    controller.m_Delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)touchesBegan:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)categoryEdit:(id)sender {

    CategoryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"categoryView"];
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    controller.m_Type = CATEGORYVIEW_ADDVIEW;
    controller.m_Delegate = self;
    controller.m_CategoryName = categoryLabel.text;
    [self presentViewController:controller animated:YES completion:nil];

}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == totalField) {
        if ([string isEqualToString:@"."]) {
            
            if (textField.text.length == 0) {
                return false;
            }
            else if ([textField.text rangeOfString:@"."].location != NSNotFound)
            {
                return false;
            }
        }
    }
    
    return true;
}

-(IBAction)takePicture:(id)sender
{
    [self startCameraControllerFromViewController: self
                                usingDelegate: self];
}

- (IBAction)removeCameraPic:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Sure to delete the picture" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    alert.tag = 40;
    [alert show];
    //imageView = nil;
    
}

-(void)reset
{
    titleField.text=@"";
    totalField.text=@"";
    descriptionField.text=@"";
    
    categoryLabel.text = @"General Expense";
    dateSelected = [Bill setBeginningOfTheDate:[NSDate date]];
    dateLabel.text = [Bill dateToNSString:dateSelected];
    
    _savedImage = nil;
    [[scrowView viewWithTag:40]removeFromSuperview];
    
    scrowView.contentSize = _originalMainScrollViewSize;
    
    self.navigationItem.hidesBackButton = true;
    
    [self.view endEditing:true];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 40) {
        UIView *view = (UIView*)[scrowView viewWithTag:40];
        [view removeFromSuperview];
        deleteImageBtn.hidden = true;
        deleteImageBtn.userInteractionEnabled =false;
        scrowView.contentSize = _originalMainScrollViewSize;
    }
    else if (buttonIndex == 1 && alertView.tag == 41)
    {
        [self reset];
    }
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    [controller presentViewController:cameraUI animated:YES completion:nil];
    //[controller presentModalViewController: cameraUI animated: YES];
    return YES;
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:41];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIView *preView = (UIView*)[scrowView viewWithTag:40];
    
    if (preView != nil) {
        [preView removeFromSuperview];
        deleteImageBtn.hidden = true;
        deleteImageBtn.userInteractionEnabled =false;
        scrowView.contentSize = _originalMainScrollViewSize;
    }
    
    UIView *view = [[UIScrollView alloc]initWithFrame:CGRectMake(15, cameraImgView.frame.origin.y+50, 290, 450)];
    
    view.tag = 40;
    view.layer.borderWidth = 1.0f;
    view.layer.cornerRadius = 10;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    
    _savedImage = [Global scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 55, 260, 370)];
    imageView.tag = 41;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:) ];
    [imageView addGestureRecognizer:tap];
    [imageView setUserInteractionEnabled:true];
    [imageView setImage:_savedImage];
    
    UIImageView *zoomInImageBtn = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width-90, 8, 25, 25)];
    zoomInImageBtn.image = [UIImage imageNamed:@"zoomIn#1"];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
    zoomInImageBtn.userInteractionEnabled = true;
    zoomInImageBtn.tag = 100;
    [zoomInImageBtn addGestureRecognizer:tap];
    [view addSubview:zoomInImageBtn];
    
    
    deleteImageBtn.frame = CGRectMake(view.frame.size.width-30, 8, 25, 25);
    [view addSubview:deleteImageBtn];
    [view addSubview:imageView];
    
    
    
    [scrowView addSubview: view];
    [scrowView sizeToFit];
    _originalMainScrollViewSize =scrowView.contentSize;
    [scrowView setContentSize:CGSizeMake(320, scrowView.frame.size.height+view.frame.size.height+50)];
    [scrowView setContentOffset:CGPointMake(0, cameraImgView.frame.origin.y+55)];
    
    deleteImageBtn.hidden = false;
    deleteImageBtn.userInteractionEnabled = true;
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

-(void)imageTap:(UIGestureRecognizer *)sender
{
    UIImageView *view = (UIImageView*)sender.view;
    
    //from zoom in imageview
    if (view.tag == 100) {
        view = (UIImageView*)[[view superview] viewWithTag:41];
    }
    
    if (_imageFullScreen == true) {
        
        view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        ((UIScrollView*)[view superview]).delegate =nil;
        [[view superview] removeFromSuperview];
        [[scrowView viewWithTag:40] addSubview:view];
        view.frame = _originalImageRect;
        
        _imageFullScreen = false;
        
        [scrowView setContentSize:CGSizeMake(320, scrowView.frame.size.height+[scrowView viewWithTag:40].frame.size.height+50)];
        
        [scrowView setContentOffset:CGPointMake(0, cameraImgView.frame.origin.y+55) animated:NO];
        
        /*
        [view removeFromSuperview];
        [[scrowView viewWithTag:40] addSubview:view];
        [scrowView viewWithTag:40].hidden = false;
        view.frame = _originalImageRect;
        _imageFullScreen = false;
        
        [scrowView setContentSize:CGSizeMake(320, scrowView.frame.size.height+[scrowView viewWithTag:40].frame.size.height+50)];
        
        [scrowView setContentOffset:CGPointMake(0, view.frame.origin.y) animated:NO];
        scrowView.frame = _originalMainScrollViewFrame;
        scrowView.delegate = nil;
        */
         
        [self.navigationController setNavigationBarHidden:NO];
        [self.tabBarController.tabBar setHidden:false];
    }
    else
    {
        _originalImageRect = view.frame;
        UIScrollView *tmpScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        [view removeFromSuperview];
        [tmpScrollView addSubview:view];
        view.frame = self.view.frame;
        tmpScrollView.contentSize = CGSizeMake(view.frame.size.width+3, view.frame.size.height+3);
        [tmpScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        tmpScrollView.backgroundColor = [UIColor blackColor];
        tmpScrollView.minimumZoomScale = 1;
        tmpScrollView.maximumZoomScale =4;
        tmpScrollView.delegate = self;
        tmpScrollView.tag = 45;
        [self.view addSubview:tmpScrollView];
        
        _imageFullScreen = true;
        
        //_originalImageRect = view.frame;
        //_originalMainScrollViewFrame = scrowView.frame;
        /*[scrowView viewWithTag:40].hidden = true;
        [view removeFromSuperview];
        [scrowView addSubview:view];
        scrowView.frame = self.view.frame;
        view.frame = self.view.frame;
        _imageFullScreen = true;
        scrowView.contentSize = CGSizeMake(view.frame.size.width+3, view.frame.size.height+3);
        
        [scrowView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        scrowView.minimumZoomScale = 1;
        scrowView.maximumZoomScale =2;
        scrowView.delegate = self;
        */
        [self.navigationController setNavigationBarHidden:YES];
        [self.tabBarController.tabBar setHidden:true];
    }
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //UIImageView *image = (UIImageView*)[[self.view viewWithTag:45] viewWithTag:41];
    //image.frame = [self centeredFrameForScrollView:(UIScrollView*)[self.view viewWithTag:45] andUIView:image];
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width -frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height -frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}



@end
