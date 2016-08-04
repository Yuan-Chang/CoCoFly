//
//  StatisticsViewController.h
//  Bill Balance organizer
//
//  Created by Anthony on 6/29/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface StatisticsViewController : UIViewController
{
    
    IBOutlet UILabel *dateDisplayLabel;
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationItem *navigationBar;
    IBOutlet UISegmentedControl *m_segmentView;
    IBOutlet UIView *m_titleView;
    
    IBOutlet UIScrollView *m_mainScrollView;
    IBOutlet UIView *m_graphView;
}

@property (nonatomic,strong) UILabel *dateDisplayLabel;
@property (nonatomic,strong) UIView *m_titleView;
@property (nonatomic,strong) UIView *m_graphView;
@property (nonatomic,strong) UIScrollView *m_mainScrollView;

- (IBAction)showDate:(id)sender;

- (IBAction)indexChanged:(id)sender;

-(void)makeCategoryView;

@end
