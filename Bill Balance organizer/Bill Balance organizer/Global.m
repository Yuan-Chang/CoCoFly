//
//  Global.m
//  Bill Balance organizer
//
//  Created by Anthony on 7/27/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "Global.h"
#import "Bill.h"
#import "PieGraphElement.h"

@implementation Global
@synthesize m_Bills,m_Categories,m_CategoryList,m_CustomDate,m_Total,m_IDPool;
@synthesize m_Colors,m_summary_mode_index;

static Global *instance;

+(Global*)getInstance
{
    //instance = nil;
    if (instance == nil) {
        instance = [[Global alloc]init];
    }
    return instance;
}

-(id)init
{
    self =[super init];
    self.m_Bills = [[NSMutableArray alloc]init];
    self.m_Categories = [[NSMutableDictionary alloc]init];
    self.m_CategoryList = [[NSMutableArray alloc]init];
    self.m_Total = 0;
    self.m_CustomDate = nil;
    self.m_summary_mode_index = 0;
    
    return self;
}


-(void)readIn
{
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSArray *dataArray = [data arrayForKey:@"Bills"];
    
    for (NSData *data in dataArray) {
        Bill *bill = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSMutableArray *category = [m_Categories objectForKey:bill.category];
        
        if (category == nil) {
            category = [[NSMutableArray alloc]init];
        }

        [m_Bills addObject:bill];
        [category addObject:bill];
        [m_Categories setObject:category forKey:bill.category];
        
    }
    
    NSArray *categoryList = [data arrayForKey:@"categoryList"];
    //categoryList = nil;
    if (categoryList == nil) {
        //[m_CategoryList addObject:@"General Expense"];
        NSArray *list = [[NSArray alloc]initWithObjects:@"General Expense",@"Bills",@"Food",@"Insurance",@"Entertainment",@"Education",@"Medical",@"Social", nil];
        [m_CategoryList addObjectsFromArray:list];
    }
    else if ([categoryList count]==0)
    {
        [m_CategoryList addObject:@"General Expense"];
    }
    else
        [m_CategoryList addObjectsFromArray:categoryList];
    
    //[data setObject:nil forKey:@"customDate"];
    m_CustomDate = [data objectForKey:@"customDate"];
    if (m_CustomDate == nil) {
        m_CustomDate = [Bill setBeginningOfTheDate:[NSDate date]];
    }
    
    m_Total = [data floatForKey:@"Total"];
    
    m_IDPool = [[data arrayForKey:@"IDPool"]mutableCopy];
    if (m_IDPool == nil) {
        NSNumber *i = [NSNumber numberWithInt:0];
        m_IDPool = [[NSMutableArray alloc]init];
        [m_IDPool insertObject:i atIndex:0];
    }
    
    m_Colors = [[data arrayForKey:@"Colors"]mutableCopy];
    if (m_Colors == nil) {
        m_Colors = [[NSMutableArray alloc]initWithObjects:
                    [Global Rgb2UIColor:240 with:128 with:128],
                    [Global Rgb2UIColor:255 with:165 with:0],
                    [Global Rgb2UIColor:238 with:232 with:170],
                    [Global Rgb2UIColor:154 with:205 with:50],
                    [Global Rgb2UIColor:0 with:250 with:154],
                    [Global Rgb2UIColor:0 with:255 with:255],
                    [Global Rgb2UIColor:175 with:238 with:238],
                    [Global Rgb2UIColor:100 with:149 with:237],
                    [Global Rgb2UIColor:135 with:206 with:235],
                    [Global Rgb2UIColor:147 with:112 with:219],
                    [Global Rgb2UIColor:221 with:160 with:221],
                    [Global Rgb2UIColor:245 with:222 with:179],
                    [Global Rgb2UIColor:188 with:143 with:143],
                    [Global Rgb2UIColor:176 with:196 with:222],
                    [Global Rgb2UIColor:211 with:211 with:211],
                    [Global Rgb2UIColor:144 with:238 with:144],
                    [Global Rgb2UIColor:179 with:238 with:58],
                    [Global Rgb2UIColor:139 with:129 with:76],
                    [Global Rgb2UIColor:238 with:201 with:0],
                    [Global Rgb2UIColor:255 with:106 with:106],
                    [Global Rgb2UIColor:210 with:180 with:140],
                    [Global Rgb2UIColor:255 with:99 with:71],
                    [Global Rgb2UIColor:238 with:130 with:238],
                    [Global Rgb2UIColor:193 with:205 with:193],
                    [Global Rgb2UIColor:30 with:144 with:255],
                    [Global Rgb2UIColor:176 with:226 with:255],
                    [Global Rgb2UIColor:205 with:181 with:205],
                    [Global Rgb2UIColor:144 with:238 with:144],
                    [Global Rgb2UIColor:178 with:223 with:238],
                    [Global Rgb2UIColor:139 with:58 with:98],
                    [Global Rgb2UIColor:205 with:79 with:57],
                    [Global Rgb2UIColor:255 with:69 with:0],
                    [Global Rgb2UIColor:210 with:180 with:140],
                    [Global Rgb2UIColor:152 with:251 with:152],
                    [Global Rgb2UIColor:205 with:198 with:115],
                    [Global Rgb2UIColor:121 with:205 with:205],
                    [Global Rgb2UIColor:180 with:238 with:180],
                    [Global Rgb2UIColor:0 with:191 with:255],
                    [Global Rgb2UIColor:46 with:139 with:87],
                    [Global Rgb2UIColor:245 with:222 with:179],
                    nil];
    }
    
    m_summary_mode_index = (int)[data integerForKey:@"SummaryModeIndex"] ;
    
}


