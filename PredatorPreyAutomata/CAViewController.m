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
NSString * const CASimulationTypeKey = @"SimulationType";
enum {
    CACellGridWidth = 300,
    CACellGridHeight = 300
};

@interface CAViewController ()
-(void)animate;
-(void)setupModel;
-(void)updateTimer;
-(void)updateTextFields;
@end

@implementation CAViewController
{
    NSObject <CACellularAutomata> *_model;
    ColorMap _colorMap;
    float _simulationSpeed;
    BOOL _running;
    NSTimer *_timer;
    NSUserDefaults *_userDefaults;
    NSArray *_modelDataSets;    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
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
    if ([_userDefaults objectForKey:CASimulationTypeKey]) {
        [_simulationTypeComboBox selectItemAtIndex:[_userDefaults integerForKey:CASimulationTypeKey]];
    } else {
        [_simulationTypeComboBox selectItemAtIndex:0];
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
    [self updateTextFields];
    [_plotView setNeedsDisplayInRect:_plotView.bounds];
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
    float tempSimulationSpeed = _simulationSpeed > 1.0f ? 1.0f : _simulationSpeed;
    double delayInSeconds = 0.04f + (0.2f - 0.2f * tempSimulationSpeed);
    [_timer invalidate];
    if (_running) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:delayInSeconds
                                                  target:self 
                                                selector:@selector(animate) 
                                                userInfo:nil 
                                                 repeats:YES];
    }
}

-(void)settingChanged:(NSControl *)sender
{
    if (sender == self.simulationSpeedSlider) {
        [_userDefaults setFloat:sender.floatValue forKey:CAUpdateSpeedKey];
        _simulationSpeed = sender.floatValue;
        [self updateTimer];
    }
    else if (sender == self.preyBirthRateSlider) {
        [_userDefaults setFloat:sender.floatValue forKey:CAPreyBirthRateKey];
        ((CAPredatorPreyAutomata*)_model).probabilityA = sender.floatValue / 100.0f;
    }
    else if (sender == self.predatorBirthRateSlider) {
        [_userDefaults setFloat:sender.floatValue forKey:CAPredatorBirthRateKey];
        ((CAPredatorPreyAutomata*)_model).probabilityB = sender.floatValue / 100.0f;
    }
    else if (sender == self.predatorDeathRateSlider) {
        [_userDefaults setFloat:sender.floatValue forKey:CAPredatorDeathRateKey];
        ((CAPredatorPreyAutomata*)_model).probabilityC = sender.floatValue / 100.0f;        
    } else if (sender == self.simulationTypeComboBox) {
        [_userDefaults setInteger:((NSComboBox*)sender).indexOfSelectedItem
                         forKey:CASimulationTypeKey];
    }
    [self updateTextFields];
}

-(void)setupModel
{
    _colorMap.length = 3;
    _colorMap.colors = (NSColor * __autoreleasing *)malloc(_colorMap.length * sizeof(NSColor*));
    _colorMap.colors[CTEmpty] = [NSColor whiteColor];
    _colorMap.colors[CTPrey] = [NSColor darkGrayColor];
    _colorMap.colors[CTPredator] = [NSColor redColor];
    
    _model = [[CAPredatorPreyAutomata alloc] initWithWidth:CACellGridWidth 
                                            Height:CACellGridHeight];
    
    _simulationSpeed = self.simulationSpeedSlider.floatValue;
    ((CAPredatorPreyAutomata*)_model).probabilityA = self.preyBirthRateSlider.floatValue / 100.0f;
    ((CAPredatorPreyAutomata*)_model).probabilityB = self.predatorBirthRateSlider.floatValue / 100.0f;
    ((CAPredatorPreyAutomata*)_model).probabilityC = self.predatorDeathRateSlider.floatValue / 100.0f; 
    NSMutableArray *dataSets = [[NSMutableArray alloc] initWithCapacity:2];
    ((CAPredatorPreyAutomata*)_model).preyDataSet.color = _colorMap.colors[CTPrey];
    ((CAPredatorPreyAutomata*)_model).predatorDataSet.color = _colorMap.colors[CTPredator];
                                                                   
    [dataSets addObject:((CAPredatorPreyAutomata*)_model).preyDataSet];
    [dataSets addObject:((CAPredatorPreyAutomata*)_model).predatorDataSet];
    _plotView.setsToDraw = [NSArray arrayWithArray:dataSets];
}

-(void)animate
{
    SEL simulationSelector;
    if (_simulationTypeComboBox.indexOfSelectedItem == 0) {
        simulationSelector = @selector(nextIterationDeterministic);
    } else {
        simulationSelector = @selector(nextIterationNondeterministic);
    }
    if (_simulationSpeed <= 1.7f) {
        [_model performSelector:simulationSelector];
    }
    else {
        int iterationCounter = (int)(_simulationSpeed * 2.0f);
        while (iterationCounter--) {
            [_model performSelector:simulationSelector];
        }
    }
    
    _cellGridView.cellGrid = _model.cellGrid;
    [_cellGridView setNeedsDisplayInRect:_cellGridView.bounds]; 
    [self updateTextFields];
    [_plotView setNeedsDisplayInRect:_plotView.bounds];
}

-(void)updateTextFields
{
    [_generationTextField setIntValue:
                            ((CAPredatorPreyAutomata*)_model).generation];
    [_preyCountTextField setIntValue:
                            ((CAPredatorPreyAutomata*)_model).preyCellCount];
    [_predatorCountTextField setIntValue:
                            ((CAPredatorPreyAutomata*)_model).predatorCellCount];
    [_preyBirthRateTextField setFloatValue:
                            (_preyBirthRateSlider.floatValue / 100.0f)];
    [_predatorBirthRateTextField setFloatValue:
                            (_predatorBirthRateSlider.floatValue / 100.0f)];
    [_predatorDeathRateTextField setFloatValue:
                            (_predatorDeathRateSlider.floatValue / 100.0f)];
}

-(void)saveToCSVFile:(id)sender
{
    NSSavePanel *save = [NSSavePanel savePanel];
    [save setNameFieldStringValue:@"simulation.csv"];
    [save setDirectoryURL:[NSURL URLWithString:@"~/Desktop/"]];
    NSInteger result = [save runModal];
    if (result == NSOKButton) {
        NSString *selectedFile = save.URL.path;
        [(CAPredatorPreyAutomata*)_model saveDataToCSVFile:selectedFile];
    }
}

-(void)dealloc
{
    free(_colorMap.colors);
}
@end
