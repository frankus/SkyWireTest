//
//  SkyWireTestAppDelegate.m
//  SkyWireTest
//
//  Created by Frank Schmitt on 2010-12-21.
//  Copyright © 2011 Laika Systems
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "SkyWireTestAppDelegate.h"
#import "RootViewController.h"
#import <ExternalAccessory/ExternalAccessory.h>


@implementation SkyWireTestAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryConnected) name:EAAccessoryDidConnectNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDisconnected) name:EAAccessoryDidDisconnectNotification object:nil];
	
    return YES;
}

- (void)accessoryConnected {
	EAAccessory *accessory = [[[EAAccessoryManager sharedAccessoryManager] connectedAccessories] objectAtIndex:0];

	session = [[EASession alloc] initWithAccessory:accessory forProtocol:@"com.southernstars.sw9a"];
	
	if (session) {
		[[session inputStream] setDelegate:self];
		[[session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[[session inputStream] open];

		[[session outputStream] setDelegate:self];
		[[session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[[session outputStream] open];
	}
}

- (void)accessoryDisconnected {
	[session release];
	session = nil;
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
	switch (eventCode) {
		case NSStreamEventNone:
			NSLog(@"stream %@ event none", aStream);
			break;
		case NSStreamEventOpenCompleted:
			[[[[UIAlertView alloc] initWithTitle:@"Stream Open" message:[NSString stringWithFormat:@"Stream %@ has opened", aStream] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
			break;
		case NSStreamEventHasBytesAvailable:
			[[[[UIAlertView alloc] initWithTitle:@"Stream Has Bytes" message:[NSString stringWithFormat:@"Stream %@ has bytes", aStream] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
			break;
		case NSStreamEventHasSpaceAvailable:
			[[[[UIAlertView alloc] initWithTitle:@"Stream Has Space" message:[NSString stringWithFormat:@"Stream %@ has space", aStream] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
			break;
		case NSStreamEventErrorOccurred:
			[[[[UIAlertView alloc] initWithTitle:@"Stream Error" message:[[aStream streamError] localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
			break;
		case NSStreamEventEndEncountered:
			[[[[UIAlertView alloc] initWithTitle:@"Stream Ended" message:[NSString stringWithFormat:@"Stream %@ has ended", aStream] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
			break;
		default:
			[[[[UIAlertView alloc] initWithTitle:@"Something Else Happened" message:[NSString stringWithFormat:@"Event code %d", eventCode] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
			break;
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