-(void)writeToUserDefault
{
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    for (Bill *bill in m_Bills) {
        NSData *tmp = [NSKeyedArchiver archivedDataWithRootObject:bill];
        [dataArray addObject:tmp];
    }
    
    [data setObject:dataArray forKey:@"Bills"];
    [data setObject:m_CategoryList forKey:@"categoryList"];
    [data setObject:m_CustomDate forKey:@"customDate"];
    [data setFloat:m_Total forKey:@"Total"];
    [data setObject:m_IDPool forKey:@"IDPool"];
    [data setInteger:m_summary_mode_index forKey:@"SummaryModeIndex"];
    //[data setObject:m_Colors forKey:@"Colors"];
    [data synchronize];
}

-(int)getIDFromPool
{
    NSNumber *num = m_IDPool[0];
    [m_IDPool removeObjectAtIndex:0];
    
    if ([m_IDPool count]==0) {
        NSNumber *num2 = [NSNumber numberWithInt:num.intValue+1];
        [m_IDPool addObject:num2];
    }
    
    return num.intValue;
}

-(void)putIDBackToPool:(int)number
{
    NSNumber *num = [NSNumber numberWithInt:number];
    
    [m_IDPool insertObject:num atIndex:0];
}


+(UIColor*)Rgb2UIColor:(float)r with:(float)g with:(float)b
{
    return [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0];
}

+(UIView*)getDropDownViewByLabel:(UILabel*)label withImageName:(NSString*)imageName
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, 175, 32)];
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.cornerRadius = 12;
    
    label.frame = CGRectMake(0, 1, 155, 30);
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderWidth = 0.0f;
    //label.backgroundColor = [UIColor redColor];
    
    UIImage *img = [UIImage imageNamed:imageName];
    CGSize imgSize = view.frame.size;
    
    UIGraphicsBeginImageContext( imgSize );
    [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.backgroundColor = [UIColor colorWithPatternImage:newImage];
    [view addSubview:label];
    
    view.userInteractionEnabled = true;
    
    return view;
}

+(UIView*)getDropDownViewShortByLabel:(UILabel*)label withImageName:(NSString*)imageName
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, 125, 28)];
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.cornerRadius = 12;
    
    label.frame = CGRectMake(0, 1, 100, 28);
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderWidth = 0.0f;
    //label.backgroundColor = [UIColor redColor];
    
    UIImage *img = [UIImage imageNamed:imageName];
    CGSize imgSize = view.frame.size;
    
    UIGraphicsBeginImageContext( imgSize );
    [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.backgroundColor = [UIColor colorWithPatternImage:newImage];
    [view addSubview:label];
    
    view.userInteractionEnabled = true;
    
    return view;
}

