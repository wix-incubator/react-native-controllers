#import <UIKit/UIKit.h>
#import "RCTBridge.h"
#import "MMDrawerController.h"

@interface RCCDrawerController : MMDrawerController

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children bridge:(RCTBridge *)bridge;
- (void)performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams bridge:(RCTBridge *)bridge;

@end
