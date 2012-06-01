//
//  CellGridView.m
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import "CACellGridView.h"
#import "CAPredatorPrey.h"

#define GRID_WIDTH 200
#define GRID_HEIGHT 200

@interface CACellGridView ()
 
    - (void)drawGrid;
    - (void)calculateCellSizes;
    - (void)animate;

@end

@implementation CACellGridView
{
    float _animationSpeed;
    BOOL _running;
    CAPredatorPrey *_model;
    NSColor *_emptyCellColor;
    NSColor *_predatorCellColor;
    NSColor *_preyCellColor;
    float _cellWidth;
    float _cellHeight;
}

@synthesize model = _model;
@synthesize running;

-(float)animationSpeed
{
    return _animationSpeed;
}

-(void)setAnimationSpeed:(float)aSpeed
{
    aSpeed = aSpeed < 0.0f ? 0.0f : aSpeed;
    aSpeed = aSpeed > 1.0f ? 1.0f : aSpeed;
    _animationSpeed = aSpeed;
}

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _emptyCellColor = [NSColor blackColor];
        _predatorCellColor = [NSColor redColor];
        _preyCellColor = [NSColor whiteColor];
        _model = [[CAPredatorPrey alloc] initWithWidth:GRID_WIDTH Height:GRID_HEIGHT];
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
    _cellHeight = self.bounds.size.height / GRID_HEIGHT;
    _cellWidth = self.bounds.size.width / GRID_WIDTH;
}

-(void)drawGrid
{
    NSRect rect;
    [_emptyCellColor set];
    NSRectFill([self bounds]);
    
    for (int x = 0; x < GRID_WIDTH; x++) {
        for (int y = 0; y < GRID_HEIGHT; y++) {
            if (_model.grid[y][x] == CTEmpty) {
                continue;
            }
            else if (_model.grid[y][x] == CTPredator) {
                [_predatorCellColor set];
            }
            else if (_model.grid[y][x] == CTPrey) {
                [_preyCellColor set];
            }   
            rect = NSMakeRect(x * _cellWidth, 
                              self.bounds.size.height - (y + 1) * _cellHeight, 
                              _cellWidth + 1.0f, 
                              _cellHeight + 1.0f);
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
    _model = [[CAPredatorPrey alloc] initWithWidth:GRID_WIDTH Height:GRID_HEIGHT];
    [self setNeedsDisplay:YES];
}

-(void)animate
{
    if (running) {
        double delayInSeconds = 1.01f - _animationSpeed;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.model nextIteration];
            [self setNeedsDisplay:YES];
            [self animate];
        });
    }
    
}

@end
