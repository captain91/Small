//
//  ShareViewController.m
//  SmallFeature
//
//  Created by Sun on 16/8/30.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "ShareViewController.h"

#import "LWActionSheetView.h"

#import "LWAsyncDisplayView.h"

#import "LWTextParser.h"

#define RGB(A,B,C,D) [UIColor colorWithRed:A/255.0f green:B/255.0f blue:C/255.0f alpha:D]

@interface ShareViewController () <LWActionSheetViewDelegate,LWAsyncDisplayViewDelegate>
@property(nonatomic,strong) LWAsyncDisplayView *asyncDisplayView;

@property (nonatomic,strong) LWTextLayout* contentTextLayout;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *actionSheetButton = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH/3,70,VIEW_WIDTH/3, 30)];
    [actionSheetButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [actionSheetButton setTitle:@"actionSheet" forState:UIControlStateNormal];
    [actionSheetButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionSheetButton];
    
    //富文本文件
    NSString *str = @"我是特殊字符串#我是股票（上证指数)#就是这个";
    self.asyncDisplayView = [[LWAsyncDisplayView alloc]initWithFrame:CGRectMake(0, 100, VIEW_WIDTH, 100)];
    self.asyncDisplayView.delegate = self;
    //content
    self.contentTextLayout = [[LWTextLayout alloc] init];
    self.contentTextLayout.text = str ;
    self.contentTextLayout.font = [UIFont systemFontOfSize:15.0f];
    self.contentTextLayout.textColor = RGB(40, 40, 40, 1);
    self.contentTextLayout.boundsRect = CGRectMake(10,0,VIEW_WIDTH,MAXFLOAT);
    self.contentTextLayout.linespace = 2.0f;
    [self.contentTextLayout creatCTFrameRef];
    //解析表情跟主题（[emoji] - > 表情。。#主题# 添加链接）
    [LWTextParser parseTopicWithTextLayout:self.contentTextLayout
//                                 linkColor:RGB(113, 129, 161, 1)
                                 linkColor:[UIColor redColor]
                            highlightColor:nil
                            underlineStyle:NSUnderlineStyleNone];
    NSMutableArray* layouts = [[NSMutableArray alloc] init];
    [layouts addObject:self.contentTextLayout];
    self.asyncDisplayView.layouts = layouts;
    
    [self.view addSubview:self.asyncDisplayView];
    
    // Do any additional setup after loading the view.
}
/**
 *  点击链接回调
 *
 */
- (void)lwAsyncDicsPlayView:(LWAsyncDisplayView *)lwLabel didCilickedLinkWithfData:(id)data {
    NSLog(@"我是数据%@",data);
}
-(void)showActionSheet:(UIButton *)btn{
    LWActionSheetView *lwSheet = [[LWActionSheetView alloc]initTilesArray:@[@"分享",@"保存",@"修改",@"取消"] delegate:self];
    [lwSheet show];
}

-(void)lwActionSheet:(LWActionSheetView *)actionSheet didSelectedButtonWithIndex:(NSInteger)index{
    NSLog(@"点击了第%ld个cell",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [UIApplication sharedApplication].statusBarHidden = NO;
}
@end
