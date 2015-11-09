#import <UIKit/UIKit.h>
#import "RCTBridge.h"

@interface RCCNavigationController : UINavigationController

- (instancetype)initWithParams:(NSDictionary *)params
                        bridge:(RCTBridge *)bridge
                     bundleURL:(NSURL *)bundleURL;

@end