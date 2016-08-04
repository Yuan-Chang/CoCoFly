//
//  settingXportPDFViewController.m
//  Bill Balance organizer
//
//  Created by Anthony on 7/20/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "settingXportPDFViewController.h"
#import "Bill.h"

@interface settingXportPDFViewController ()
{
    CGSize _pageSize;
}

@end

@implementation settingXportPDFViewController

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

    m_mainScrollView.contentSize = CGSizeMake(320, 450);
    
    float width = 250;
    m_fileSharingBtn.frame = CGRectMake((self.view.frame.size.width-width)/2, 20, width, 50);
    m_emailBtn.frame = CGRectMake((self.view.frame.size.width-width)/2, m_fileSharingBtn.frame.origin.y+70, width, m_fileSharingBtn.frame.size.height);
    
    [self setBtnStyleWithBtn:m_fileSharingBtn];
    [self setBtnStyleWithBtn:m_emailBtn];
    
}

- (void)setBtnStyleWithBtn:(UIButton*)button
{
    button.layer.borderWidth = 0.5f;
    button.layer.cornerRadius = 8;
    
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

- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height
{
    _pageSize = CGSizeMake(width, height);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:name];
    
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);

}

- (IBAction)exportFileSharing:(id)sender {
   
    if (sender != nil) {
        [self setupPDFDocumentNamed:PDF_EXPORT_FILE_NAME Width:612 Height:792];
    }
    else
    {
        [self setupPDFDocumentNamed:TEMP_PDF_EXPORT_FILE_NAME Width:612 Height:792];
    }
    
    
    [self drawPDF];
    
    UIGraphicsEndPDFContext();
    
    if (sender != nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Export PDF" message:@"The pdf file has been exported" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

-(void)drawPDF
{
    //UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 200, 300), nil);
    UIGraphicsBeginPDFPage();
    
    NSArray *Bills = [Global getInstance].m_Bills;
    NSString *text;
    
    float headMargin = 20;
    float endMargin = 5;
    float currantY = 20;
    
    text = [NSString stringWithFormat:@"CoCoFly Bills Summary"];
    CGSize headerRectSize1 = [self stringSize:text withFontSize:22];
    CGRect TitleRect1 = [self addText:text withFrame:CGRectMake((_pageSize.width-headerRectSize1.width)/2, currantY, 300, 360) fontSize:22 withTextRectSize:headerRectSize1];
    currantY += headerRectSize1.height+15;
    
    text = [NSString stringWithFormat:@"Total bills       :  # %lu\nTotal amount :  $ %0.2f",(unsigned long)[Bills count],[Global getInstance].m_Total];
    CGSize headerRectSize2 = [self stringSize:text withFontSize:16];
    CGRect TitleRect2 = [self addText:text withFrame:CGRectMake(TitleRect1.origin.x, currantY, 300, 300) fontSize:16 withTextRectSize:headerRectSize2];
    //currantY += headerRectSize2.height+50;
    
    CGRect topLineRect = [self addLineWithFrame:CGRectMake(15, TitleRect2.origin.y + TitleRect2.size.height+20, _pageSize.width - 15*2, 2) withColor:[UIColor blackColor]];
    
    currantY = topLineRect.origin.y + endMargin;
    
    for (int i = 0; i<[Bills count];i++ ) {
        
        Bill *bill = Bills[i];
        //bill.description = @"wwwwwwwwwwwwwjjjwjwjwjwjwwjwjwjwj";
        text = [NSString stringWithFormat:@"#%d\nDate:  %@\nTitle:  %@\nTotal:  %0.2f\nCategory:  %@\nReceipt image name:  %@\nNote:%@",i,[Bill dateToNSString:bill.date],bill.title,bill.total,bill.category,bill.imageFileName == nil? @"(None)":[NSString stringWithFormat:@"%@.png",bill.imageFileName],bill.description==nil?@"(None)":bill.description];
        
        CGSize textRectSize = [self stringSize:text withFontSize:14];
        
        if (currantY+textRectSize.height+endMargin > _pageSize.height) {
            UIGraphicsBeginPDFPage();
            currantY = 30;
        }
        
        CGRect textRect = [self addText:text withFrame:CGRectMake(15, currantY, 300, 300) fontSize:14 withTextRectSize:textRectSize];
        
        
        CGRect blackLineRect = [self addLineWithFrame:CGRectMake(15, textRect.origin.y + textRect.size.height+endMargin, _pageSize.width - 15*2, 2) withColor:[UIColor blackColor]];
        
        //CGRect imageRect = [self addImage:[Global loadImage:bill.imageFileName] atPoint:CGPointMake(300, textRect.origin.y)];

        currantY = blackLineRect.origin.y + headMargin;
    }
    
    
    
    
    //UIGraphicsBeginPDFPage();
    
    //textRect = [self addText:@"second text?"withFrame:CGRectMake(kPadding, kPadding, 400, 700) fontSize:48.0f];
    
    //blueLineRect = [self addLineWithFrame:CGRectMake(kPadding, textRect.origin.y + textRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) withColor:[UIColor blueColor]];
    
}

-(CGSize)stringSize:(NSString *)text withFontSize:(int)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    return [text boundingRectWithSize:CGSizeMake(_pageSize.width - 2*20-2*20, _pageSize.height - 2*20 - 2*20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;

}

- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize withTextRectSize:(CGSize)stringSize
{
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    float textWidth = frame.size.width;
    
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > _pageSize.width)
        textWidth = _pageSize.width - frame.origin.x;
    
    CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    
    NSDictionary *attr = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSBackgroundColorAttributeName:[UIColor whiteColor]};
    
    [text drawInRect:renderingRect withAttributes:attr];
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    return frame;
}

-   (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    
    // this is the thickness of the line
    CGContextSetLineWidth(currentContext, frame.size.height);
    
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    return frame;
}

- (CGRect)addImage:(UIImage*)image atPoint:(CGPoint)point
{
    float ratio = image.size.height / image.size.width;
    
    CGRect imageFrame = CGRectMake(point.x, point.y, 200, 200*ratio);
    [image drawInRect:imageFrame];
    
    return imageFrame;
}

- (IBAction)exportEmail:(id)sender {
    NSString *emailTitle = @"CoCoFly PDF file";
    // Email Content
    NSString *messageBody = @"File is attached.";
    // To address
    NSArray *toRecipents = nil;
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    //attach file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",TEMP_PDF_EXPORT_FILE_NAME]];
    
    [self exportFileSharing:nil];
    NSData *file = [NSData dataWithContentsOfFile:path];
    [mc addAttachmentData:file mimeType:@"application/pdf" fileName:PDF_EXPORT_FILE_NAME];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:path error: &error];
    
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
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
