#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import <UIKit/UIKit.h>

@interface RCCManager : NSObject

+ (instancetype)sharedIntance;

-(void)initBridgeWithBundleURL:(NSURL *)bundleURL;
-(RCTBridge*)getBridge;
-(void)setLoadingView:(UIView *)loadingView;

-(void)registerController:(UIViewController*)controller componentId:(NSString*)componentId componentType:(NSString*)componentType;
-(id)getControllerWithId:(NSString*)componentId componentType:(NSString*)componentType;
-(void)unregisterController:(NSString*)componentId componentType:(NSString*)componentType;

@end
