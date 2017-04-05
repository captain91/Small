//
//  FirstOpenViewController.m
//  SmallFeature
//
//  Created by Sun on 2017/4/5.
//  Copyright © 2017年 ssb. All rights reserved.
//

#import "FirstOpenViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "LYButton.h"
#define ENTERBTN_WIDTH [UIScreen mainScreen].bounds.size.width/3
@interface FirstOpenViewController ()

@end

@implementation FirstOpenViewController{
    MPMoviePlayerController *_player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view.layer addSublayer:[self backgroundLayer]];
    
    [self setupVideoPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 播放动画
-(void)setupVideoPlayer {
    NSString *myFilePath = [[NSBundle mainBundle]pathForResource:@"qidong" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:myFilePath];
    _player = [[MPMoviePlayerController alloc]initWithContentURL:movieURL];
    [self.view addSubview:_player.view];
    _player.shouldAutoplay = YES;
    [_player setControlStyle:MPMovieControlStyleNone];
    _player.repeatMode = MPMovieRepeatModeOne;
    _player.view.frame = self.view.bounds;
    _player.view.alpha = 0;
    [UIView animateWithDuration:2 animations:^{
        _player.view.alpha = 1;
        [_player prepareToPlay];
    }];

    [self setupEnterButton];
}

#pragma mark - 进入应用button
-(void)setupEnterButton {
    //计入按钮
//    UIButton *enterBtn = [[UIButton alloc]init];
//    enterBtn.frame = CGRectMake(ENTERBTN_WIDTH, [UIScreen mainScreen].bounds.size.height- 30 -40, ENTERBTN_WIDTH, 40);
//    enterBtn.layer.borderWidth = 1;
//    enterBtn.layer.cornerRadius = 20;
//    enterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    [enterBtn setTitle:@"进入应用" forState:UIControlStateNormal];
//    enterBtn.alpha = 0;
//    [_player.view addSubview:enterBtn];
//    [enterBtn addTarget:self action:@selector(enterBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [UIView animateWithDuration:4 animations:^{
//        enterBtn.alpha = 1.0;
//    }];
    
    //有特效的登陆按钮
    LYButton *enterBtn = [[LYButton alloc]initWithFrame:CGRectMake(ENTERBTN_WIDTH, [UIScreen mainScreen].bounds.size.height- 30 - 44, ENTERBTN_WIDTH, 44)];
    [_player.view addSubview:enterBtn];
    __block LYButton *button = enterBtn;
    __weak FirstOpenViewController *weakSelf = self;
    enterBtn.translateBlock = ^{
        button.bounds = CGRectMake(0, 0, 44, 44);
        button.layer.cornerRadius = 22;
        if (weakSelf.enterAppBlock) {
            NSLog(@"进入回调");
            weakSelf.enterAppBlock();
        }
    };
}

//-(void)enterBtnAction {
//    NSLog(@"进入应用");
//    if (self.enterAppBlock) {
//        NSLog(@"进入回调");
//        self.enterAppBlock();
//    }
//}

-(CAGradientLayer *)backgroundLayer{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor purpleColor].CGColor,(__bridge id)[UIColor redColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0.65,@1];
    return gradientLayer;
}

#pragma mark - 生命周期函数
-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

@end
