//
//  RCCModal.m
//  ReactNativeControllers
//
//  Created by Artal Druk on 3/2/16.
//  Copyright © 2016 artal. All rights reserved.
//

#import "RCCLightBox.h"
#import "RCCManager.h"
#import "RCTRootView.h"
#import "RCTRootViewDelegate.h"
#import <objc/runtime.h>

const NSInteger kLightBoxTag = 0x101010;

@interface RCCLightBoxView : UIView
@property (nonatomic, strong) RCTRootView *reactView;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@end

@implementation RCCLightBoxView

-(instancetype)initWithFrame:(CGRect)frame componentId:(NSString*)componentId
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.visualEffectView = [[UIVisualEffectView alloc] init];
        self.visualEffectView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.visualEffectView];
        
        self.reactView = [[RCTRootView alloc] initWithBridge:[[RCCManager sharedIntance] getBridge] moduleName:componentId initialProperties:nil];
        self.reactView.sizeFlexibility = RCTRootViewSizeFlexibilityWidthAndHeight;
        self.reactView.center = self.center;
        [self addSubview:self.reactView];
        
        [self.reactView.contentView.layer addObserver:self forKeyPath:@"frame" options:0 context:nil];
        [self.reactView.contentView.layer addObserver:self forKeyPath:@"bounds" options:0 context:NULL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRNReload) name:RCTReloadNotification object:nil];
    }
    return self;
}

-(void)removeAllObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.reactView.contentView.layer removeObserver:self forKeyPath:@"frame" context:nil];
    [self.reactView.contentView.layer removeObserver:self forKeyPath:@"bounds" context:NULL];
}

-(void)dealloc
{
    [self removeAllObservers];
}

-(void)onRNReload
{
    [self removeAllObservers];
    [self removeFromSuperview];
    self.reactView = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGSize frameSize = CGSizeZero;
    if ([object isKindOfClass:[CALayer class]])
        frameSize = ((CALayer*)object).frame.size;
    if ([object isKindOfClass:[UIView class]])
        frameSize = ((UIView*)object).frame.size;
    
    if (!CGSizeEqualToSize(frameSize, self.reactView.frame.size))
    {
        self.reactView.frame = CGRectMake((self.frame.size.width - frameSize.width) * 0.5, (self.frame.size.height - frameSize.height) * 0.5, frameSize.width, frameSize.height);
    }
}

-(void)showAnimated
{
    [UIView animateWithDuration:0.3 animations:^()
    {
        self.visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }];
    
    self.reactView.transform = CGAffineTransformMakeTranslation(0, 100);
    self.reactView.alpha = 0;
    [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^()
    {
        self.reactView.transform = CGAffineTransformIdentity;
        self.reactView.alpha = 1;
    } completion:nil];
}

-(void)dismissAnimated
{
    [UIView animateWithDuration:0.2 animations:^()
    {
        self.reactView.transform = CGAffineTransformMakeTranslation(0, 80);
        self.reactView.alpha = 0;
    }];
    
    [UIView animateWithDuration:0.25 delay:0.15 options:UIViewAnimationOptionCurveEaseOut animations:^()
     {
         self.visualEffectView.effect = nil;
     } completion:^(BOOL finished)
    {
        [self removeFromSuperview];
    }];
}

@end

@implementation RCCLightBox

+(UIWindow*)getWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = (app.keyWindow != nil) ? app.keyWindow : app.windows[0];
    return window;
}

+(void)showWithComponentId:(NSString*)componentId
{
    UIWindow *window = [RCCLightBox getWindow];
    if ([window viewWithTag:kLightBoxTag] != nil)
    {
        return;
    }
    
    RCCLightBoxView *lightBox = [[RCCLightBoxView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) componentId:componentId];
    lightBox.tag = kLightBoxTag;
    [window addSubview:lightBox];
    [lightBox showAnimated];
}

+(void)dismiss
{
    UIWindow *window = [RCCLightBox getWindow];
    RCCLightBoxView *lightBox = [window viewWithTag:kLightBoxTag];
    if (lightBox != nil)
    {
        [lightBox dismissAnimated];
    }
}

@end