+(UIImage*)convertImageSizeToFit:(NSString*)imageName withFrame:(CGRect)frame
{
    UIImage *img = [UIImage imageNamed:imageName];
    CGSize imgSize = frame.size;
    
    UIGraphicsBeginImageContext( imgSize );
    [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;

}

+(UIView*)getTextFieldViewByLabel:(UITextField*)textField
{
    //UITextField *textField2 = [[UITextField alloc]initWithFrame:textField.frame];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y, 218, 40)];
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.cornerRadius = 5;
    
    textField.frame = CGRectMake(5, 1.75, 155, 37.5);
    //textField.layer.borderWidth = 0.5f;
    //textField.layer.borderColor = [UIColor whiteColor].CGColor;
    textField.borderStyle = UITextBorderStyleNone;
    //label.backgroundColor = [UIColor redColor];
    
    [view addSubview:textField];
    
    return view;
}

+(void)createDirForImage :(NSString *)dirName
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:dirName];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])    //Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    
}

+ (void)saveImage: (UIImage*)image withFileName:(NSString*)fileName
{
    if (image != nil)
    {
        //image =[self scaleAndRotateImage:image];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@%@.png",BILL_IMAGE_FOLDER_PATH,fileName]];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

+ (UIImage*)loadImage:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@%@.png",BILL_IMAGE_FOLDER_PATH,fileName]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

+(void)removeImageWithFileName:(NSString*)fileName
{
    if (fileName == nil) {
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@%@.png",BILL_IMAGE_FOLDER_PATH,fileName]];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:path error: &error];
}

+ (UIImage *) scaleAndRotateImage: (UIImage *)image
{
    int kMaxResolution = 1200; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

//It can be used to get content size of a scrollview
+(CGSize)getContentSizeOfView:(UIView*)View
{
    CGRect contentRect = CGRectZero;
    for (UIView *view in View.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    return contentRect.size;
}

+(CGSize)getStringSizeWithString:(NSString*)string withFontSize:(float)fontSize
{
    CGSize stringSize = [string boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;

    return stringSize;
}

//usage
/*
 
[Global blockViewStartWithController:self withStartTag:TAG_FOR_BLOCKVIEW];

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
    [Long time operation]
 
    dispatch_async(dispatch_get_main_queue(), ^{
 
        [finish action]
 
        [Global blockViewEndWithController:self withStartTag:TAG_FOR_BLOCKVIEW];
 
    });
}
 
*/
//arg 1 : just put "self"
//arg 2 : tag number for spinner and block view
+(void)blockViewStartWithController:(UIViewController*)controller withStartTag:(int)tag
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.tag = tag;
    spinner.center = CGPointMake(controller.view.frame.size.width/2,200);
    
    [controller.view addSubview:spinner];
    [controller.view bringSubviewToFront:spinner];
    [spinner startAnimating];
    
    UIView *blockView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height)];
    blockView.tag = tag + 1;
    //[blockView setUserInteractionEnabled:false];
    [blockView setHidden:false];
    [blockView setOpaque:NO];
    [blockView setAlpha:0.3];
    [blockView setBackgroundColor:[UIColor lightGrayColor]];
    [controller.view addSubview:blockView];
    
    for (UIBarButtonItem *item in controller.navigationItem.rightBarButtonItems) {
        item.enabled = false;
    }
    
    for (UIBarButtonItem *item in controller.navigationItem.leftBarButtonItems) {
        item.enabled = false;
    }
    
    for (UITabBarItem *item in controller.tabBarController.tabBar.items) {
        item.enabled = false;
    }
    
    controller.navigationItem.hidesBackButton = true;
    
}

+(void)blockViewEndWithController:(UIViewController*)controller withStartTag:(int)tag
{
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView*)[controller.view viewWithTag:tag];
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
    UIView *blockView = [controller.view viewWithTag:tag+1];
    [blockView removeFromSuperview];
    
    for (UIBarButtonItem *item in controller.navigationItem.rightBarButtonItems) {
        item.enabled = true;
    }
    
    for (UIBarButtonItem *item in controller.navigationItem.leftBarButtonItems) {
        item.enabled = true;
    }
    
    for (UITabBarItem *item in controller.tabBarController.tabBar.items) {
        item.enabled = true;
    }
    
    controller.navigationItem.hidesBackButton = false;
}



@end
