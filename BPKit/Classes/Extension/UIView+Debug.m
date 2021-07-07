//
//  UIView+Debug.m
//  Tenant
//
//  Created by 沙庭宇 on 2021/3/22.
//

#import "UIView+Debug.h"
#import "NSObject+CrashDefender.h"
#import <BPKit/BPKit-Swift.h>

@implementation UIView (Debug)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject bpDefenderSwizzlingInstanceMethod:@selector(initWithFrame:) withMethod:@selector(bpInitWithFrame:) withClass:UIView.class];
    });
}

- (instancetype)bpInitWithFrame:(CGRect)frame {
    [self bpInitWithFrame:frame];
    BOOL isShowBorder = [[NSUserDefaults standardUserDefaults] boolForKey:@"bp_borderDebug"];
    if (isShowBorder) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = UIColor.blueColor.CGColor;
    }
    BOOL isShowLog = [[NSUserDefaults standardUserDefaults] boolForKey:@"bp_logDebug"];
    if (isShowLog) {
        dispatch_after(0.5, dispatch_get_main_queue(), ^{
            [BPEnvLogView show];
        });
    }
    return self;
}


@end
