//
//  CACellAutomata.h
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 03.06.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef unsigned int Cell;

typedef struct _CellGrid
{
    Cell** grid;
    int width;
    int height;
} CellGrid;

@protocol CACellularAutomata <NSObject>
-(void)initWithWidth:(unsigned int)width Height:(unsigned int)height;
-(void)nextIterationDeterministic;
-(CellGrid)cellGrid;
@end
