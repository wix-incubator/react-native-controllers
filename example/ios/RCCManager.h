//
//  RCCManager.h
//  ControllersExample
//
//  Created by Artal Druk on 11/9/15.
//  Copyright © 2015 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import <UIKit/UIKit.h>

@interface RCControllersRegistry : NSObject
+ (instancetype)sharedIntance;
-(void)registerController:(UIViewController*)controller componentID:(NSString*)componentID componentType:(NSString*)componentType;
@end

@interface RCCManager : NSObject <RCTBridgeModule>
@end
