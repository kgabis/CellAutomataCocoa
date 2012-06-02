//
//  MyMainWindowViewController.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CAViewController.h"

@interface CAViewController ()
-(void)setupModel;
@end

@implementation CAViewController
{
    IBOutlet CACellGridView *_cellGridView;
    IBOutlet NSSlider *_simulationSpeedSlider;
    IBOutlet NSSlider *_preyBornSlider;
    IBOutlet NSSlider *_predatorBornSlider;
    IBOutlet NSButton *_isIsotropicCheckbox;
}

@synthesize cellGridView = _cellGridView;
@synthesize simulationSpeedSlider = _simulationSpeedSlider;
@synthesize preyBornSlider = _preyBornSlider;
@synthesize predatorBornSlider = _predatorBornSlider;
@synthesize isIsotropicCheckbox = _isIsotropicCheckbox;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {                
    }
    return self;
}
         
-(void)awakeFromNib
{
    [self setupModel];
    [self.cellGridView startAnimation];
}


-(void)resetAutomata:(id)sender
{
    [self.cellGridView resetAutomata];
    [self setupModel];
}

-(void)startAutomata:(id)sender
{
    [self.cellGridView startAnimation];
}

-(void)stopAutomata:(id)sender
{
    [self.cellGridView stopAnimation];
}

-(void)sliderChanged:(NSSlider *)sender
{
    if (sender == self.simulationSpeedSlider) {
        self.cellGridView.animationSpeed = self.simulationSpeedSlider.floatValue / 100.0f;
    }
    else if (sender == self.preyBornSlider) {
        self.cellGridView.model.probabilityA = self.preyBornSlider.floatValue / 100.0f;
    }
    else if (sender == self.predatorBornSlider) {
        self.cellGridView.model.probabilityB = self.predatorBornSlider.floatValue / 100.0f;
    }
}

-(void)checkBoxStateChanged:(NSButton*)sender
{
    if (sender == self.isIsotropicCheckbox) {
        self.cellGridView.model.isIsotropic = sender.state;
    }
}

-(void)setupModel
{
    self.cellGridView.animationSpeed = self.simulationSpeedSlider.floatValue / 100.0f;
    self.cellGridView.model.probabilityA = self.preyBornSlider.floatValue / 100.0f;
    self.cellGridView.model.probabilityB = self.predatorBornSlider.floatValue / 100.0f;
    self.cellGridView.model.isIsotropic = self.isIsotropicCheckbox.state;
}
@end
