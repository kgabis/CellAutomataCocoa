//
//  CellGridView.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CACellGridView.h"
#import "CAPredatorPrey.h"
#import "CARectColorArray.h"

@interface CACellGridView ()
-(void)drawGrid:(CellGrid)cellGrid withColorMap:(NSDictionary *)colorMap;
@end

@implementation CACellGridView
{
    CellGrid _cellGrid;
    NSDictionary *_colorMap;
    CARectColorArray *rectColorArray;
}

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
    }
    return self;
}

@synthesize cellGrid = _cellGrid;
@synthesize colorMap = _colorMap;

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [self drawGrid:_cellGrid withColorMap:_colorMap];
}

-(BOOL)isOpaque
{
    return YES;
}

-(void)drawGrid:(CellGrid)cellGrid withColorMap:(NSDictionary *)colorMap
{
    int length = cellGrid.width * cellGrid.height;
    if (!rectColorArray || rectColorArray.length != length) {
        rectColorArray = [[CARectColorArray alloc] 
                          initWithLength:length];
    }
    else {
        [rectColorArray clear];
    }
    
    NSColor *bgColor = [colorMap objectForKey:[NSNumber numberWithUnsignedInt:0]];
    NSColor *currentCellColor;
    NSColor *previousCellColor = bgColor;
    NSRect cellBounds = NSZeroRect;      
    float cellWidth, cellHeight;
    cellWidth = self.bounds.size.width / (float)cellGrid.width;
    cellHeight = self.bounds.size.height / (float)cellGrid.height;
        
    if (bgColor) {
        [bgColor set];
        [NSBezierPath fillRect:self.bounds];
        NSRectFill([self bounds]);
    }
    
    for (int y = 0; y < cellGrid.height; y++) {
        for (int x = 0; x < cellGrid.width; x++) {
            
            // Tries to avoid using dictionary and int boxing
            if (cellGrid.grid[y][x] == 0) {
                currentCellColor = bgColor;
            }
            else {
                currentCellColor = [colorMap objectForKey:
                          [NSNumber numberWithUnsignedInt:cellGrid.grid[y][x]]];
            }
            
            // isEqual is expensive, so it uses pointer comparison instead
            if (currentCellColor == previousCellColor) {
                cellBounds.size.width += cellWidth;
            }
            else {
                if (previousCellColor != bgColor) {
                    [rectColorArray addRect:cellBounds Color:previousCellColor];
                }
                cellBounds = NSMakeRect(x * cellWidth + 0.5f, 
                            _bounds.size.height - (y + 1) * cellHeight - 0.5f, 
                                          cellWidth + 1.0f, cellHeight + 1.0f);
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
