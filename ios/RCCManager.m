#import "RCCManager.h"
#import "RCTBridge.h"
#import <Foundation/Foundation.h>

@interface RCCManager()
@property (nonatomic, strong) NSMutableDictionary *modulesRegistry;
@property (nonatomic, strong) RCTBridge *sharedBridge;
@end

@implementation RCCManager

+ (instancetype)sharedIntance
{
  static RCCManager *sharedIntance = nil;
  static dispatch_once_t onceToken = 0;

  dispatch_once(&onceToken,^{
    if (sharedIntance == nil)
    {
      sharedIntance = [[RCCManager alloc] init];
    }
  });

  return sharedIntance;
}

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    self.modulesRegistry = [@{} mutableCopy];
  }
  return self;
}

-(void)registerController:(UIViewController*)controller componentId:(NSString*)componentId componentType:(NSString*)componentType
{
  if (controller == nil || componentId == nil)
  {
    return;
  }

  NSMutableDictionary *componentsDic = self.modulesRegistry[componentType];
  if (componentsDic == nil)
  {
    componentsDic = [@{} mutableCopy];
    self.modulesRegistry[componentType] = componentsDic;
  }

  componentsDic[componentId] = controller;
}

-(id)getControllerWithId:(NSString*)componentId componentType:(NSString*)componentType
{
  if (componentId == nil)
  {
    return nil;
  }

  id component = nil;

  NSMutableDictionary *componentsDic = self.modulesRegistry[componentType];
  if (componentsDic != nil)
  {
    component = componentsDic[componentId];
  }

  return component;
}


-(void)initBridgeWithBundleURL:(NSURL *)bundleURL
{
  if (self.sharedBridge) return;
  RCTBridge *bridge = [[RCTBridge alloc] initWithBundleURL:bundleURL
                                            moduleProvider:nil
                                             launchOptions:nil];
  self.sharedBridge = bridge;
}

-(RCTBridge*)getBridge
{
  return self.sharedBridge;
}

@end
