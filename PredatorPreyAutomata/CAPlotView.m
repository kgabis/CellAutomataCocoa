//
//  CAPlotView.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 14.06.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CAPlotView.h"

@interface CAPlotView ()

-(void)drawBackgroundAndBorder;
-(void)drawPlot;
@end

@implementation CAPlotView
{
    NSArray *_setsToDraw;
}


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)drawBackgroundAndBorder
{
    [[NSColor blackColor] set];
    [NSBezierPath fillRect:self.bounds];
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:NSInsetRect(self.bounds, 1.0f, 1.0f)];
}

-(BOOL)isOpaque
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self drawBackgroundAndBorder];
    [self drawPlot];
}

-(void)drawPlot
{
    int maxValue = 0, maxLength = 0;
    float width = self.bounds.size.width - 2.0f;
    float height = self.bounds.size.height - 8.0f;
    float stepY, stepX;
    float offsetX = 1.0f, offsetY = 2.0f;
    CAPlotDataSet *dataSet;
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    //finds max value and length
    for(dataSet in _setsToDraw)
    {
        maxValue = MAX(maxValue, dataSet.max);
        maxLength = MAX(maxLength, dataSet.visibleLength);
    }
    
    stepX = width / maxLength;
    stepY = height / maxValue;
    [path setLineWidth:1.5f];
    
    for(dataSet in _setsToDraw)
    {
        [path moveToPoint:NSMakePoint(offsetX, offsetY + 
                                      (float)dataSet.visibleValues[0] * stepY)];
        for (int x = 1; x < dataSet.visibleLength; x++) {
            float y = (float)dataSet.visibleValues[x];
            [path lineToPoint:NSMakePoint((float)x * stepX + offsetX, 
                                          y * stepY + offsetY)];
        }
        [dataSet.color setStroke];
        [path stroke];
        [path removeAllPoints];
    }
}

@end
