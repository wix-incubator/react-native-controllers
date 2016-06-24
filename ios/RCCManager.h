#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import <UIKit/UIKit.h>

@interface RCCManager : NSObject

+ (instancetype)sharedInstance;
+ (instancetype)sharedIntance;

-(void)initBridgeWithBundleURL:(NSURL *)bundleURL initialProps:(NSDictionary *)initialProps launchOptions:(NSDictionary *)launchOptions;
-(void)initBridgeWithBundleURL:(NSURL *)bundleURL;
-(RCTBridge*)getBridge;

-(void)registerController:(UIViewController*)controller componentId:(NSString*)componentId componentType:(NSString*)componentType;
-(id)getControllerWithId:(NSString*)componentId componentType:(NSString*)componentType;
-(void)unregisterController:(UIViewController*)vc;

-(void)clearModuleRegistry;

@property (nonatomic, strong) NSDictionary *initialProps;

@end
