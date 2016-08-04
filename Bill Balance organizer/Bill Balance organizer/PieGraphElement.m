//
//  PieGraphElement.m
//  Bill Balance organizer
//
//  Created by Anthony on 8/13/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "PieGraphElement.h"

@implementation PieGraphElement

@synthesize m_Color,m_Title,m_Value;

-(id)initWithColor:(UIColor *)color withTitle:(NSString*)title withValue:(float)value
{
    self = [super init];
    
    if (self) {
        m_Color = color;
        m_Title = title;
        m_Value = value;
    }
    
    return self;
   
}

@end
