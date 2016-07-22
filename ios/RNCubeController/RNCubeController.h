//
//  RNCubeController.h
//  ReactNativeControllers
//
//  Created by Pavlo Aksonov on 22/07/16.
//  Copyright © 2016 artal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridge.h"
#import "ADTransitionController/ADTransitionController.h"
@interface RNCubeController : ADTransitionController

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children globalProps:(NSDictionary*)globalProps bridge:(RCTBridge *)bridge;
- (void)performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams bridge:(RCTBridge *)bridge completion:(void (^)(void))completion;

@end
