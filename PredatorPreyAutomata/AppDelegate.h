//
//  AppDelegate.h
//  PredatorPreyAutomata
//
//  Created by Krzysztof Gabis on 29.05.2012.
//  Copyright (c) 2012 AGH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MyController;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet MyController* mainWindowController;
}
@property (assign) IBOutlet NSWindow *window;

@end
