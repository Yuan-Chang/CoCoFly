//
//  PieGraphElement.h
//  Bill Balance organizer
//
//  Created by Anthony on 8/13/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PieGraphElement : NSObject

@property(nonatomic,strong) NSString *m_Title;
@property(nonatomic) float m_Value;
@property(nonatomic) UIColor *m_Color;

-(id)initWithColor:(UIColor *)color withTitle:(NSString*)title withValue:(float)value;

@end
