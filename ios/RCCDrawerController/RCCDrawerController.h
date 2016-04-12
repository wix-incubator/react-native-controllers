#import <UIKit/UIKit.h>
#import "RCTBridge.h"
#import "MMDrawerController.h"
#import "RCCDrawerProtocol.h"

@interface RCCDrawerController : MMDrawerController <RCCDrawerDelegate>

- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children globalProps:(NSDictionary*)globalProps bridge:(RCTBridge *)bridge;
- (void)performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams bridge:(RCTBridge *)bridge;


@end
