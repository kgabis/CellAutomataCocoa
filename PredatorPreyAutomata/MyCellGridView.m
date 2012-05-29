//
//  CellGridView.m
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import "MyCellGridView.h"
#define GRID_WIDTH 100
#define GRID_HEIGHT 100

typedef enum _CellType {
    Empty = 0,
    Prey = 1,
    Predator = 2
} CellType;

@interface MyCellGridView ()
 
    - (void)drawGrid;
    - (void)calculateCellSizes;

@end

@implementation MyCellGridView
{
    NSColor *emptyCellColor;
    NSColor *predatorCellColor;
    NSColor *preyCellColor;
    float cellWidth;
    float cellHeight;
    CellType grid[GRID_WIDTH][GRID_HEIGHT];
    
}
-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        emptyCellColor = [NSColor colorWithSRGBRed:1.0f
                                             green:1.0f 
                                              blue:1.0f 
                                             alpha:1.0f];
        predatorCellColor = [NSColor colorWithSRGBRed:1.0f 
                                            green:0.0f
                                             blue:0.0f 
                                            alpha:1.0f];
        
        preyCellColor = [NSColor colorWithSRGBRed:0.0
                                        green:1.0
                                         blue:0.0
                                        alpha:1.0f];
        printf("%lu\n", sizeof(grid));
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [self calculateCellSizes];
	[self drawGrid];
}

- (void)calculateCellSizes
{
    
    cellHeight = self.bounds.size.height / GRID_HEIGHT;
    cellWidth = self.bounds.size.width / GRID_WIDTH;
}

-(void)drawGrid
{
    NSRect rect;
    [[NSColor whiteColor] set];
    NSRectFill([self bounds]);
    // fill background
    for (int x = 0; x < GRID_WIDTH; x++) {
        for (int y = 0; y < GRID_HEIGHT; y++) {
            if (x % 2 == 0 && y % 2 == 0) {
                [preyCellColor set];
            }
            else {
                [predatorCellColor set];
            }
            rect = NSMakeRect(x * cellWidth, y * cellHeight, cellWidth, cellHeight);
            NSRectFill(rect);
        }
    }
}


@end
