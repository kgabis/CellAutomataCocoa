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
    CACellGridWidth = 200,
    CACellGridHeight = 200
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
    IBOutlet NSButton *_isIsotropicCheckbox;
    NSObject <CACellularAutomata> *_model;
    NSDictionary *_colorMap;
    float _animationSpeed;
    BOOL _running;
}

@synthesize cellGridView = _cellGridView;
@synthesize simulationSpeedSlider = _simulationSpeedSlider;
@synthesize preyBornSlider = _preyBornSlider;
@synthesize predatorBornSlider = _predatorBornSlider;
@synthesize predatorDeathSlider = _predatorDeathSlider;
@synthesize isIsotropicCheckbox = _isIsotropicCheckbox;

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
    [_cellGridView setNeedsDisplay:YES];
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

-(void)checkBoxStateChanged:(NSButton*)sender
{
    if (sender == self.isIsotropicCheckbox) {
        ((CAPredatorPrey*)_model).isIsotropic = sender.state;
    }
}

-(void)setupModel
{
    NSMutableDictionary* mutableColorMap = [[NSMutableDictionary alloc] init];
    [mutableColorMap setObject:[NSColor whiteColor] forKey:
                                    [NSNumber numberWithUnsignedInt:CTEmpty]];
    [mutableColorMap setObject:[NSColor darkGrayColor] forKey:
                                    [NSNumber numberWithUnsignedInt:CTPrey]];
    [mutableColorMap setObject:[NSColor redColor] forKey:
                                [NSNumber numberWithUnsignedInt:CTPredator]];
    _colorMap = [NSDictionary dictionaryWithDictionary:mutableColorMap];
    
    _model = [[CAPredatorPrey alloc] initWithWidth:CACellGridWidth 
                                            Height:CACellGridHeight];
    
    _animationSpeed = self.simulationSpeedSlider.floatValue / 100.0f;
    ((CAPredatorPrey*)_model).probabilityA = self.preyBornSlider.floatValue / 100.0f;
    ((CAPredatorPrey*)_model).probabilityB = self.predatorBornSlider.floatValue / 100.0f;
    ((CAPredatorPrey*)_model).probabilityC = self.predatorDeathSlider.floatValue / 100.0f; 
    ((CAPredatorPrey*)_model).isIsotropic = self.isIsotropicCheckbox.state;
}

-(void)animate
{
    double delayInSeconds = 1.005f - _animationSpeed;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (_running) {
            [_model nextIteration];
            _cellGridView.cellGrid = _model.cellGrid;
            [_cellGridView setNeedsDisplay:YES];
            [self animate];
        }
    });  
}
@end
