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
//  LWTextParser.m
//  LWAsyncLayerDemo
//
//  Created by 刘微 on 16/3/7.
//  Copyright © 2016年 Wayne Liu. All rights reserved.
//  https://github.com/waynezxcv/LWAsyncDisplayView
//  See LICENSE for this sample’s licensing information
//

#import "LWTextParser.h"


#define URLRegular @""
#define EmojiRegular @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
#define AccountRegular @"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}"
#define TopicRegular @"#[^#]+#"

static inline NSRegularExpression* EmojiRegularExpression() {
    static NSRegularExpression* _EmojiRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _EmojiRegularExpression = [[NSRegularExpression alloc] initWithPattern:EmojiRegular options:NSRegularExpressionAnchorsMatchLines error:nil];
    });
    return _EmojiRegularExpression;
}


static inline NSRegularExpression* URLRegularExpression() {
    static NSRegularExpression* _URLRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _URLRegularExpression = [[NSRegularExpression alloc] initWithPattern:URLRegular options:NSRegularExpressionAnchorsMatchLines error:nil];
    });
    return _URLRegularExpression;
}

static inline NSRegularExpression* AccountRegularExpression() {
    static NSRegularExpression* _AccountRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _AccountRegularExpression = [[NSRegularExpression alloc] initWithPattern:AccountRegular options:NSRegularExpressionAnchorsMatchLines error:nil];
    });
    return _AccountRegularExpression;
}


static inline NSRegularExpression* TopicRegularExpression() {
    static NSRegularExpression* _TopicRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _TopicRegularExpression = [[NSRegularExpression alloc] initWithPattern:TopicRegular options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return _TopicRegularExpression;
}


@implementation LWTextParser

+ (void)parseEmojiWithTextLayout:(LWTextLayout *)textLayout {
    NSString* text = textLayout.text;
    NSArray* resultArray = [EmojiRegularExpression() matchesInString:text
                                                             options:0
                                                               range:NSMakeRange(0,text.length)];
    for(NSTextCheckingResult* match in resultArray) {
        NSRange range = [match range];
        NSString* content = [text substringWithRange:range];
        
        if (textLayout.text.length >= range.location + range.length) {
            [textLayout replaceTextWithImage:[UIImage imageNamed:content] inRange:range];
        }
    }
}

+ (void)parseHttpURLWithTextLayout:(LWTextLayout *)textLayout
                         linkColor:(UIColor *)linkColor
                    highlightColor:(UIColor *)higlightColor
                    underlineStyle:(NSUnderlineStyle)underlineStyle {
    NSString* text = textLayout.text;
    NSArray* resultArray = [URLRegularExpression() matchesInString:text
                                                           options:0
                                                             range:NSMakeRange(0,text.length)];
    for(NSTextCheckingResult* match in resultArray) {
        NSRange range = [match range];
        NSString* content = [text substringWithRange:range];
        [textLayout addLinkWithData:content
                            inRange:range
                          linkColor:linkColor
                     highLightColor:higlightColor
                     UnderLineStyle:NSUnderlineStyleSingle];
    }
}


+ (void)parseAccountWithTextLayout:(LWTextLayout *)textLayout
                         linkColor:(UIColor *)linkColor
                    highlightColor:(UIColor *)higlightColor
                    underlineStyle:(NSUnderlineStyle)underlineStyle {
    
    NSString* text = textLayout.text;
    NSArray* resultArray = [AccountRegularExpression() matchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0,text.length)];
    for(NSTextCheckingResult* match in resultArray) {
        NSRange range = [match range];
        NSString* content = [text substringWithRange:range];
        [textLayout addLinkWithData:content
                            inRange:range
                          linkColor:linkColor
                     highLightColor:higlightColor
                     UnderLineStyle:underline];
    }
}


+ (void)parseTopicWithTextLayout:(LWTextLayout *)textLayout
                       linkColor:(UIColor *)linkColor
                  highlightColor:(UIColor *)higlightColor
                  underlineStyle:(NSUnderlineStyle)underlineStyle {
    
    NSString* text = textLayout.text;
    NSArray* resultArray = [TopicRegularExpression() matchesInString:text
                                                             options:0
                                                               range:NSMakeRange(0,text.length)];
    for(NSTextCheckingResult* match in resultArray) {
        NSRange range = [match range];
        NSString* content = [text substringWithRange:range];
        [textLayout addLinkWithData:content
                            inRange:range
                          linkColor:linkColor
                     highLightColor:higlightColor
                     UnderLineStyle:underlineStyle];
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com