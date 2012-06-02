//
//  AppDelegate.h
//  CellularAutomataCocoa
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 Krzysztof Gabis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CAViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet CAViewController* mainWindowController;
}
@property (assign) IBOutlet NSWindow *window;

@end
