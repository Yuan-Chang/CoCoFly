//
//  settingDeleteViewController.h
//  Bill Balance organizer
//
//  Created by Anthony on 7/20/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingDeleteViewController : UIViewController<UIAlertViewDelegate>
{
    
    UINavigationItem *navigationBar;
    UILabel *totalReceiptsNumLabel;
    UILabel *afterReceiptsNumLabel;
    UILabel *periodReceiptsNumLabel;
    UILabel *dateAfterLabel;
    UILabel *dateStartLabel;
    UILabel *dateEndLabel;
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic) UILabel *dateAfterLabel;
@property (nonatomic) UILabel *dateStartLabel;
@property (nonatomic) UILabel *dateEndLabel;

@property NSDate *dateStart;
@property NSDate *dateEnd;
@property NSDate *dateAfter;

- (IBAction)deleteAllBtn:(id)sender;
- (IBAction)deletePeriodBtn:(id)sender;
- (IBAction)deleteAfterBtn:(id)sender;

-(void)countAfter;
-(void)countPeriod;


@end
