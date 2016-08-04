//
//  SearchViewController.h
//  Bill Balance organizer
//
//  Created by Anthony on 6/29/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    
    IBOutlet UITableView *tableView;
    IBOutlet UISegmentedControl *segmentView;
    
}

- (IBAction)segmentAction:(id)sender;

@end
