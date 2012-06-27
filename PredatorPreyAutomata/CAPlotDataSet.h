//
//  CAPlotDataSet.h
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 14.06.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAPlotDataSet : NSObject

@property (readonly) int *visibleValues;
@property (readonly) int visibleLength;
@property (readonly) int *values;
@property (readonly) int length;
@property NSColor *color;
@property (readonly) int max;
@property (readonly) int min;

-(void)addValue:(int)value;
-(void)clear;

@end
