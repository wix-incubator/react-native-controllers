//
//  RNCubeController.m
//  ReactNativeControllers
//
//  Created by Pavlo Aksonov on 22/07/16.
//  Copyright © 2016 artal. All rights reserved.
//

#import "RNCubeController.h"
#import "RCCViewController.h"
#import "RCTConvert.h"
#import "RCCManager.h"
#import "ADTransitionController/ADTransitionController.h"

@implementation RNCubeController {
    NSMutableArray<UIViewController *> *_controllers;
    int _currentIndex;
}

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children globalProps:(NSDictionary*)globalProps bridge:(RCTBridge *)bridge
{
    _controllers = [NSMutableArray array];
    int index = 0;
    _currentIndex = 0;
    
    // go over all the tab bar items
    for (NSDictionary *tabItemLayout in children)
    {
        // make sure the layout is valid
        if (![tabItemLayout[@"type"] isEqualToString:@"CubeBarControllerIOS.Item"]) continue;
        if (!tabItemLayout[@"props"]) continue;
        
        // get the view controller inside
        if (!tabItemLayout[@"children"]) continue;
        if (![tabItemLayout[@"children"] isKindOfClass:[NSArray class]]) continue;
        if ([tabItemLayout[@"children"] count] < 1) continue;
        NSDictionary *childLayout = tabItemLayout[@"children"][0];
        UIViewController *viewController = [RCCViewController controllerWithLayout:childLayout globalProps:globalProps bridge:bridge];
        if (!viewController) continue;
        
        [_controllers addObject:viewController];
        
    }
    self = [super initWithRootViewController:_controllers[0]];
    if (!self) return nil;
    
    return self;
}

- (void)performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams bridge:(RCTBridge *)bridge completion:(void (^)(void))completion
{
    if ([performAction isEqualToString:@"switchTo"])
    {
        UIViewController *viewController = nil;
        NSNumber *tabIndex = actionParams[@"tabIndex"];
        int newIndex = -1;
        if (tabIndex)
        {
            int i = (int)[tabIndex integerValue];
            
            if ([_controllers count] > i)
            {
                viewController = [_controllers objectAtIndex:i];
                newIndex = i;
            }
        }
        NSString *contentId = actionParams[@"contentId"];
        NSString *contentType = actionParams[@"contentType"];
        if (contentId && contentType)
        {
            viewController = [[RCCManager sharedInstance] getControllerWithId:contentId componentType:contentType];
            
            for (int i=0;i<[_controllers count];i++){
                if ([_controllers[i] isEqual:viewController]){
                    newIndex = i;
                }
            }
        }
        if (newIndex != -1){
            if (newIndex > _currentIndex){
                ADTransition * animation = [[ADCubeTransition alloc] initWithDuration:0.5f orientation:ADTransitionTopToBottom sourceRect:_controllers[newIndex].view.frame];
                [self pushViewController:_controllers[newIndex] withTransition:animation];
            }
            if (newIndex < _currentIndex){
                [self popToRootViewController];
            }
            _currentIndex = newIndex;
        }
    }
}
@end
