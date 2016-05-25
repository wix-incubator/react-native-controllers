
#import "RCCNotification.h"
#import "RCTRootView.h"
#import "RCTHelpers.h"

@interface NotificationView : UIView
@property (nonatomic, strong) RCTRootView *reactView;
@property (nonatomic, strong) UIView *animGapView;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSTimer *autoDismissTimer;
@property (nonatomic)         BOOL yellowBoxRemoved;
@end

@implementation NotificationView

-(id)initWithParams:(NSDictionary*)params
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.params = params;
        self.yellowBoxRemoved = NO;
        
        self.reactView = [[RCTRootView alloc] initWithBridge:[[RCCManager sharedInstance] getBridge] moduleName:params[@"component"] initialProperties:params[@"passProps"]];
        self.reactView.backgroundColor = [UIColor clearColor];
        self.reactView.sizeFlexibility = RCTRootViewSizeFlexibilityWidthAndHeight;
        [self addSubview:self.reactView];
        
        [self.reactView.contentView.layer addObserver:self forKeyPath:@"frame" options:0 context:nil];
        [self.reactView.contentView.layer addObserver:self forKeyPath:@"bounds" options:0 context:NULL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRNReload) name:RCTReloadNotification object:nil];
        
        if ([params[@"dismissWithSwipe"] boolValue])
        {
            UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(performDismiss)];
            swipeGesture.direction = [self swipeDirection];
            [self addGestureRecognizer:swipeGesture];
        }
        
        if (params[@"shadowRadius"] != nil && [params[@"shadowRadius"] floatValue] > 0)
        {
            self.layer.shadowColor = [UIColor blackColor].CGColor;
            self.layer.shadowOffset = CGSizeMake(0, 0);
            self.layer.shadowRadius = [params[@"shadowRadius"] floatValue];
            self.layer.shadowOpacity = 0.6;
        }
        
        self.hidden = YES;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if(!self.yellowBoxRemoved)
    {
        self.yellowBoxRemoved = [RCTHelpers removeYellowBox:self.reactView];
    }
}

-(UISwipeGestureRecognizerDirection)swipeDirection
{
    UISwipeGestureRecognizerDirection direction = UISwipeGestureRecognizerDirectionUp;
    
    NSString *animationType = [self.params valueForKeyPath:@"animation.type"];
    if ([animationType isEqualToString:@"swing"] || [animationType isEqualToString:@"slide-down"])
        direction = UISwipeGestureRecognizerDirectionUp;
    else if ([animationType isEqualToString:@"slide-left"])
        direction = UISwipeGestureRecognizerDirectionRight;
    else if ([animationType isEqualToString:@"slide-right"])
        direction = UISwipeGestureRecognizerDirectionLeft;
    
    return direction;
}

-(void)killAutoDismissTimer
{
    if (self.autoDismissTimer != nil)
    {
        [self.autoDismissTimer invalidate];
        self.autoDismissTimer = nil;
    }
}

-(void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.reactView.contentView.layer removeObserver:self forKeyPath:@"frame" context:nil];
    [self.reactView.contentView.layer removeObserver:self forKeyPath:@"bounds" context:NULL];
}

-(void)cleanup
{
    [self removeObservers];
    [self killAutoDismissTimer];
}

-(void)dealloc
{
    [self cleanup];
}

-(void)onRNReload
{
    [self cleanup];
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
        self.frame = CGRectMake((self.superview.frame.size.width - frameSize.width) / 2.0, 0, frameSize.width, frameSize.height);
        self.reactView.frame = CGRectMake(0, 0, frameSize.width, frameSize.height);
        self.reactView.contentView.frame = CGRectMake(0, 0, frameSize.width, frameSize.height);
        
        if (self.animGapView == nil)
        {
            self.animGapView = [[UIView alloc] initWithFrame:CGRectZero];
            [self addSubview:self.animGapView];
        }
        
        self.animGapView.frame = CGRectMake(0, -20, self.frame.size.width, 20);
        
        if (self.params[@"shadowRadius"] != nil && [self.params[@"shadowRadius"] floatValue] > 0)
        {
            self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        }
    }
}

-(void)performDismiss
{
    [RCCNotification dismissWithParams:self.params resolver:nil rejecter:nil];
}

-(void)startAutoDismissTimerIfNecessary
{
    if (self.params[@"autoDismissTimerSec"])
    {
        [self killAutoDismissTimer];
        
        CGFloat interval = [self.params[@"autoDismissTimerSec"] floatValue];
        interval = MAX(interval, 1);
        self.autoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(performDismiss) userInfo:nil repeats:NO];
    }
}

-(void)applyAnimations
{
    NSString *animationType = [self.params valueForKeyPath:@"animation.type"];
    if ([animationType isEqualToString:@"swing"])
    {
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -0.002f;
        transform.m24 = -0.007f;
        if (self.layer.anchorPoint.x == 0.5 && self.layer.anchorPoint.y == 0.5)
        {
            self.layer.anchorPoint = CGPointMake(0.5, 0);
            self.layer.frame = CGRectOffset(self.layer.frame, 0, -self.layer.frame.size.height / 2.0);
        }
        self.layer.zPosition = 1000;
        self.layer.transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    }
    else
    {
        CGAffineTransform transform = CGAffineTransformIdentity;
        if ([animationType isEqualToString:@"slide-down"])
            transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
        else if ([animationType isEqualToString:@"slide-left"])
            transform = CGAffineTransformMakeTranslation(self.frame.size.width, 0);
        else if ([animationType isEqualToString:@"slide-right"])
            transform = CGAffineTransformMakeTranslation(-self.frame.size.width, 0);
        
        self.transform = transform;
    }
    
    if ( [[self.params valueForKeyPath:@"animation.fade"] boolValue])
    {
        self.alpha = 0;
    }
}

