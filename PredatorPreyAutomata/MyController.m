//
//  MyMainWindowViewController.m
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import "MyController.h"

@implementation MyController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {                
        cellGridView.animationSpeed = simulationSpeedSlider.floatValue / 100.0f;
        cellGridView.model.probabilityA = preyBornSlider.floatValue / 100.0f;
        cellGridView.model.probabilityB = predatorBornSlider.floatValue / 100.0f;
    }
    return self;
}

-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(void)resetAutomata:(id)sender
{
    [cellGridView resetAutomata];
}

-(void)startAutomata:(id)sender
{
    [cellGridView startAnimation];
}

-(void)stopAutomata:(id)sender
{
    [cellGridView stopAnimation];
}

-(void)sliderChanged:(NSSlider *)sender
{
    if (sender == self->simulationSpeedSlider) {
        cellGridView.animationSpeed = simulationSpeedSlider.floatValue / 100.0f;
    }
    else if (sender == self->preyBornSlider) {
        cellGridView.model.probabilityA = preyBornSlider.floatValue / 100.0f;
    }
    else if (sender == self->predatorBornSlider) {
        cellGridView.model.probabilityB = predatorBornSlider.floatValue / 100.0f;
    }
}

@end
