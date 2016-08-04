//
//  addCategoryViewController.h
//  Bill Balance organizer
//
//  Created by Anthony on 7/27/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addCategoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *m_tableView;
    
}

@end
