//
//  The MIT License (MIT)
//  Copyright (c) 2016 Wayne Liu <liuweiself@126.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//　　The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//
//
//  LWAsyncDisplayLayer.m
//  LWAsyncLayerDemo
//
//  Created by 刘微 on 16/2/2.
//  Copyright © 2016年 Wayne Liu. All rights reserved.
//  https://github.com/waynezxcv/LWAsyncDisplayView
//  See LICENSE for this sample’s licensing information
//

#import "LWAsyncDisplayLayer.h"
#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>
#import "CALayer+LazySetContents.h"


static dispatch_queue_t GetAsyncDisplayQueue() {
#define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static dispatch_once_t onceToken;
    static int32_t counter = 0;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            for (NSUInteger i = 0; i < queueCount; i++) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
                queues[i] = dispatch_queue_create("com.waynezxcv.AsyncDisplay", attr);
            }
        } else {
            for (NSUInteger i = 0; i < queueCount; i++) {
                queues[i] = dispatch_queue_create("com.waynezxcv.AsyncDisplay", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            }
        }
    });
    int32_t cur = OSAtomicIncrement32(&counter);
    if (cur < 0) cur = - cur;
    return queues[(cur) % queueCount];
#undef MAX_QUEUE_COUNT
}

@interface LWAsyncDisplayLayer ()

@property (nonatomic,strong,readwrite) LWFlag* flag;

@end

@implementation LWAsyncDisplayLayer

#pragma mark - Override

- (id)init {
    self = [super init];
    if (self) {
        static CGFloat scale;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            scale = [UIScreen mainScreen].scale;
        });
        self.contentsScale = scale;
        self.flag = [[LWFlag alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self _cancelDisplay];
}

- (void)drawContent {
    [self _asyncDisplay];
}

- (void)cleanUp {
    [self _cancelDisplay];
}

#pragma mark - Private
- (void)_asyncDisplay {
    [self lazySetContent:nil];
    LWFlag* flag = self.flag;
    int32_t value = flag.value;
    BOOL (^isCancelled)() = ^BOOL() {
        return value != flag.value;
    };
    if (isCancelled()) {
        return ;
    }
    CGSize size = self.bounds.size;
    BOOL opaque = self.opaque;
    CGFloat scale = self.contentsScale;
    if (size.width < 1 || size.height < 1) {
        CGImageRef image = (__bridge_retained CGImageRef)(self.contents);
        [self lazySetContent:nil];
        if (image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                CFRelease(image);
            });
        }
        return;
    }
    dispatch_async(GetAsyncDisplayQueue(), ^{
        if (isCancelled()) {
            return ;
        }
        BOOL isWillDisplay = [self.asyncDisplayDelegate willBeginAsyncDisplay:self];
        if (!isWillDisplay) {
            return;
        }
        UIGraphicsBeginImageContextWithOptions(size,opaque, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context == NULL) {
            NSLog(@"context is NULL");
            return;
        }
        if (isCancelled()) {
            UIGraphicsEndImageContext();
            return;
        }
        [self.asyncDisplayDelegate didAsyncDisplay:self context:context size:self.bounds.size];
        UIImage* screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
        CGImageRef content = screenshotImage.CGImage;
        if (isCancelled()) {
            UIGraphicsEndImageContext();
            return;
        }
        UIGraphicsEndImageContext();
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self lazySetContent:(__bridge id)content];
            if ([self.asyncDisplayDelegate respondsToSelector:@selector(didFinishAsyncDisplay:isFiniedsh:)]) {
                [self.asyncDisplayDelegate didFinishAsyncDisplay:self isFiniedsh:YES];
            }
        });
    });
}

- (void)_cancelDisplay {
    [self.flag increase];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com