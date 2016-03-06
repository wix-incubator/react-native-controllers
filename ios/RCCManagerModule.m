#import "RCCManagerModule.h"
#import "RCCManager.h"
#import <UIKit/UIKit.h>
#import "RCCNavigationController.h"
#import "RCCViewController.h"
#import "RCCDrawerController.h"
#import "RCCLightBox.h"

@implementation RCCManagerModule

RCT_EXPORT_MODULE(RCCManager);

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(
setRootController:(NSDictionary*)layout)
{
    // create the new controller
    UIViewController *controller = [RCCViewController controllerWithLayout:layout bridge:[[RCCManager sharedIntance] getBridge]];
    if (controller == nil) return;

    // set this new controller as the root
    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = controller;
    [appDelegate.window makeKeyAndVisible];
}

RCT_EXPORT_METHOD(
NavigationControllerIOS:(NSString*)controllerId performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams)
{
  if (!controllerId || !performAction) return;
  RCCNavigationController* controller = [[RCCManager sharedIntance] getControllerWithId:controllerId componentType:@"NavigationControllerIOS"];
  if (!controller || ![controller isKindOfClass:[RCCNavigationController class]]) return;
  return [controller performAction:performAction actionParams:actionParams bridge:[[RCCManager sharedIntance] getBridge]];
}

RCT_EXPORT_METHOD(
DrawerControllerIOS:(NSString*)controllerId performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams)
{
  if (!controllerId || !performAction) return;
  RCCDrawerController* controller = [[RCCManager sharedIntance] getControllerWithId:controllerId componentType:@"DrawerControllerIOS"];
  if (!controller || ![controller isKindOfClass:[RCCDrawerController class]]) return;
  return [controller performAction:performAction actionParams:actionParams bridge:[[RCCManager sharedIntance] getBridge]];
}

RCT_EXPORT_METHOD(
showLightBox:(NSString*)componentId)
{
    [RCCLightBox showWithComponentId:componentId];
}

RCT_EXPORT_METHOD(
dismissLightBox)
{
    [RCCLightBox dismiss];
}

RCT_EXPORT_METHOD(
showController:(NSDictionary*)layout animated:(BOOL)animated resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    UIViewController *controller = [RCCViewController controllerWithLayout:layout bridge:[[RCCManager sharedIntance] getBridge]];
    if (controller == nil)
    {
        reject([NSError errorWithDomain:@"RCCControllers" code:-100 userInfo:@{NSLocalizedDescriptionKey: @"could not create controller"}]);
        return;
    }
    
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootViewController presentViewController:controller animated:animated completion:^(){ resolve(nil); }];
}

RCT_EXPORT_METHOD(
dismissController:(BOOL)animated resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootViewController dismissViewControllerAnimated:animated completion:^(){ resolve(nil); }];
}
                  
@end
