//
//  settingIXportViewController.m
//  Bill Balance organizer
//
//  Created by Anthony on 7/20/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "settingIXportViewController.h"
#import "Bill.h"


@interface settingIXportViewController ()

@end

@implementation settingIXportViewController

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
    
    m_scrollView.contentSize = CGSizeMake(320, 450);
    
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

- (IBAction)exportFileSharing:(id)sender {
    
    NSMutableString *csv = [NSMutableString stringWithString:@"Date,Title,Category,Total,Receipt image name,Note"];
    
    NSMutableArray *Bills = [Global getInstance].m_Bills;
    NSUInteger count = [Bills count];
    // provided all arrays are of the same length
    for (NSUInteger i=0; i<count; i++ )
    {
        Bill *bill =[Bills objectAtIndex:i];
        [csv appendFormat:@"\n\"%@\",\"%@\",\"%@\",\"%.02f\",\"%@\",\"%@\"",
         [Bill dateToNSString:bill.date],
         bill.title == nil ? @"":bill.title,
         bill.category,
         bill.total,
         bill.imageFileName == nil?@"":bill.imageFileName,
         bill.description == nil?@"":bill.description];
        // instead of integerValue may be used intValue or other, it depends how array was created
    }
    
    NSString *fileName = nil;
    if (sender != nil) {
        fileName = CSV_EXPORT_FILE_NAME;
    }
    else
        fileName = TEMP_CSV_FILE_NAME;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@",fileName]];
    
    NSError *error;
    BOOL res = [csv writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (!res) {
        NSLog(@"Error %@ while writing to file %@", [error localizedDescription], path );
    }
    
    if (sender != nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"CSV Export" message:@"CSV file export sucessfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];
    }
    
}

- (IBAction)Email:(id)sender {
    
    NSLog(@"email");
    
    NSString *emailTitle = @"CoCoFly CSV file";
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
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",TEMP_CSV_FILE_NAME]];
    
    [self exportFileSharing:nil];
    NSData *file = [NSData dataWithContentsOfFile:path];
    [mc addAttachmentData:file mimeType:@"text/csv" fileName:CSV_EXPORT_FILE_NAME];
    
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
