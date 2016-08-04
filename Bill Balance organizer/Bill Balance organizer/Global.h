//
//  Global.h
//  Bill Balance organizer
//
//  Created by Anthony on 7/27/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//


#import <Foundation/Foundation.h>


#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

typedef enum{
    TAG_FOR_BLOCKVIEW = 1000
} GLOBAL_TAG;

typedef enum {
    DATEVIEW_CUSTOM_DATE,
    DATEVIEW_ADDVIEW,
    DATEVIEW_DETAILVIEW,
    DATEVIEW_DELETEVIEW_DATEAFTER,
    DATEVIEW_DELETEVIEW_DATESTART,
    DATEVIEW_DELETEVIEW_DATEEND
} STATE_OF_DATEVIEW;

typedef enum {
    CATEGORYVIEW_ADDVIEW,
    CATEGORYVIEW_DETAILVIEW,
} STATE_OF_CATEGORYVIEW;



#define BILL_IMAGE_FOLDER_PATH @"_Images/"
#define TEMP_CSV_FILE_NAME @".TMP_CSV"
#define CSV_EXPORT_FILE_NAME @"Bills.csv"
#define PDF_EXPORT_FILE_NAME @"Bills.pdf"
#define TEMP_PDF_EXPORT_FILE_NAME @".TMP_PDF"

@interface Global : NSObject
{

}

+(Global*)getInstance;
-(void)readIn;
-(void)writeToUserDefault;
-(int)getIDFromPool;
-(void)putIDBackToPool:(int)number;

+(UIColor*)Rgb2UIColor:(float)r with:(float)g with:(float)b;
+(UIView*)getDropDownViewByLabel:(UILabel*)label withImageName:(NSString*)imageName;
+(UIView*)getDropDownViewShortByLabel:(UILabel*)label withImageName:(NSString*)imageName;
+(UIView*)getTextFieldViewByLabel:(UITextField*)textField;
+(void)createDirForImage :(NSString *)dirName;
+ (void)saveImage: (UIImage*)image withFileName:(NSString*)fileName;
+ (UIImage*)loadImage:(NSString*)fileName;
+(void)removeImageWithFileName:(NSString*)fileName;
+ (UIImage *) scaleAndRotateImage: (UIImage *)image;
+(UIImage*)convertImageSizeToFit:(NSString*)imageName withFrame:(CGRect)frame;
+(CGSize)getContentSizeOfView:(UIView*)View;
+(CGSize)getStringSizeWithString:(NSString*)string withFontSize:(float)fontSize;

+(void)blockViewStartWithController:(UIViewController*)controller withStartTag:(int)tag;
+(void)blockViewEndWithController:(UIViewController*)controller withStartTag:(int)tag;

@property (nonatomic,strong)NSMutableArray *m_Bills;
@property (nonatomic,strong)NSMutableDictionary *m_Categories;
@property (nonatomic,strong)NSMutableArray *m_CategoryList;
@property (nonatomic,strong)NSDate *m_CustomDate;
@property (nonatomic)float m_Total;
@property (nonatomic)NSMutableArray* m_IDPool;
@property (nonatomic)NSMutableArray *m_Colors;
@property int m_summary_mode_index;

@end
