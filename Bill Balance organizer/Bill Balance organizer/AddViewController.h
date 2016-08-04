//
//  AddViewController.h
//  Bill Balance organizer
//
//  Created by Anthony on 6/29/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface AddViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextField *titleField;
    IBOutlet UITextField *totalField;
    //IBOutlet UIPickerView *categoryView;
    IBOutlet UITextView *descriptionField;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *categoryLabel;
    IBOutlet UIImageView *cameraImgView;
    
    IBOutlet UIScrollView *scrowView;
    //IBOutlet UIDatePicker *datePickerView;
    
    int categoryIndex;
    NSString *categoryString;
   
    IBOutlet UIImageView *deleteImageBtn;
    
}

- (IBAction)saveButton:(id)sender;
- (IBAction)clearButton:(id)sender;
- (IBAction)dateEdit:(id)sender;
- (IBAction)categoryEdit:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)removeCameraPic:(id)sender;


@property (nonatomic) NSMutableArray *category;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *categoryLabel;
@property (nonatomic,strong) NSDate *dateSelected;


@end
