//
//  CellGridView.h
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyPredatorPreyAutomata.h"

@interface MyCellGridView : NSView
{
    @private
    float animationSpeed; //from 0.0f to 1.0f
    BOOL running;
    MyPredatorPreyAutomata *model;
}
@property (nonatomic) float animationSpeed;
@property (nonatomic, readonly) BOOL running;
@property (nonatomic, readonly) MyPredatorPreyAutomata *model;

-(void)stopAnimation;
-(void)startAnimation;
-(void)resetAutomata;

@end
