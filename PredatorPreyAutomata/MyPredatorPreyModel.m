//
//  MyPredatorPreyModel.m
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import "MyPredatorPreyModel.h"

@interface MyPredatorPreyModel ()
- (void) populateGrid;
- (void) freeGrid:(CellType**)grid;
- (CellType**) allocGrid;

@end

@implementation MyPredatorPreyModel 
{
    int _width, _height;
    CellType **_grid, **_newGrid;

}

@synthesize grid = _grid;

-(id)initGridWithWidht:(int)width Height:(int)height
{
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        probA = 0.15f;
        probB = 0.5;
        probC = 1.0f - probA - probB;
        [self populateGrid];        
    }
    return self;
}


-(void)nextIteration
{
    
    CellType middle = CTEmpty,
             north = CTEmpty,
             south = CTEmpty,
             east = CTEmpty,
             west = CTEmpty;
    int neighborPrey, neighborPredators;
    float r;
    for (int y = 0; y < _height; y++) {
        for (int x = 0; x < _width; x++) {
            //problem ze znakiem w modulo
            middle = _grid[y][x];
            int index = (y - 1) % _height;
            index++;
            //north = _grid[abs((y - 1) % _height)][x];
            south = _grid[(y + 1) % _height][x];
            east = _grid[y][(x + 1) % _width];
            //west = _grid[y][abs((x - 1) % _width)];
            
            r = (float)(arc4random() % 100) / 100.0f;
            
            if (middle == CTEmpty) {
                if ((south == CTPrey || east == CTPrey) && r < probA) {
                    _newGrid[y][x] = CTPrey;
                }
                else {
                    _newGrid[y][x] = _grid[y][x];
                }
            }
            else if (middle == CTPrey) {
                if ((south == CTPrey || east == CTPrey) && r < probB) {
                    _newGrid[y][x] = CTPredator;
                }
                else {
                    _newGrid[y][x] = _grid[y][x];
                }
            }
            else if (middle == CTPredator) {
                if (r < probC) {
                    _newGrid[y][x] = CTEmpty;
                }
                else {
                    _newGrid[y][x] = _grid[y][x];
                }
            }
            else {
                _newGrid[y][x] = _grid[y][x];
            }
        }
    }
    CellType** toswap = _grid;
    _grid = _newGrid;
    _newGrid = toswap;
    //[self populateGrid];
}

-(void)populateGrid
{
    [self freeGrid:_grid];
    [self freeGrid:_newGrid];
    
    _grid = [self allocGrid];
    _newGrid = [self allocGrid];
    
    for (int y = 0; y < _height; y++) {
        for (int x = 0; x < _width; x++) {
            int r = arc4random() % 100;
            CellType newCell = CTEmpty;
            if (r < 1) {
                newCell = CTPredator;
            }
            else if (r >= 1 && r < 2) {
                newCell = CTPrey;
            }
            else {
                newCell = CTEmpty;
            }
            _grid[y][x] = newCell;
        }
    }
}

-(CellType**)allocGrid
{
    CellType **grid;
    grid = (CellType**)malloc(_width * sizeof(CellType*));
    for (int i = 0; i < _width; i++) {
        grid[i] = (CellType*) malloc(_height * sizeof(CellType));
        for (int j = 0; j < _height; j++) {
            grid[i][j] = CTEmpty;
        }
    }
    return grid;
}

-(void)freeGrid:(CellType**)grid
{
    if (grid != NULL) {
        for (int i = 0; i < _width; i++) {
            if (grid[i] != NULL) {
                free(grid[i]);
            }
        }
        free(grid);
    }
}

-(void)dealloc
{
    [self freeGrid:_grid];
    [self freeGrid:_newGrid];
}

@end