#pragma mark - show/dismiss

-(void)showAnimationEnded:(void (^)(void))completion
{
    self.alpha = 1;
    
    if (completion)
    {
        completion();
    }
    
    [self startAutoDismissTimerIfNecessary];
}

-(void)dismissAnimationEnded:(void (^)(void))completion
{
    if (completion)
    {
        completion();
    }
    
    [self removeFromSuperview];
}

-(void)performShowWithCompletion:(void (^)(void))completion
{
    self.hidden = NO;
    
    if ([[self.params valueForKeyPath:@"animation.animated"] boolValue])
    {
        CGFloat duration = [[self.params valueForKeyPath:@"animation.duration"] floatValue];
        CGFloat delay = [[self.params valueForKeyPath:@"animation.delay"] floatValue];
        CGFloat damping = [[self.params valueForKeyPath:@"animation.damping"] floatValue];
        damping = MAX(damping, 0);
        damping = MIN(damping, 1);
        
        [self applyAnimations];
        
        [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:damping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^()
         {
             self.alpha = 1;
             self.transform = CGAffineTransformIdentity;
             self.layer.transform = CATransform3DIdentity;
         }
                         completion:^(BOOL finished)
         {
             [self showAnimationEnded:completion];
         }];
    }
    else
    {
        [self showAnimationEnded:completion];
    }
}

-(void)showWithCompletion:(void (^)(void))completion
{
    if (self.frame.size.height == 0 || self.frame.size.width == 0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(),
                       ^{
                           [self showWithCompletion:completion];
                       });
    }
    else
    {
        [self performShowWithCompletion:completion];
    }
}

-(void)dismissWithCompletion:(void (^)(void))completion
{
    [self killAutoDismissTimer];
    [self.reactView cancelTouches];
    
    if ([[self.params valueForKeyPath:@"animation.animated"] boolValue])
    {
        CGFloat duration = [[self.params valueForKeyPath:@"animation.duration"] floatValue] * 0.75;
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^()
         {
             [self applyAnimations];
         }
                         completion:^(BOOL finished)
         {
             [self dismissAnimationEnded:completion];
         }];
    }
    else
    {
        [self dismissAnimationEnded:completion];
    }
}

@end

@interface PendingNotification : NSObject
@property (nonatomic, copy) void (^resolve)(id result);
@property (nonatomic, copy) void (^reject)(NSString *code, NSString *message, NSError *error);
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation PendingNotification
@end

@implementation RCCNotification

static NSTimeInterval gLastShownTime = NSTimeIntervalSince1970;
static NSMutableArray *gPendingNotifications = nil;
static NSMutableArray *gShownNotificationViews = nil;

+(void)showWithParams:(NSDictionary*)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject
{
    if(gPendingNotifications == nil)
        gPendingNotifications = [NSMutableArray array];
    
    if(gShownNotificationViews == nil)
        gShownNotificationViews = [NSMutableArray array];
    
    if ([gShownNotificationViews count] > 0)
    {
        for (NotificationView *notificationView in gShownNotificationViews)
        {
            [notificationView killAutoDismissTimer];
        }
        
        //limit the amount of consecutive notifications per second. If they arrive too fast, the last one will be remembered as pending
        if(CFAbsoluteTimeGetCurrent() - gLastShownTime < 1)
        {
            PendingNotification *pendingNotification = [PendingNotification new];
            pendingNotification.params = params;
            pendingNotification.resolve = resolve;
            pendingNotification.reject = reject;
            [gPendingNotifications addObject:pendingNotification];
            return;
        }
    }
    
    gLastShownTime = CFAbsoluteTimeGetCurrent();
    
    UIWindow *window = [[RCCManager sharedInstance] getAppWindow];
    NotificationView *notificationView = [[NotificationView alloc] initWithParams:params];
    [window addSubview:notificationView];
    [gShownNotificationViews addObject:notificationView];
    [notificationView showWithCompletion:^()
     {
         if (resolve)
         {
             resolve(nil);
         }
     }];
}

+(void)dismissWithParams:(NSDictionary*)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject
{
    int count = [gShownNotificationViews count];
    for (int i = count - 1 ; i >= 0; i--)
    {
        NotificationView *notificationView = [gShownNotificationViews objectAtIndex:i];
        [gShownNotificationViews removeObject:notificationView];
        [notificationView dismissWithCompletion:^()
         {
             if (i == (count - 1))
             {
                 if(resolve)
                 {
                     resolve(nil);
                 }
                 
                 if ([gPendingNotifications count] > 0)
                 {
                     PendingNotification *pendingNotification = [gPendingNotifications lastObject];
                     [self showWithParams:pendingNotification.params resolver:pendingNotification.resolve rejecter:pendingNotification.reject];
                     [gPendingNotifications removeLastObject];
                 }
             }
         }];
    }
}

@end
