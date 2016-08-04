//
//  billDetailViewController.h
//  Bill Balance organizer
//
//  Created by Anthony on 7/11/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"
#import <MessageUI/MessageUI.h>

@interface billDetailViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UINavigationItem *navigateBar;
    IBOutlet UITextField *titleLabel;
    IBOutlet UITextField *totalLabel;
    IBOutlet UITextView *noteLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *categoryLabel;
    IBOutlet UIBarButtonItem *deleteBtn;
    //IBOutlet UIView *topView;
    
    IBOutlet UIImageView *cameraImgView;
    IBOutlet UIImageView *deleteImageBtn;
    
    IBOutlet UIScrollView *scrollView;
    Bill *bill;
    
    
    IBOutlet UIView *m_titleView;
    
}

@property (strong, nonatomic) IBOutlet UINavigationItem *navigateBar;
@property (strong, nonatomic) IBOutlet UITextField *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *totalLabel;
@property (strong, nonatomic) IBOutlet UITextView *noteLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet NSDate *dateSelected;
@property Bill *bill;
@property BOOL refresh;

- (IBAction)deleteBtn:(id)sender;

- (IBAction)dateEditBtn:(id)sender;
- (IBAction)categoryEditBtn:(id)sender;
- (IBAction)saveBtn:(id)sender;
//- (IBAction)deleteBtn:(id)sender;


@end
