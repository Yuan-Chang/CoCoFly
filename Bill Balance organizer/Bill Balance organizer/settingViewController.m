//
//  settingViewController.m
//  Bill Balance organizer
//
//  Created by Anthony on 7/20/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "settingViewController.h"

@interface settingViewController ()
{
    NSArray *cellNames;
}

@end

@implementation settingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    [settingTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    cellNames =[[NSArray alloc] initWithObjects:@"Edit categories", @"Delete bills",@"Export CSV file",@"Export PDF file",@"Support", nil];
    
    navigationBar.title = @"Setting";
    
    settingTableView.multipleTouchEnabled = false;
    
    ADBannerView *bannerView = [[ADBannerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 50)];
    bannerView.delegate = self;
    bannerView.alpha = 0;
    [self.view addSubview:bannerView];
    [self.view bringSubviewToFront:bannerView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *path = [settingTableView indexPathForSelectedRow];
    UITableViewCell *cell = [settingTableView cellForRowAtIndexPath:path];
    cell.selected = false;
    cell.highlighted = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cellNames count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        [self supportEmailTap:nil];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = nil;
    
    if (indexPath.row == 0) {
        cellIndentifier = @"addCategoriesCell";
    }
    else if (indexPath.row == 1) {
        cellIndentifier = @"deleteReceiptCell";
    }
    else if (indexPath.row == 2)
    {
        cellIndentifier = @"IXportCell";
    }
    else if (indexPath.row == 3)
    {
        cellIndentifier = @"XportPDFCell";
    }
    else if (indexPath.row == 4)
    {
        cellIndentifier = @"SupportCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIndentifier];
    }
   
    cell.textLabel.text = [cellNames objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(0.05*cell.frame.size.width, cell.frame.size.height-1, cell.frame.size.width*0.8, 1)];
    [Line setBackgroundColor:[UIColor lightGrayColor]];
    [Line setAlpha:0.8f];
    [cell addSubview:Line];
    
    return cell;
}

-(IBAction)supportEmailTap:(UITapGestureRecognizer*)sender
{
    //UITableViewCell *cell = (UITableViewCell*)sender.view;
    //cell.highlighted = true;
    
    NSString *emailTitle = @"CoCoFly Support";
    // Email Content
    NSString *messageBody = nil;
    // To address
    NSArray *toRecipents = @[@"simplebutwork@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    
    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
