//
//  MyPredatorPreyModel.h
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CACellularAutomata.h"
#import "CAPlotDataSet.h"

typedef enum {
    CTEmpty = 0,
    CTPrey = 1,
    CTPredator = 2
} CellType;

@interface CAPredatorPreyAutomata : NSObject <CACellularAutomata>
{
}

@property (readonly) CellGrid cellGrid;
@property float probabilityA;
@property float probabilityB;
@property float probabilityC;
@property (readonly) int totalCellCount;
@property (readonly) int preyCellCount;
@property (readonly) int predatorCellCount;
@property (readonly) int generation;
@property (readonly) CAPlotDataSet *preyDataSet;
@property (readonly) CAPlotDataSet *predatorDataSet;

- (id)initWithWidth:(int)width Height:(int)height;
- (void)nextIterationDeterministic;
- (void)nextIterationNondeterministic;
- (void)saveDataToCSVFile:(NSString*)filename;

@end
