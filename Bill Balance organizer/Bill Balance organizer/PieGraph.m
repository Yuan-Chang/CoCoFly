//
//  PieGraph.m
//  Bill Balance organizer
//
//  Created by Anthony on 8/13/14.
//  Copyright (c) 2014 SCL. All rights reserved.
//

#import "PieGraph.h"
#import "PieGraphElement.h"


@implementation PieGraph
{
    float _cellHeight;
}

@synthesize m_Values,m_Total;

- (id)initWithFrame:(CGRect)frame withValues:(NSArray*)values withTotal:(float)total
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        m_Values = values;
        m_Total = total;
        _cellHeight = 50;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;

}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float startAngle = 0;
    float endAngle = 0;
    float radius = self.frame.size.width/2-75;
    float fontSize = 11;
    
    CGPoint central = CGPointMake(self.frame.size.width/2, radius + 37);
    
    if ([m_Values count] == 0) // if there is no value
    {
        
        float startRadian = startAngle*M_PI/180;
        float endRadian = 360*M_PI/180;
        
        CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
       
        CGContextBeginPath(ctx);
        CGContextAddArc(ctx, central.x, central.y, radius+3, startRadian, endRadian, 0);
        CGColorRef color = [Global Rgb2UIColor:204 with:255 with:204].CGColor;
        CGContextSetFillColorWithColor(ctx, color);
        CGContextFillEllipseInRect(ctx, CGRectMake(central.x - radius-3, central.y - radius -3, 2*(radius+3), 2*(radius+3)));
        
        CGContextBeginPath(ctx);
        CGContextAddArc(ctx, central.x, central.y, radius, startRadian, endRadian, 0);
        color = [Global Rgb2UIColor:102 with:178 with:255].CGColor;
        CGContextSetFillColorWithColor(ctx, color);
        CGContextFillEllipseInRect(ctx, CGRectMake(central.x - radius, central.y - radius, 2*radius, 2*radius));
        //CGContextClosePath(ctx);
        
        
        NSString *string = [NSString stringWithFormat:@"0.00%%"];
        CGSize stringSize = [string boundingRectWithSize:CGSizeMake(200, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:25]} context:nil].size;
        //draw the text
        CGRect renderingRect = CGRectMake(central.x-stringSize.width/2, central.y-stringSize.height/2, stringSize.width, stringSize.height);
        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGContextFillRect(ctx, renderingRect);
        [string drawInRect:renderingRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]}];
        
        return;
    }
    
    //draw filled circle
    for (PieGraphElement *value in m_Values) {
        CGColorRef color = value.m_Color.CGColor;
        
        float percentage = value.m_Value/m_Total;
        
        endAngle = startAngle + 360*percentage;
        
        //adjust the last area
        if (endAngle > 360) {
            endAngle = 360;
        }
        
        float startRadian = startAngle*M_PI/180;
        float endRadian = endAngle*M_PI/180;
        float midRadian = ((startAngle+endAngle)/2+180)*M_PI/180;
        CGPoint startPoint = CGPointMake(central.x-radius*cosf(startRadian), central.y-radius*sinf(startRadian));
        
        //start point of the line
        CGPoint startMidPoint = CGPointMake(central.x-radius*cosf(midRadian), central.y-radius*sinf(midRadian));
        startMidPoint = CGPointMake((startMidPoint.x+central.x)/2, (startMidPoint.y+central.y)/2);
        
        //draw filled circle
        CGContextBeginPath(ctx);
        CGContextSetFillColorWithColor(ctx, color);
        CGContextMoveToPoint(ctx, central.x, central.y);
        CGContextAddLineToPoint(ctx, startPoint.x, startPoint.y);
        CGContextAddArc(ctx, central.x, central.y, radius, startRadian, endRadian, 0);
        CGContextAddLineToPoint(ctx, central.x, central.y);
        CGContextFillPath(ctx);
        //CGContextClosePath(ctx);
        
        startAngle = endAngle;
    }
    
    startAngle = 0;
    endAngle = 0;
    
    //draw line and text
    for (PieGraphElement *value in m_Values) {
        
        float percentage = value.m_Value/m_Total;
        
        endAngle = startAngle + 360*percentage;
        
        float midRadian = ((startAngle+endAngle)/2+180)*M_PI/180;
        
        //start point of the line
        CGPoint startMidPoint = CGPointMake(central.x-radius*cosf(midRadian), central.y-radius*sinf(midRadian));
        startMidPoint = CGPointMake((startMidPoint.x+central.x)/2, (startMidPoint.y+central.y)/2);
        
        //end point of the line
        CGPoint midPoint = CGPointMake(central.x-(radius+20)*cosf(midRadian), central.y-(radius+20)*sinf(midRadian));
        
        // ignore line and text with percentage less than 1%
        if (percentage < 0.02f)
        {
            startAngle = endAngle;
            continue;
        }
        
        //draw the line
        CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
        CGContextMoveToPoint(ctx, startMidPoint.x, startMidPoint.y);
        CGContextAddLineToPoint(ctx, midPoint.x, midPoint.y);
        CGContextStrokePath(ctx);
        
        NSString *string = [NSString stringWithFormat:@"%@(%0.2f%%)",value.m_Title,100*value.m_Value/m_Total];
        CGSize stringSize = [string boundingRectWithSize:CGSizeMake(200, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
        
        //adjust text position
        if (midPoint.x - central.x > 0 && midPoint.y-central.y < 0) //up right
        {
            midPoint.y = midPoint.y - stringSize.height ;
            midPoint.x = midPoint.x - stringSize.width/2+17;
        }
        else if (midPoint.x - central.x > 0 && midPoint.y-central.y > 0) //down right
        {
            midPoint.x = midPoint.x - stringSize.width/2+17;
        }
        else if (midPoint.x - central.x < 0 && midPoint.y-central.y < 0) // up left
        {
            midPoint.y = midPoint.y - stringSize.height ;
            midPoint.x = midPoint.x - stringSize.width/2-10;
        }
        else if (midPoint.x - central.x < 0 && midPoint.y-central.y >= 0) //down left
        {
            midPoint.x = midPoint.x - stringSize.width/2-10;
        }
        
        //check out of bound
        if (midPoint.x+stringSize.width > self.frame.size.width) {
            midPoint.x = self.frame.size.width - stringSize.width;
        }
        else if (midPoint.x < 0)
        {
            midPoint.x = 0;
        }
        
        //draw the text
        CGRect renderingRect = CGRectMake(midPoint.x, midPoint.y, stringSize.width, stringSize.height);
        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGContextFillRect(ctx, renderingRect);
        [string drawInRect:renderingRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
        
        startAngle = endAngle;
        
    }
    
    //list all categories
    
    float leftMargin = 30;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(leftMargin, 250, self.frame.size.width-2*leftMargin, _cellHeight*[m_Values count])];
    
    tableView.layer.borderWidth = 0.1f;
    tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    
    
}

-(CGSize)getSize
{
    return CGSizeMake(self.frame.size.width, 250 + _cellHeight*[m_Values count]+20);
}

-(CGRect)getFrame
{
    return CGRectMake(self.frame.origin.x, self.frame.origin.y, [self getSize].width, [self getSize].height);
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_Values count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }

    PieGraphElement *element = [m_Values objectAtIndex:indexPath.row];
    
    //draw seperate line
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-2, cell.frame.size.width, 1)];
    line.layer.borderWidth = 1.0f;
    line.layer.borderColor = element.m_Color.CGColor;
    [cell addSubview:line];
    
    //draw color rect at the font
    UIView *colorRect = [[UIView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
    colorRect.backgroundColor = element.m_Color;
    [cell addSubview:colorRect];
    
    //draw the text
    UILabel *titleTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 200, 20)];
    titleTextLabel.text = [NSString stringWithFormat:@"%@",element.m_Title];
    titleTextLabel.font = [UIFont boldSystemFontOfSize:14];
    [cell addSubview:titleTextLabel];
    
    UILabel *totalTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 20, 200, 20)];
    totalTextLabel.text = [NSString stringWithFormat:@"$ %0.2f (%0.2f%%)",element.m_Value,100*element.m_Value/m_Total];
    totalTextLabel.font = [UIFont systemFontOfSize:14];
    [cell addSubview:totalTextLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGFloat)_cellHeight;
}

@end
