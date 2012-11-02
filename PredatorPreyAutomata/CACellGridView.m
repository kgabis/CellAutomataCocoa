//
//  CellGridView.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CACellGridView.h"
#import "CAPredatorPreyAutomata.h"

static inline void drawRect(CGContextRef context, NSColor *color, NSRect bounds);

@interface CACellGridView ()
-(void)drawGrid:(CellGrid)cellGrid withColorMap:(ColorMap)colorMap andContext:(CGContextRef)context;
@end

@implementation CACellGridView
{
    CellGrid _cellGrid;
    ColorMap _colorMap;
}


-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
    [super drawRect:dirtyRect];
    [self drawGrid:_cellGrid withColorMap:_colorMap andContext:myContext];
}

-(BOOL)isOpaque
{
    return YES;
}

-(void)drawBackground:(NSColor*)bgColor AndBorder:(NSColor*)borderColor {
    [[NSColor blackColor] set];
    [NSBezierPath fillRect:self.bounds];
    [bgColor set];
    [NSBezierPath fillRect:NSInsetRect(self.bounds, 1.0f, 1.0f)];
}

-(void)drawGrid:(CellGrid)cellGrid withColorMap:(ColorMap)colorMap andContext:(CGContextRef)context
{
    if (colorMap.length == 0) {
        return;
    }
    
    NSColor *bgColor = colorMap.colors[0];
    NSColor *currentCellColor;
    NSColor *previousCellColor = bgColor;
    CGRect cellBounds = CGRectZero;
    int cellWidth, cellHeight;
    
    //2.0f is an offset for border
    cellWidth = (self.bounds.size.width - 2.0) / (float)cellGrid.width;
    cellHeight = (self.bounds.size.height - 2.0) / (float)cellGrid.height;
    
    //drawing border and background
    [self drawBackground:bgColor AndBorder:[NSColor blackColor]];
    
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
                    drawRect(context, previousCellColor, cellBounds);
                }
                cellBounds = CGRectMake(x * cellWidth + 1,
                            _bounds.size.height - (y + 1) * cellHeight - 1,
                                          cellWidth, cellHeight);
            }
            
            // draws row's last element
            if (x == (cellGrid.width - 1)) {
                if (previousCellColor != bgColor) {
                    drawRect(context, currentCellColor, cellBounds);
                }
                previousCellColor = bgColor;
            }
            else {
                previousCellColor = currentCellColor;
            }
        }
    }
}

static inline void drawRect(CGContextRef context, NSColor *color, CGRect bounds) {
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, bounds);
}

@end
