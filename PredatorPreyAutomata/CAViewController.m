//
//  MyMainWindowViewController.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CAViewController.h"
#import "CACellularAutomata.h"

enum {
    CACellGridWidth = 300,
    CACellGridHeight = 300
};

@interface CAViewController ()
-(void)animate;
-(void)setupModel;
@end

@implementation CAViewController
{
    IBOutlet CACellGridView *_cellGridView;
    IBOutlet NSSlider *_simulationSpeedSlider;
    IBOutlet NSSlider *_preyBornSlider;
    IBOutlet NSSlider *_predatorBornSlider;
    NSObject <CACellularAutomata> *_model;
    ColorMap _colorMap;
    float _animationSpeed;
    BOOL _running;
}

@synthesize cellGridView = _cellGridView;
@synthesize simulationSpeedSlider = _simulationSpeedSlider;
@synthesize preyBornSlider = _preyBornSlider;
@synthesize predatorBornSlider = _predatorBornSlider;
@synthesize predatorDeathSlider = _predatorDeathSlider;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupModel];
        _running = YES;
    }
    return self;
}
         
-(void)awakeFromNib
{
    [self setupModel];
    _cellGridView.colorMap = _colorMap;
    [self animate];
}


-(void)resetAutomata:(id)sender
{
    [self setupModel];
    _cellGridView.cellGrid = _model.cellGrid;
    [_cellGridView setNeedsDisplayInRect:_cellGridView.bounds];
}

-(void)startAutomata:(id)sender
{
    if (!_running) {
        _running = YES;
        [self animate];
    }
}

-(void)stopAutomata:(id)sender
{
    _running = NO;
}

-(void)sliderChanged:(NSSlider *)sender
{
    if (sender == self.simulationSpeedSlider) {
        _animationSpeed = self.simulationSpeedSlider.floatValue / 100.0f;
    }
    else if (sender == self.preyBornSlider) {
        ((CAPredatorPrey*)_model).probabilityA = self.preyBornSlider.floatValue / 100.0f;
    }
    else if (sender == self.predatorBornSlider) {
        ((CAPredatorPrey*)_model).probabilityB = self.predatorBornSlider.floatValue / 100.0f;
    }
    else if (sender == self.predatorDeathSlider) {
        ((CAPredatorPrey*)_model).probabilityC = self.predatorDeathSlider.floatValue / 100.0f;        
    }
}

-(void)setupModel
{
    _colorMap.length = 3;
    _colorMap.colors = (NSColor * __autoreleasing *)malloc(_colorMap.length * sizeof(NSColor*));
    _colorMap.colors[CTEmpty] = [NSColor whiteColor];
    _colorMap.colors[CTPrey] = [NSColor darkGrayColor];
    _colorMap.colors[CTPredator] = [NSColor redColor];
    
    _model = [[CAPredatorPrey alloc] initWithWidth:CACellGridWidth 
                                            Height:CACellGridHeight];
    
    _animationSpeed = self.simulationSpeedSlider.floatValue / 100.0f;
    ((CAPredatorPrey*)_model).probabilityA = self.preyBornSlider.floatValue / 100.0f;
    ((CAPredatorPrey*)_model).probabilityB = self.predatorBornSlider.floatValue / 100.0f;
    ((CAPredatorPrey*)_model).probabilityC = self.predatorDeathSlider.floatValue / 100.0f; 
}

-(void)animate
{
    double delayInSeconds = 1.005f - _animationSpeed;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (_running) {
            [_model nextIteration];
            _cellGridView.cellGrid = _model.cellGrid;
            [_cellGridView setNeedsDisplayInRect:_cellGridView.bounds];
            [self animate];
        }
    });  
}

-(void)dealloc
{
    free(_colorMap.colors);
}
@end
