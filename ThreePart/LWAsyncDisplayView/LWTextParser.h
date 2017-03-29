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
//  LWTextParser.h
//  LWAsyncLayerDemo
//
//  Created by 刘微 on 16/3/7.
//  Copyright © 2016年 Wayne Liu. All rights reserved.
//  https://github.com/waynezxcv/LWAsyncDisplayView
//  See LICENSE for this sample’s licensing information
//

#import <Foundation/Foundation.h>
#import "LWTextLayout.h"

@interface LWTextParser : NSObject


/**
 *  解析表情替代为相应的图片
 *  格式：text：@“hello,world~![微笑]”  ----> @"hello，world~！（[UIImage imageNamed：@“[微笑]”]）"
 *
 */
+ (void)parseEmojiWithTextLayout:(LWTextLayout *)textLayout;


/**
 *  解析HTTP(s):// 并添加链接
 *
 */
+ (void)parseHttpURLWithTextLayout:(LWTextLayout *)textLayout
                         linkColor:(UIColor *)linkColor
                    highlightColor:(UIColor *)higlightColor
                    underlineStyle:(NSUnderlineStyle)underlineStyle;

/**
 *  解析 @用户 并添加链接
 *
 */

+ (void)parseAccountWithTextLayout:(LWTextLayout *)textLayout
                         linkColor:(UIColor *)linkColor
                    highlightColor:(UIColor *)higlightColor
                    underlineStyle:(NSUnderlineStyle)underlineStyle;


/**
 *  解析 #主题# 并添加链接
 *
 */
+ (void)parseTopicWithTextLayout:(LWTextLayout *)textLayout
                       linkColor:(UIColor *)linkColor
                  highlightColor:(UIColor *)higlightColor
                  underlineStyle:(NSUnderlineStyle)underlineStyle;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com