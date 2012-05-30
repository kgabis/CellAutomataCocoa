//
//  MyPredatorPreyModel.m
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import "MyPredatorPreyModel.h"

@interface MyPredatorPreyModel ()
- (void) allocAndPopulateGrid;
- (void) freeGrid;
@end

@implementation MyPredatorPreyModel 
{
    int _width, _height;
}

@synthesize grid;

-(id)initGridWithWidht:(int)width Height:(int)height
{
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        [self allocAndPopulateGrid];        
    }
    return self;
}


-(void)nextIteration
{
    [self allocAndPopulateGrid];
}

-(void)allocAndPopulateGrid
{
    [self freeGrid];
    self->grid = (CellType**)malloc(_width * sizeof(CellType*));
    for (int i = 0; i < _width; i++) {
        self->grid[i] = (CellType*) malloc(_height * sizeof(CellType));
    }
    for (int y = 0; y < _height; y++) {
        for (int x = 0; x < _width; x++) {
            int r = arc4random() % 100;
            CellType newCell = CTEmpty;
            if (r < 10) {
                newCell = CTPredator;
            }
            else if (r >= 10 && r < 20) {
                newCell = CTPrey;
            }
            else {
                newCell = CTEmpty;
            }
            self->grid[y][x] = newCell;
        }
    }
}

-(void)freeGrid
{
    if (self->grid != NULL) {
        for (int i = 0; i < _width; i++) {
            if (self->grid[i] != NULL) {
                free(self->grid[i]);
            }
        }
        free(self->grid);
    }
}

-(void)dealloc
{
    [self freeGrid];
}

@end
