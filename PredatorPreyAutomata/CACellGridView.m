//
//  CellGridView.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CACellGridView.h"
#import "CAPredatorPrey.h"

@interface CACellGridView ()
 
@end

@implementation CACellGridView

//-(void)setAnimationSpeed:(float)aSpeed
//{
//    aSpeed = aSpeed < 0.0f ? 0.0f : aSpeed;
//    aSpeed = aSpeed > 1.0f ? 1.0f : aSpeed;
//    //_animationSpeed = aSpeed;
//}

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

-(void)drawGrid:(CellGrid)cellGrid withColorMap:(NSDictionary *)colorMap
{
    NSColor *bgColor = [colorMap objectForKey:[NSNumber numberWithUnsignedInt:0]];
    NSColor *currentCellColor;
    NSRect currentCellBounds;
    
    float cellWidth, cellHeight;
    cellWidth = self.bounds.size.width / (float)cellGrid.width;
    cellHeight = self.bounds.size.height / (float)cellGrid.height;
    
    if (bgColor) {
        [bgColor set];
        NSRectFill([self bounds]);
    }
    
    for (int y = 0; y < cellGrid.height; y++) {
        for (int x = 0; x < cellGrid.width; x++) {
            //we don't want to draw background more than once, 
            //drawing is expensive
            if (cellGrid.grid[y][x] == 0) {
                continue;
            }
            currentCellColor = [colorMap objectForKey:
                          [NSNumber numberWithUnsignedInt:cellGrid.grid[y][x]]];
            if (currentCellColor) {
                currentCellBounds = NSMakeRect(x * cellWidth, 
                                self.bounds.size.height - (y + 1) * cellHeight, 
                                        cellWidth + 1.0f, cellHeight + 1.0f);
                [currentCellColor set];
                NSRectFill(currentCellBounds);
            }
        }
    }
    [self setNeedsDisplay:YES];
}

@end
