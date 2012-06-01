//
//  CellGridView.m
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import "MyCellGridView.h"
#import "MyPredatorPreyAutomata.h"

#define GRID_WIDTH 200
#define GRID_HEIGHT 200

@interface MyCellGridView ()
 
    - (void)drawGrid;
    - (void)calculateCellSizes;
    - (void)animate;

@end

@implementation MyCellGridView
{
    NSColor *emptyCellColor;
    NSColor *predatorCellColor;
    NSColor *preyCellColor;
    float cellWidth;
    float cellHeight;
}

@synthesize model = model;
@synthesize running;

-(float)animationSpeed
{
    return self->animationSpeed;
}

-(void)setAnimationSpeed:(float)aSpeed
{
    aSpeed = aSpeed < 0.0f ? 0.0f : aSpeed;
    aSpeed = aSpeed > 1.0f ? 1.0f : aSpeed;
    self->animationSpeed = aSpeed;
}

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        emptyCellColor = [NSColor blackColor];
        predatorCellColor = [NSColor redColor];
        preyCellColor = [NSColor whiteColor];
        model = [[MyPredatorPreyAutomata alloc] initWithWidth:GRID_WIDTH Height:GRID_HEIGHT];
        self->running = NO;
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
    [emptyCellColor set];
    NSRectFill([self bounds]);
    
    for (int x = 0; x < GRID_WIDTH; x++) {
        for (int y = 0; y < GRID_HEIGHT; y++) {
            if (model.grid[y][x] == CTEmpty) {
                continue;
            }
            else if (model.grid[y][x] == CTPredator) {
                [predatorCellColor set];
            }
            else if (model.grid[y][x] == CTPrey) {
                [preyCellColor set];
            }   
            rect = NSMakeRect(x * cellWidth, 
                              self.bounds.size.height - (y + 1) * cellHeight, 
                              cellWidth + 1.0f, 
                              cellHeight + 1.0f);
            NSRectFill(rect);
        }
    }
}
-(void)startAnimation
{
    self->running = YES;
    [self animate];
}

- (void)stopAnimation
{
    self->running = NO;
}

- (void)resetAutomata
{
    [self stopAnimation];
    model = [[MyPredatorPreyAutomata alloc] initWithWidth:GRID_WIDTH Height:GRID_HEIGHT];
}

-(void)animate
{
    if (running) {
        double delayInSeconds = 1.01f - self->animationSpeed;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [model nextIteration];
            [self setNeedsDisplay:YES];
            [self animate];
        });
    }
    
}

@end
