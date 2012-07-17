//
//  CellGridView.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CACellGridView.h"
#import "CAPredatorPreyAutomata.h"
#import "CARectColorArray.h"

@interface CACellGridView ()
-(void)drawGrid:(CellGrid)cellGrid withColorMap:(ColorMap)colorMap;
@end

@implementation CACellGridView
{
    CellGrid _cellGrid;
    ColorMap _colorMap;
    CARectColorArray *rectColorArray;
}

@synthesize cellGrid = _cellGrid;
@synthesize colorMap = _colorMap;

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [self drawGrid:_cellGrid withColorMap:_colorMap];
}

-(BOOL)isOpaque
{
    return YES;
}

-(void)drawGrid:(CellGrid)cellGrid withColorMap:(ColorMap)colorMap
{
    int length = cellGrid.width * cellGrid.height;
    if (!rectColorArray || rectColorArray.length != length) {
        rectColorArray = [[CARectColorArray alloc] 
                          initWithLength:length];
    }
    else {
        [rectColorArray clear];
    }
    
    if (colorMap.length == 0) {
        return;
    }
    
    NSColor *bgColor = colorMap.colors[0];
    NSColor *currentCellColor;
    NSColor *previousCellColor = bgColor;
    NSRect cellBounds = NSZeroRect;      
    float cellWidth, cellHeight;
    
    //2.0f is an offset for border
    cellWidth = (self.bounds.size.width - 2.0f) / (float)cellGrid.width;
    cellHeight = (self.bounds.size.height - 2.0f) / (float)cellGrid.height;
    
    //drawing border and background
    if (bgColor) {
        [[NSColor blackColor] set];
        [NSBezierPath fillRect:self.bounds];
        [bgColor set];
        [NSBezierPath fillRect:NSInsetRect(self.bounds, 1.0f, 1.0f)];
    }
    
    for (int y = 0; y < cellGrid.height; y++) {
        for (int x = 0; x < cellGrid.width; x++) {
            
            int currentCellValue = cellGrid.grid[y][x];
            
            if (currentCellValue == 0) {
                currentCellColor = bgColor;
            }
            else if (currentCellValue < colorMap.length) {
                currentCellColor = colorMap.colors[currentCellValue];
            }
            else {
                continue;
            }
            
            // isEqual is expensive, so it uses pointer comparison instead
            if (currentCellColor == previousCellColor) {
                cellBounds.size.width += cellWidth;
            }
            else {
                if (previousCellColor != bgColor) 
                {
                    [rectColorArray addRect:cellBounds Color:previousCellColor];
                }
                cellBounds = NSMakeRect(x * cellWidth + 1.0f, 
                            _bounds.size.height - (y + 1) * cellHeight - 1.0f, 
                                          cellWidth, cellHeight);
            }
            
            // draws row's last element
            if (x == (cellGrid.width - 1)) {
                if (previousCellColor != bgColor) {
                    [rectColorArray addRect:cellBounds Color:currentCellColor];
                }
                previousCellColor = bgColor;
            }
            else {
                previousCellColor = currentCellColor;
            }
        }
    }
    
    //I'm using this function instead of drawing each rectangle separately
    //to speed up drawing
    NSRectFillListWithColors(rectColorArray.rects, 
                             rectColorArray.colors, 
                             rectColorArray.count);
}

@end
