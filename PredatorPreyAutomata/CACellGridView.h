//
//  CellGridView.h
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CAPredatorPrey.h"

@interface CACellGridView : NSView
{
}
@property (nonatomic) float animationSpeed; //from 0.0f to 1.0f
@property (nonatomic, readonly) BOOL running;
@property (nonatomic, readonly) CAPredatorPrey *model;

-(void)stopAnimation;
-(void)startAnimation;
-(void)resetAutomata;

@end
