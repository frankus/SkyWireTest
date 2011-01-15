//
//  SkyWireTestAppDelegate.h
//  SkyWireTest
//
//  Created by Frank Schmitt on 2010-12-21.
//  Copyright 2010 Laika Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EASession;

@interface SkyWireTestAppDelegate : NSObject <UIApplicationDelegate, NSStreamDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	EASession *session;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

