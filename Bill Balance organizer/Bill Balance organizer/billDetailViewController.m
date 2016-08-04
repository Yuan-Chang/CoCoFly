//
//  billDetailViewController.m
//  Bill Balance organizer
//
//  Created by Anthony on 7/11/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "billDetailViewController.h"
#import "Global.h"
#import "dateViewController.h"
#import "CategoryViewController.h"

@interface billDetailViewController ()
{
    BOOL _imageFullScreen;
    BOOL _retakePic;
    CGRect _originalImageRect;
    CGSize _originalMainScrollViewSize;
    CGRect _originalMainScrollViewFrame;
    UIImage *_savedImage;
}

@end

@implementation billDetailViewController
{
    NSArray *category;
    
}

@synthesize bill;
@synthesize titleLabel;
@synthesize totalLabel;
@synthesize dateLabel;
@synthesize navigateBar;
@synthesize noteLabel;
@synthesize categoryLabel;
@synthesize dateSelected;

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
    
    _imageFullScreen = false;
    _savedImage = nil;
    
    
    [scrollView setContentSize:CGSizeMake(320, 550)];
    [self setAutomaticallyAdjustsScrollViewInsets:true];
    UITapGestureRecognizer *scrollViewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan:)];
    [scrollView addGestureRecognizer:scrollViewtap];
    
    titleLabel.delegate=self;
    UIView *textFieldView = [Global getTextFieldViewByLabel:titleLabel];
    [scrollView addSubview:textFieldView];
    
    totalLabel.delegate=self;
    textFieldView = [Global getTextFieldViewByLabel:totalLabel];
    [scrollView addSubview:textFieldView];
    
    noteLabel.delegate=self;
    noteLabel.layer.borderWidth=.5f;
    noteLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    noteLabel.layer.cornerRadius=5;
    dateLabel.layer.borderWidth=.5f;
    dateLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    dateLabel.layer.cornerRadius=5;
    UIView *dropDownBtnView = [Global getDropDownViewByLabel:dateLabel withImageName:@"dropDown#6.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateEditBtn:)];
    [dateLabel addGestureRecognizer:tap];
    dateLabel.userInteractionEnabled = true;
    [dropDownBtnView addGestureRecognizer:tap];
    [scrollView addSubview:dropDownBtnView];
    
    categoryLabel.layer.borderWidth=.5f;
    categoryLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    categoryLabel.layer.cornerRadius=5;
    dropDownBtnView = [Global getDropDownViewByLabel:categoryLabel withImageName:@"dropDown#6.png"];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(categoryEditBtn:)];
    [categoryLabel addGestureRecognizer:tap];
    categoryLabel.userInteractionEnabled = true;
    [dropDownBtnView addGestureRecognizer:tap];
    [scrollView addSubview:dropDownBtnView];
    
    [deleteBtn setTintColor:[UIColor redColor]];
    
    self.navigationItem.title = @"Edit the bill";
    //topView.backgroundColor = [Global Rgb2UIColor:248 with:248 with:248];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBtn:)];
    
    UIBarButtonItem *trashBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteBtn:)];
    
    NSArray *actionBtns = @[trashBtn,saveBtn];
    self.navigationItem.rightBarButtonItems = actionBtns;
    
    cameraImgView.userInteractionEnabled = true;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePicture:)];
    [cameraImgView addGestureRecognizer:tap3];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeCameraPic:)];
    [deleteImageBtn addGestureRecognizer:tap];
    
    _retakePic = false;
    
    if (bill.imageFileName != nil) //load image pic in
    {
        UIImage *image = [Global loadImage:bill.imageFileName];
        [self createImageViewByImage:image];
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    m_titleView.backgroundColor = [Global Rgb2UIColor:248 with:248 with:248];
    m_titleView.alpha = 0.95f;
    
    UIImage *emailImg = [Global convertImageSizeToFit:@"e-mail#1" withFrame:CGRectMake(-1, -1, 30, 20)];
    
    UIImageView *emailImgView = [[UIImageView alloc]initWithImage:emailImg];
    emailImgView.frame = CGRectMake(0, 10, 30, 20);
    UITapGestureRecognizer *emailImgViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emailtap:)];
    
    UIView *emailUIView = [[ UIView alloc]initWithFrame:CGRectMake(m_titleView.frame.size.width - 40, 0, 40, 40)];
    [emailUIView addGestureRecognizer:emailImgViewTap];
    emailUIView.userInteractionEnabled = true;
    
    //[emailUIView setBackgroundColor:[UIColor redColor]];
    [emailUIView addSubview:emailImgView];
    [m_titleView addSubview:emailUIView];
    
    //adjust scroll view position 
    self.automaticallyAdjustsScrollViewInsets = false;
    scrollView.frame = CGRectMake(0, m_titleView.frame.origin.y+25, scrollView.frame.size.width, scrollView.frame.size.height);
    
}

