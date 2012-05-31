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
- (int) countType:(CellType)type inArray:(CellType*)array withLen:(int)len;

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
        probA = 0.4f;
        probB = 0.4f;
        probC = 1.0f - probA - probB;
        [self populateGrid];        
    }
    return self;
}


-(void)nextIteration
{
    
    CellType middle = CTEmpty;
    CellType neighbors[4];
    int neighborPreyCount, neighborPredatorCount;
    float r;
    int tempIndex; // To wrap array
    
    for (int y = 0; y < _height; y++) {
        for (int x = 0; x < _width; x++) {
            
            middle = _grid[y][x];
            tempIndex = y == 0 ? _height - 1 : y;
            
            neighbors[0] = _grid[tempIndex][x];
            neighbors[1] = _grid[(y + 1) % _height][x];
            neighbors[2] = _grid[y][(x + 1) % _width];
            tempIndex = x == 0 ? _width - 1: x;
            neighbors[3] = _grid[y][tempIndex];
            
            neighborPreyCount = [self countType:CTPrey 
                                        inArray:neighbors 
                                        withLen:4];
            neighborPredatorCount = [self countType:CTPredator
                                            inArray:neighbors 
                                            withLen:4];
            
            r = (float)(arc4random() % 100) / 100.0f;
            
            if (middle == CTEmpty) {
                if (neighborPreyCount >= 1 && r < probA) {
                    _newGrid[y][x] = CTPrey;
                }
                else {
                    _newGrid[y][x] = middle;
                }
            }
            else if (middle == CTPrey) {
                if (neighborPreyCount > 1 && r < probB) {
                    _newGrid[y][x] = CTPredator;
                }
                else {
                    _newGrid[y][x] = middle;
                }
            }
            else if (middle == CTPredator) {
                if (r < probC) {
                    _newGrid[y][x] = CTEmpty;
                }
                else {
                    _newGrid[y][x] = middle;
                }
            }
            else {
                _newGrid[y][x] = middle;
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

-(int)countType:(CellType)type inArray:(CellType *)array withLen:(int)len
{
    int result = 0;
    for (int i = 0; i < len; i++) {
        array[i] == type ? result++ : result;
    }
    return result;
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
