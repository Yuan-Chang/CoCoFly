//
//  settingViewController.h
//  Bill Balance organizer
//
//  Created by Anthony on 7/20/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <iAd/iAd.h>

@interface settingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,ADBannerViewDelegate>
{
    
    IBOutlet UITableView *settingTableView;
    IBOutlet UINavigationItem *navigationBar;
    
}

@end