-(IBAction)emailtap:(UITapGestureRecognizer*)sender
{
    UIImageView *emailImgView = (UIImageView*)sender.view;
    
    CGRect original_frame = emailImgView.frame;
    
    [UIView animateWithDuration:1.0f animations:^{
    
        float degrees = 0; //the value in degrees
        emailImgView.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
        degrees = 20; //the value in degrees
        emailImgView.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
        degrees = -20;
        emailImgView.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
        
    } completion:^(BOOL finished){
        emailImgView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        emailImgView.frame = original_frame;

    }];
    
    NSString *emailTitle = @"CoCoFly Bill Info";
    
    // To address
    NSArray *toRecipents = nil;
    
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Date: %@\nTitle: %@\nTotal: %0.2f\nCategory: %@\nNote: %@\n",[Bill dateToNSString:bill.date],bill.title,bill.total,bill.category,bill.description];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    //attach file
    
    if (bill.imageFileName != nil) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png",BILL_IMAGE_FOLDER_PATH,bill.imageFileName]];
        
       // [self exportFileSharing:nil];
        NSData *file = [NSData dataWithContentsOfFile:path];
        [mc addAttachmentData:file mimeType:@"image/png" fileName:bill.imageFileName];
    }
    
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    if (self.refresh) {
        titleLabel.text = bill.title;
        totalLabel.text = [NSString stringWithFormat:@"%.02f",bill.total];
        noteLabel.text = bill.description;
        dateLabel.text = [Bill dateToNSString:bill.date];
        categoryLabel.text = bill.category;
        
        category =[Global getInstance].m_CategoryList;
        
        dateSelected = bill.date;
        
        self.refresh = false;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    
    return [category objectAtIndex:row];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [category count];
    
}


//set the detail of picker view label
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)]; // your frame, so picker gets "colored"
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    label.text = category[row];
    
    return label;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    //return 162.0f;
    return 40.0f;
}


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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)dateEditBtn:(id)sender {
    
    dateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"dateView"];
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    controller.m_Maximum = [Bill setBeginningOfTheDate:[NSDate date]];
    controller.m_Date = [Bill setBeginningOfTheDate:bill.date];
    controller.m_Type = DATEVIEW_DETAILVIEW;
    controller.m_Delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
 }

- (IBAction)categoryEditBtn:(id)sender {
    
    CategoryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"categoryView"];
    
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    controller.m_Type = CATEGORYVIEW_DETAILVIEW;
    controller.m_Delegate = self;
    controller.m_CategoryName = categoryLabel.text;
    [self presentViewController:controller animated:YES completion:nil];
  
}

- (IBAction)saveBtn:(id)sender {
    
    //alert
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Bill" message:@"Are you sure to make changes to this bill?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 1;
    [alert show];
    
}

- (IBAction)deleteBtn:(id)sender {
    
    //alert
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Bill" message:@"Are you sure to remove this bill?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 2;
    [alert show];
    
}

