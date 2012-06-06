//
//  CARectColorArray.h
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 06.06.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CARectColorArray : NSObject

@property (readonly) int count;
@property (readonly) NSRect *rects;
@property (readonly) NSColor * __autoreleasing * colors;
@property (readonly) int length;

- (id)initWithLength:(int)length;
- (void)addRect:(NSRect)rect Color:(NSColor*)color;
- (void)clear;

@end
