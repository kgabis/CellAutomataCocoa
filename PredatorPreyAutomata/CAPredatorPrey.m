//
//  MyPredatorPreyModel.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CAPredatorPrey.h"

@interface CAPredatorPrey ()

- (void) populateGrid;
- (void) freeGrid:(Cell**)grid;
- (Cell**) allocGrid;
- (float) calculateCoefOf:(CellType)type inArray:(CellType*)array withLen:(int)len;

@end

@implementation CAPredatorPrey 
{
    Cell **_grid, **_newGrid;
    CellGrid _cellGrid;
    float _probabilityA; //probability of birth of prey
    float _probabilityB; //probability of birth or predator and death of prey
    float _probabilityC; //probability of death of predator

}

@synthesize cellGrid = _cellGrid;

@synthesize probabilityA = _probabilityA;
@synthesize probabilityB = _probabilityB;
@synthesize probabilityC = _probabilityC;

-(id)initWithWidth:(int)width Height:(int)height
{
    self = [super init];
    if (self) {
        _cellGrid.width = width;
        _cellGrid.height = height;
        [self populateGrid];        
    }
    return self;
}

-(void)nextIteration
{
    CellType middle = CTEmpty;
    CellType neighbors[4];
    float neighborPreyCoef, neighborPredatorCoef;
    float r;
    int tempIndex; // To wrap array
    
    for (int y = 0; y < _cellGrid.height; y++) {
        for (int x = 0; x < _cellGrid.width; x++) {
            
            middle = _grid[y][x];
            neighbors[0] = _grid[(y + 1) % _cellGrid.height][x]; //above
            neighbors[1] = _grid[y][(x + 1) % _cellGrid.width]; //right
            
            tempIndex = y == 0 ? _cellGrid.height - 1 : y - 1;            
            neighbors[2] = _grid[tempIndex][x]; //below
            tempIndex = x == 0 ? _cellGrid.width - 1 : x - 1;
            neighbors[3] = _grid[y][tempIndex]; //left
                
            neighborPreyCoef = [self calculateCoefOf:CTPrey 
                                             inArray:neighbors 
                                             withLen:4];
            neighborPredatorCoef = [self calculateCoefOf:CTPredator
                                                 inArray:neighbors 
                                                 withLen:4];
            
            r = (float)(arc4random() % 100) / 100.0f;
            
            if (middle == CTEmpty && neighborPreyCoef > 0.0f) {
                if (r < (_probabilityA * neighborPreyCoef)) {
                    _newGrid[y][x] = CTPrey;
                }
                else {
                    _newGrid[y][x] = middle;
                }
            }
            else if (middle == CTPrey) {
                if (r < _probabilityB && neighborPredatorCoef > 0.0f) {
                    _newGrid[y][x] = CTPredator;
                }
                else {
                    _newGrid[y][x] = middle;
                }
            }
            else if (middle == CTPredator && neighborPreyCoef <= 0.3f) {
                if (r < _probabilityC) {
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
    CellType** toSwap = _grid;
    _grid = _newGrid;
    _newGrid = toSwap;
    _cellGrid.grid = _grid;
}

-(void)populateGrid
{
    [self freeGrid:_grid];
    [self freeGrid:_newGrid];
    
    _grid = [self allocGrid];
    _newGrid = [self allocGrid];
    
    for (int y = 0; y < _cellGrid.height; y++) {
        for (int x = 0; x < _cellGrid.width; x++) {
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
    _cellGrid.grid = _grid;
}

-(float)calculateCoefOf:(CellType)type inArray:(CellType *)array withLen:(int)len
{
    int count = 0;
    for (int i = 0; i < len; i++) {
        array[i] == type ? count++ : count;
    }
    return (float)count / (float)len;
}

-(Cell**)allocGrid
{
    CellType **grid;
    grid = (Cell**)malloc(_cellGrid.width * sizeof(Cell*));
    for (int i = 0; i < _cellGrid.width; i++) {
        grid[i] = (Cell*) malloc(_cellGrid.height * sizeof(Cell));
        for (int j = 0; j < _cellGrid.height; j++) {
            grid[i][j] = CTEmpty;
        }
    }

    return grid;
}

-(void)freeGrid:(Cell**)grid
{
    if (grid != NULL) {
        for (int i = 0; i < _cellGrid.width; i++) {
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