//react for alertView yes and no
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == 1 && buttonIndex == 1)
    {
        //save the bill
        
        [Global blockViewStartWithController:self withStartTag:TAG_FOR_BLOCKVIEW];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
            Bill *tmpbill = [[Bill alloc] init];
            tmpbill.title = titleLabel.text;
            
            tmpbill.description = noteLabel.text;
            tmpbill.total = [totalLabel.text integerValue];
            tmpbill.date = dateSelected;
            tmpbill.category =categoryLabel.text;
            tmpbill.billID = bill.billID;
            
            //check title is empty, give it a default name
            if ([tmpbill.title isEqualToString:@""]) {
                tmpbill.title = [NSString stringWithFormat:@"(%@)",categoryLabel.text];
            }
            
            NSString *string = [NSString stringWithFormat:@"(%@)",bill.category];
            
            //if title is a default name, renew its default name match its category
            if ([tmpbill.title isEqualToString:string]) {
                tmpbill.title = [NSString stringWithFormat:@"(%@)",tmpbill.category];
            }
            
            
            
            if (_retakePic == true) //if user retook the pic, we should renew it
            {
                _retakePic = false;
                
                //remove the original one first
                if (bill.imageFileName != nil) {
                    [Global removeImageWithFileName:bill.imageFileName];
                    bill.imageFileName = nil;
                }
                
                //assing a new image name
                tmpbill.imageFileName = [NSString stringWithFormat:@"%@#%@",bill.title,[Bill dateToNSStringToSecond:[NSDate date]]];
                
                //save the image
                [Global saveImage:_savedImage withFileName:tmpbill.imageFileName];
            }
            else
            {
                tmpbill.imageFileName = bill.imageFileName;
            }
            
            NSMutableArray *bills =[Global getInstance].m_Bills;
            Bill *bill2 = [bills objectAtIndex:bill.tmpIndexInMainTable];
            
            float total = tmpbill.total - bill2.total;
            total = total + [Global getInstance].m_Total;
            [Global getInstance].m_Total = total;
            
            [bills removeObjectAtIndex:bill.tmpIndexInMainTable];
            
            //need to change category list here
            NSMutableDictionary *_categories = [Global getInstance].m_Categories;
            NSMutableArray *_category = [[_categories objectForKey:bill2.category]mutableCopy];
            [Bill removeFromCategory:_category withBill:bill2];
            
            if ( [_category count] == 0) {
                [_categories removeObjectForKey:bill2.category];
            }
            else
                [_categories setObject:_category forKey:bill2.category];
            
            _category = [[_categories objectForKey:tmpbill.category]mutableCopy];
            if (_category == nil) {
                _category = [[NSMutableArray alloc]init];
            }
            
            [Bill insertToCategory:_category withBill:tmpbill];
            
            [_categories setObject:_category forKey:tmpbill.category];
            
            
            if ([bill2.date compare:tmpbill.date ] == NSOrderedSame)
            {
                [bills insertObject:tmpbill atIndex:bill.tmpIndexInMainTable];
            }
            else
            {
                [bills insertObject:tmpbill atIndex:[Bill findInsertIndex:bills withDate:tmpbill.date]];
            }
            
            //save changes back to bill
            bill.title = titleLabel.text;
            bill.description = noteLabel.text;
            bill.total = tmpbill.total;
            bill.date = dateSelected;
            bill.category = categoryLabel.text;
            bill.imageFileName = tmpbill.imageFileName;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Global blockViewEndWithController:self withStartTag:TAG_FOR_BLOCKVIEW];
                
                //alert
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Bill" message:@"Changes have been saved" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
            });
        
        });
        
        
        
        
    }
    else if ( alertView.tag == 2 && buttonIndex == 1)
    {
        //remove the bill
        
        float total = [Global getInstance].m_Total;
        total = total - bill.total;
        [Global getInstance].m_Total = total;
        
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
        
        //remove image file
        if (bill.imageFileName != nil) {
            [Global removeImageWithFileName:bill.imageFileName];
        }

        //remove from bill list
        NSMutableArray *bills =[Global getInstance].m_Bills;
        [bills removeObjectAtIndex:bill.tmpIndexInMainTable];
        
        //put id back for reuse
        [[Global getInstance] putIDBackToPool:bill.billID];
        
        
        //alert
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Bill" message:@"Bill has been deleted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        alert.tag = 3;
        [alert show];
        
    }
    else if ( alertView.tag == 3 && buttonIndex == 0)
    {
        //Go back to previous page
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (buttonIndex == 1 && alertView.tag == 40) {
        UIView *view = (UIView*)[scrollView viewWithTag:40];
        [view removeFromSuperview];
        deleteImageBtn.hidden = true;
        deleteImageBtn.userInteractionEnabled =false;
        scrollView.contentSize = _originalMainScrollViewSize;
        
        _retakePic = false; //control save image or not
        if (bill.imageFileName != nil) {
            [Global removeImageWithFileName:bill.imageFileName];
            bill.imageFileName = nil;
        }
        
    }
    
}

-(IBAction)touchesBegan:(id)sender
{
    [self.view endEditing:true];
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

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)local_scrollView
{
    return [local_scrollView viewWithTag:41];
}

-(void)createImageViewByImage:(UIImage*)image
{
    UIView *preView = (UIView*)[scrollView viewWithTag:40];
    
    if (preView != nil) {
        [preView removeFromSuperview];
        deleteImageBtn.hidden = true;
        deleteImageBtn.userInteractionEnabled =false;
        scrollView.contentSize = _originalMainScrollViewSize;
    }
    
    UIView *view = [[UIScrollView alloc]initWithFrame:CGRectMake(15, cameraImgView.frame.origin.y+50, 290, 450)];
    
    view.tag = 40;
    view.layer.borderWidth = 1.0f;
    view.layer.cornerRadius = 10;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 55, 260, 370)];
    imageView.tag = 41;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:) ];
    [imageView addGestureRecognizer:tap];
    [imageView setUserInteractionEnabled:true];
    [imageView setImage:image];
    
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
    
    
    [scrollView addSubview: view];
    [scrollView sizeToFit];
    _originalMainScrollViewSize =scrollView.contentSize;
    [scrollView setContentSize:CGSizeMake(320, scrollView.frame.size.height+view.frame.size.height+50)];
    [scrollView setContentOffset:CGPointMake(0, cameraImgView.frame.origin.y+55)];
    
    deleteImageBtn.hidden = false;
    deleteImageBtn.userInteractionEnabled = true;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _retakePic = true;
    
    _savedImage = [Global scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    [self createImageViewByImage:_savedImage];
    
    
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
        [[scrollView viewWithTag:40] addSubview:view];
        view.frame = _originalImageRect;
        
        _imageFullScreen = false;
        
        [scrollView setContentSize:CGSizeMake(320, scrollView.frame.size.height+[scrollView viewWithTag:40].frame.size.height+50)];
        
        [scrollView setContentOffset:CGPointMake(0, cameraImgView.frame.origin.y+55) animated:NO];
        
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

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
