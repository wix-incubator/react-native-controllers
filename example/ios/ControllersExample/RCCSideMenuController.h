//
//  RCCSideMenuController.h
//  ControllersExample
//
//  Created by Ran Greenberg on 11/9/15.
//  Copyright © 2015 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTBridge.h"
#import "MMDrawerController.h"



@interface RCCSideMenuController : MMDrawerController

- (instancetype)initWithParams:(NSDictionary *)params
                        bridge:(RCTBridge *)bridge
                     bundleURL:(NSURL *)bundleURL;


@end
