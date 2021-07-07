#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSArray+CrashDefender.h"
#import "NSObject+CrashDefender.h"
#import "NSString+Algorithm.h"
#import "UIView+Debug.h"

FOUNDATION_EXPORT double BPKitVersionNumber;
FOUNDATION_EXPORT const unsigned char BPKitVersionString[];

