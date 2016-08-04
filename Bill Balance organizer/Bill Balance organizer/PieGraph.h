//
//  PieGraph.h
//  Bill Balance organizer
//
//  Created by Anthony on 8/13/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieGraph : UIView<UITableViewDataSource,UITableViewDelegate>


@property (strong,nonatomic) NSArray* m_Values;
@property float m_Total;

- (id)initWithFrame:(CGRect)frame withValues:(NSArray*)values withTotal:(float)total;

-(CGSize)getSize;
-(CGRect)getFrame;

@end
