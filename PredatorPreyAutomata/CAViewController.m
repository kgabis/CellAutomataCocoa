//
//  CAViewController.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CAViewController.h"
#import "CACellularAutomata.h"

NSString * const CAUpdateSpeedKey = @"UpdateSpeed";
NSString * const CAPreyBirthRateKey = @"PreyBirthRate";
NSString * const CAPredatorBirthRateKey = @"PredatorBirthRate";
NSString * const CAPredatorDeathRateKey = @"PredatorDeathRate";

enum {
    CACellGridWidth = 300,
    CACellGridHeight = 300
};

@interface CAViewController ()
-(void)animate;
-(void)setupModel;
-(void)updateTimer;
@end

@implementation CAViewController
{
    IBOutlet CACellGridView *_cellGridView;
    IBOutlet NSSlider *_simulationSpeedSlider;
    IBOutlet NSSlider *_preyBirthRateSlider;
    IBOutlet NSSlider *_predatorBirthRateSlider;
    IBOutlet NSSlider *_predatorDeathRateSlider;
    NSObject <CACellularAutomata> *_model;
    ColorMap _colorMap;
    float _animationSpeed;
    BOOL _running;
    NSTimer *_timer;
    NSUserDefaults *_userDefaults;
}

@synthesize cellGridView = _cellGridView;
@synthesize simulationSpeedSlider = _simulationSpeedSlider;
@synthesize preyBirthRateSlider = _preyBirthRateSlider;
@synthesize predatorBirthRateSlider = _predatorBirthRateSlider;
@synthesize predatorDeathRateSlider = _predatorDeathRateSlider;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupModel];
        _running = NO;
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}
         
-(void)awakeFromNib
{
    if ([_userDefaults objectForKey:CAUpdateSpeedKey]) {
        _simulationSpeedSlider.floatValue = [_userDefaults floatForKey:CAUpdateSpeedKey];
    }
    if ([_userDefaults objectForKey:CAPreyBirthRateKey]) {
        _preyBirthRateSlider.floatValue = [_userDefaults floatForKey:CAPreyBirthRateKey];
    }
    if ([_userDefaults objectForKey:CAPredatorBirthRateKey]) {
        _predatorBirthRateSlider.floatValue = [_userDefaults floatForKey:CAPredatorBirthRateKey];
    }
    if ([_userDefaults objectForKey:CAPredatorDeathRateKey]) {
        _predatorDeathRateSlider.floatValue = [_userDefaults floatForKey:CAPredatorDeathRateKey];
    }
    
    [self setupModel];
    _cellGridView.colorMap = _colorMap;
    [self startAutomata:nil];
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
        [self updateTimer];
    }
}

-(void)stopAutomata:(id)sender
{
    _running = NO;
    [self updateTimer];
}

-(void)updateTimer
{
    double delayInSeconds = 1.005f - _animationSpeed;
    [_timer invalidate];
    if (_running) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:delayInSeconds 
                                                  target:self 
                                                selector:@selector(animate) 
                                                userInfo:nil 
                                                 repeats:YES];
    }
}

-(void)sliderChanged:(NSSlider *)sender
{
    if (sender == self.simulationSpeedSlider) {
        [_userDefaults setFloat:sender.floatValue forKey:CAUpdateSpeedKey];
        _animationSpeed = sender.floatValue / 100.0f;
        [self updateTimer];
    }
    else if (sender == self.preyBirthRateSlider) {
        [_userDefaults setFloat:sender.floatValue forKey:CAPreyBirthRateKey];
        ((CAPredatorPrey*)_model).probabilityA = sender.floatValue / 100.0f;
    }
    else if (sender == self.predatorBirthRateSlider) {
        [_userDefaults setFloat:sender.floatValue forKey:CAPredatorBirthRateKey];
        ((CAPredatorPrey*)_model).probabilityB = sender.floatValue / 100.0f;
    }
    else if (sender == self.predatorDeathRateSlider) {
        [_userDefaults setFloat:sender.floatValue forKey:CAPredatorDeathRateKey];
        ((CAPredatorPrey*)_model).probabilityC = sender.floatValue / 100.0f;        
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
    ((CAPredatorPrey*)_model).probabilityA = self.preyBirthRateSlider.floatValue / 100.0f;
    ((CAPredatorPrey*)_model).probabilityB = self.predatorBirthRateSlider.floatValue / 100.0f;
    ((CAPredatorPrey*)_model).probabilityC = self.predatorDeathRateSlider.floatValue / 100.0f; 
}

-(void)animate
{ 
    [_model nextIteration];
    _cellGridView.cellGrid = _model.cellGrid;
    [_cellGridView setNeedsDisplayInRect:_cellGridView.bounds]; 
}

-(void)dealloc
{
    free(_colorMap.colors);
}
@end
