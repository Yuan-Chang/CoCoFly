//
//  settingXportPDFViewController.h
//  Bill Balance organizer
//
//  Created by Anthony on 7/20/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface settingXportPDFViewController : UIViewController<UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
{

    IBOutlet UIScrollView *m_mainScrollView;
    IBOutlet UIButton *m_fileSharingBtn;
    IBOutlet UIButton *m_emailBtn;
}

- (IBAction)exportFileSharing:(id)sender;
- (IBAction)exportEmail:(id)sender;



@end
