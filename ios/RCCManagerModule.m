#import "RCCManagerModule.h"
#import "RCCManager.h"
#import <UIKit/UIKit.h>
#import "RCCNavigationController.h"
#import "RCCViewController.h"
#import "RCCDrawerController.h"
#import "RCCLightBox.h"
#import "RCTConvert.h"
#import "RCCTabBarController.h"

#define kSlideDownAnimationDuration 0.35

typedef NS_ENUM(NSInteger, RCCManagerModuleErrorCode)
{
    RCCManagerModuleCantCreateControllerErrorCode   = -100,
    RCCManagerModuleCantFindTabControllerErrorCode  = -200,
    RCCManagerModuleMissingParamsErrorCode          = -300
};

@implementation RCTConvert (RCCManagerModuleErrorCode)

RCT_ENUM_CONVERTER(RCCManagerModuleErrorCode,
                   (@{@"RCCManagerModuleCantCreateControllerErrorCode": @(RCCManagerModuleCantCreateControllerErrorCode),
                      @"RCCManagerModuleCantFindTabControllerErrorCode": @(RCCManagerModuleCantFindTabControllerErrorCode),
                      }), RCCManagerModuleCantCreateControllerErrorCode, integerValue)
@end

@implementation RCCManagerModule

RCT_EXPORT_MODULE(RCCManager);

#pragma mark - constatnts export

- (NSDictionary *)constantsToExport
{
    return @{
             //Error codes
             @"RCCManagerModuleCantCreateControllerErrorCode" : @(RCCManagerModuleCantCreateControllerErrorCode),
             @"RCCManagerModuleCantFindTabControllerErrorCode" : @(RCCManagerModuleCantFindTabControllerErrorCode),
             };
}

+(UIViewController*)modalPresenterViewControllers:(NSMutableArray*)returnAllPresenters
{
    UIViewController *modalPresenterViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ((returnAllPresenters != nil) && (modalPresenterViewController != nil))
    {
        [returnAllPresenters addObject:modalPresenterViewController];
    }
    
    while (modalPresenterViewController.presentedViewController != nil)
    {
        modalPresenterViewController = modalPresenterViewController.presentedViewController;
        
        if (returnAllPresenters != nil)
        {
            [returnAllPresenters addObject:modalPresenterViewController];
        }
    }
    return modalPresenterViewController;
}

+(UIViewController*)lastModalPresenterViewController
{
    return [self modalPresenterViewControllers:nil];
}

+(NSError*)rccErrorWithCode:(NSInteger)code description:(NSString*)description
{
    NSString *safeDescription = (description == nil) ? @"" : description;
    return [NSError errorWithDomain:@"RCCControllers" code:code userInfo:@{NSLocalizedDescriptionKey: safeDescription}];
}

