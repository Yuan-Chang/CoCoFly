//
//  dateViewController.h
//  Bill Balance organizer
//
//  Created by Anthony on 7/29/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dateViewController : UIViewController
{
    IBOutlet UINavigationItem *navigationItem;
    
    IBOutlet UIDatePicker *m_DatePickerView;
    IBOutlet UILabel *m_DisplayDateLabel;
    IBOutlet UIView *m_TopDateView;
}
//- (IBAction)datePickerChang:(id)sender;

@property (nonatomic) NSDate *m_Maximum;
@property (nonatomic) NSDate *m_Minimum;
@property (nonatomic) NSDate *m_Date;
@property (nonatomic) int m_Type;
@property (nonatomic) id m_Delegate;


@end
