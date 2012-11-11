//
//  MyPredatorPreyModel.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 30.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CAPredatorPreyAutomata.h"
#define SWAP(A, B) {typeof(A) C; C = A; A = B; B = C;}
static inline float calculateCoef(CellType type, CellType *array, int len);

@interface CAPredatorPreyAutomata ()

- (void)populateGrid;
- (void)freeGrid:(Cell**)grid;
- (Cell**)allocGrid;
- (NSMutableSet*)fillCellsToDraw;

@end

@implementation CAPredatorPreyAutomata 
{
    Cell **_newGrid;
    CellGrid _cellGrid;
    float _probabilityA; //probability of birth of prey
    float _probabilityB; //probability of birth or predator and death of prey
    float _probabilityC; //probability of death of predator
    int _totalCellCount;
    int _preyCellCount;
    int _predatorCellCount;
    int _generation;
    CAPlotDataSet *_preyDataSet;
    CAPlotDataSet *_predatorDataSet;
}

-(id)initWithWidth:(int)width Height:(int)height
{
    self = [super init];
    if (self) {
        _cellGrid.width = width;
        _cellGrid.height = height;
        _totalCellCount = width * height;
        _preyDataSet = [[CAPlotDataSet alloc] init];
        _predatorDataSet = [[CAPlotDataSet alloc] init];
        [self populateGrid];
        _updatedCells = [self fillCellsToDraw];
    }
    return self;
}

-(void)nextIteration
{
    CellType middle;
    CellType neighbors[8];
    float neighborPreyCoef, neighborPredatorCoef;
    float r;
    int wrappedY, wrappedX; // To wrap array
    NSMutableSet *newUpdatedCells = [NSMutableSet set];

    for (int y = 0; y < _cellGrid.height; y++) {
        for (int x = 0; x < _cellGrid.width; x++) {
            middle = _cellGrid.grid[y][x];
            wrappedY = y == 0 ? _cellGrid.height - 1 : y - 1;
            wrappedX = x == 0 ? _cellGrid.width - 1 : x - 1;
            neighbors[0] = _cellGrid.grid[wrappedY][wrappedX]; // NW
            neighbors[1] = _cellGrid.grid[wrappedY][x]; // N
            neighbors[2] = _cellGrid.grid[wrappedY][(x +1) % _cellGrid.width]; // NE
            neighbors[3] = _cellGrid.grid[y][wrappedX]; //W
            neighbors[4] = _cellGrid.grid[y][(x +1) % _cellGrid.width]; // E
            neighbors[5] = _cellGrid.grid[(y + 1) % _cellGrid.height][wrappedX]; // SW
            neighbors[6] = _cellGrid.grid[(y + 1) % _cellGrid.height][x]; // S
            neighbors[7] = _cellGrid.grid[(y + 1) % _cellGrid.height][(x + 1) % _cellGrid.width]; // SE
             
            neighborPreyCoef = calculateCoef(CTPrey, neighbors, 8);
            neighborPredatorCoef = calculateCoef(CTPredator, neighbors, 8);
            
            r = (random() % 100) / 100.0f;
            
            if (middle == CTEmpty && neighborPreyCoef > 0.0f && r < (_probabilityA * neighborPreyCoef)) {
                _newGrid[y][x] = CTPrey;
                _preyCellCount++;
            }
            else if (middle == CTPrey && r < _probabilityB && neighborPredatorCoef > 0.0f) {
                _newGrid[y][x] = CTPredator;
                _predatorCellCount++;
                _preyCellCount--;
            }
            else if (middle == CTPredator && neighborPreyCoef <= 0.15f && r < _probabilityC) {
                _newGrid[y][x] = CTEmpty;
                _predatorCellCount--;
            }
            else {
                _newGrid[y][x] = middle;
                continue;
            }
        }
    }
    SWAP(_cellGrid.grid, _newGrid);
    _generation++;
    [_preyDataSet addValue:_preyCellCount];
    [_predatorDataSet addValue:_predatorCellCount];
    _updatedCells = newUpdatedCells;
}

-(void)populateGrid
{
    [self freeGrid:_cellGrid.grid];
    [self freeGrid:_newGrid];
    
    _cellGrid.grid = [self allocGrid];
    _newGrid = [self allocGrid];
    CellType newCell;
    int r;
    for (int y = 0; y < _cellGrid.height; y++) {
        for (int x = 0; x < _cellGrid.width; x++) {
            r = random() % 100;
            if (r < 1) {
                newCell = CTPredator;
                _predatorCellCount++;
            }
            else if (r >= 1 && r < 2) {
                newCell = CTPrey;
                _preyCellCount++;
            }
            else {
                newCell = CTEmpty;
            }
            _cellGrid.grid[y][x] = newCell;
        }
    }
    _generation = 0;
    [_preyDataSet addValue:_preyCellCount];
    [_predatorDataSet addValue:_predatorCellCount];
}

-(Cell**)allocGrid
{
    Cell **grid;
    grid = (Cell**)malloc(_cellGrid.height * sizeof(Cell*));
    for (int i = 0; i < _cellGrid.height; i++) {
        grid[i] = (Cell*) malloc(_cellGrid.width * sizeof(Cell));
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

-(void)saveDataToCSVFile:(NSString*)filename
{
    FILE *f = fopen(filename.UTF8String, "w"); 
    if (f == NULL) 
        return; 
    fprintf(f, "Prey count,Predator count\n"); 
    int preyCount, predatorCount;
    for(int i = 0; i < _preyDataSet.length && i < _predatorDataSet.length; i++)
    {
        preyCount = _preyDataSet.values[i];
        predatorCount = _predatorDataSet.values[i];
        fprintf(f, "%d,%d\n", preyCount, predatorCount); 
    }
    fclose(f);     
}

-(void)dealloc
{
    [self freeGrid:_cellGrid.grid];
    [self freeGrid:_newGrid];
}

-(NSMutableSet*)fillCellsToDraw {
    NSMutableSet *cells = [NSMutableSet set];
    for (int y = 0; y < _cellGrid.height; y++) {
        for (int x = 0; x < _cellGrid.width; x++) {
            [cells addObject:[NSValue valueWithPoint:NSMakePoint(y, x)]];
        }
    }
    return cells;
}

static inline float calculateCoef(CellType type, CellType *array, int len) {
    int count = 0;
    for (int i = 0; i < len; i++) {
        array[i] == type ? count++ : count;
    }
    return (float)count / (float)len;
}

@end