+(void)handleRCTPromiseRejectBlock:(RCTPromiseRejectBlock)reject error:(NSError*)error
{
    reject([NSString stringWithFormat: @"%lu", (long)error.code], error.localizedDescription, error);
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(
setRootController:(NSDictionary*)layout animationType:(NSString*)animationType globalProps:(NSDictionary*)globalProps)
{
    //first clear the registry to remove any refernece to the previous controllers
    [[RCCManager sharedInstance] clearModuleRegistry];
    
    // create the new controller
    UIViewController *controller = [RCCViewController controllerWithLayout:layout globalProps:globalProps bridge:[[RCCManager sharedInstance] getBridge]];
    if (controller == nil) return;

    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    
    if ((appDelegate.window.rootViewController == nil) || ([animationType isEqualToString:@"none"]))
    {
        // set this new controller as the root
        appDelegate.window.rootViewController = controller;
        [appDelegate.window makeKeyAndVisible];
    }
    else
    {
        UIViewController *presentedViewController = nil;
        if(appDelegate.window.rootViewController.presentedViewController != nil)
            presentedViewController = appDelegate.window.rootViewController.presentedViewController;
        else
            presentedViewController = appDelegate.window.rootViewController;
        
        UIView *snapshot = [presentedViewController.view snapshotViewAfterScreenUpdates:NO];
        appDelegate.window.rootViewController = controller;
        [appDelegate.window.rootViewController.view addSubview:snapshot];
        [presentedViewController dismissViewControllerAnimated:NO completion:nil];
        
        [UIView animateWithDuration:kSlideDownAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^()
         {
             if (animationType == nil || [animationType isEqualToString:@"slide-down"])
             {
                 snapshot.transform = CGAffineTransformMakeTranslation(0, snapshot.frame.size.height);
             }
             else if ([animationType isEqualToString:@"fade"])
             {
                 snapshot.alpha = 0;
             }
         }
                         completion:^(BOOL finished)
         {
             [snapshot removeFromSuperview];
         }];
    }
}

RCT_EXPORT_METHOD(
NavigationControllerIOS:(NSString*)controllerId performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams)
{
  if (!controllerId || !performAction) return;
  RCCNavigationController* controller = [[RCCManager sharedInstance] getControllerWithId:controllerId componentType:@"NavigationControllerIOS"];
  if (!controller || ![controller isKindOfClass:[RCCNavigationController class]]) return;
  return [controller performAction:performAction actionParams:actionParams bridge:[[RCCManager sharedInstance] getBridge]];
}

RCT_EXPORT_METHOD(
DrawerControllerIOS:(NSString*)controllerId performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams)
{
  if (!controllerId || !performAction) return;
  RCCDrawerController* controller = [[RCCManager sharedInstance] getControllerWithId:controllerId componentType:@"DrawerControllerIOS"];
  if (!controller || ![controller isKindOfClass:[RCCDrawerController class]]) return;
  return [controller performAction:performAction actionParams:actionParams bridge:[[RCCManager sharedInstance] getBridge]];
}

RCT_EXPORT_METHOD(
TabBarControllerIOS:(NSString*)controllerId performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    if (!controllerId || !performAction)
    {
        [RCCManagerModule handleRCTPromiseRejectBlock:reject
                                                error:[RCCManagerModule rccErrorWithCode:RCCManagerModuleMissingParamsErrorCode description:@"missing params"]];
        return;
    }
    
    RCCTabBarController* controller = [[RCCManager sharedInstance] getControllerWithId:controllerId componentType:@"TabBarControllerIOS"];
    if (!controller || ![controller isKindOfClass:[RCCTabBarController class]])
    {
        [RCCManagerModule handleRCTPromiseRejectBlock:reject
                                                error:[RCCManagerModule rccErrorWithCode:RCCManagerModuleCantFindTabControllerErrorCode description:@"could not find UITabBarController"]];
        return;
    }
    [controller performAction:performAction actionParams:actionParams bridge:[[RCCManager sharedInstance] getBridge] completion:^(){ resolve(nil); }];
}

RCT_EXPORT_METHOD(
modalShowLightBox:(NSDictionary*)params)
{
    [RCCLightBox showWithParams:params];
}

RCT_EXPORT_METHOD(
modalDismissLightBox)
{
    [RCCLightBox dismiss];
}

RCT_EXPORT_METHOD(
showController:(NSDictionary*)layout animationType:(NSString*)animationType globalProps:(NSDictionary*)globalProps resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    UIViewController *controller = [RCCViewController controllerWithLayout:layout globalProps:globalProps bridge:[[RCCManager sharedInstance] getBridge]];
    if (controller == nil)
    {
        [RCCManagerModule handleRCTPromiseRejectBlock:reject
                                                error:[RCCManagerModule rccErrorWithCode:RCCManagerModuleCantCreateControllerErrorCode description:@"could not create controller"]];
        return;
    }

    [[RCCManagerModule lastModalPresenterViewController] presentViewController:controller
                                                           animated:![animationType isEqualToString:@"none"]
                                                         completion:^(){ resolve(nil); }];
}

RCT_EXPORT_METHOD(
dismissController:(NSString*)animationType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RCCManagerModule lastModalPresenterViewController] dismissViewControllerAnimated:![animationType isEqualToString:@"none"]
                                                                 completion:^(){ resolve(nil); }];
}

RCT_EXPORT_METHOD(
dismissAllControllers:(NSString*)animationType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSMutableArray *allPresentedViewControllers = [NSMutableArray array];
    [RCCManagerModule modalPresenterViewControllers:allPresentedViewControllers];
    
    BOOL animated = ![animationType isEqualToString:@"none"];
    if (animated)
    {
        id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
        UIView *snapshot = [appDelegate.window snapshotViewAfterScreenUpdates:NO];
        [appDelegate.window addSubview:snapshot];
        
        [UIView animateWithDuration:kSlideDownAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^()
         {
             if (animationType == nil || [animationType isEqualToString:@"slide-down"])
             {
                 snapshot.transform = CGAffineTransformMakeTranslation(0, snapshot.frame.size.height);
             }
             else if ([animationType isEqualToString:@"fade"])
             {
                 snapshot.alpha = 0;
             }
         }
                         completion:^(BOOL finished)
         {
             [snapshot removeFromSuperview];
             resolve(nil);
         }];
    }
    
    for (UIViewController *viewController in allPresentedViewControllers)
    {
        [viewController dismissViewControllerAnimated:NO completion:nil];
    }
    [allPresentedViewControllers removeAllObjects];
    
    if (!animated)
    {
        resolve(nil);
    }
}

@end
