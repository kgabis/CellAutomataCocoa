//
//  CARectColorArray.m
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 06.06.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import "CARectColorArray.h"

@implementation CARectColorArray

-(id)initWithLength:(int)length
{
    self = [super init];
    if (self) {
        _length = length;
        _rects = (NSRect *) malloc(length * sizeof(NSRect));
        _colors = (NSColor * __autoreleasing *) malloc(length * sizeof(NSColor*));
    }
    return self;
}

- (void)addRect:(NSRect)rect Color:(NSColor *)color
{
    if (_count < _length) {
        _rects[_count] = rect;
        _colors[_count] = color;
        _count++;
    }
}

-(void)clear
{
    _count = 0;
}

-(void)dealloc
{
    free(_rects);
    free(_colors);
}

@end
