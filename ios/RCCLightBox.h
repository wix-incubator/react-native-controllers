
#import <UIKit/UIKit.h>

@interface RCCLightBox : NSObject
+(void)showWithComponentId:(NSString*)componentId style:(NSDictionary*)style;
+(void)dismiss;
@end
