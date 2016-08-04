//
//  CategoryViewController.h
//  Bill Balance organizer
//
//  Created by Anthony on 7/30/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIPickerView *m_CategoryPicker;
    IBOutlet UIView *m_TopView;
    
    IBOutlet UILabel *m_CategoryDisplayLabel;
    
    
}

@property(nonatomic) id m_Delegate;
@property(nonatomic) NSString *m_CategoryName;
@property(nonatomic) int m_Type;

@end
