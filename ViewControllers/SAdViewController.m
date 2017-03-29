//
//  SAdViewController.m
//  SmallFeature
//
//  Created by Sun on 16/1/21.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "SAdViewController.h"

@interface SAdViewController ()<SDCycleScrollViewDelegate>

@end

@implementation SAdViewController{

    UILabel *selectLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"广告轮播";
    
    [self addImages];
    
    [self addLabel];
    
    // Do any additional setup after loading the view.
}
- (void)addImages{
    // 情景一：采用本地图片实现
    NSArray *images = @[[UIImage imageNamed:@"h1.jpg"],
                        [UIImage imageNamed:@"h2.jpg"],
                        [UIImage imageNamed:@"h3.jpg"],
                        [UIImage imageNamed:@"h4.jpg"]
                        ];

    // 情景二：采用网络图片实现
    NSArray *imagesURL = @[
                           [NSURL URLWithString:@"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"],
                           [NSURL URLWithString:@"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg"],
                           [NSURL URLWithString:@"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"],
                           [NSURL URLWithString:@"https://ss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=0c231a5bb34543a9f54ea98c782abeb0/a71ea8d3fd1f41342830c1d1211f95cad1c85e1e.jpg"]
                           ];
    
    // 情景三：图片配文字
    NSArray *titles = @[@"感谢您的支持，如果下载的",
                        @"如果代码在使用过程中出现问题",
                        @"您可以发邮件到gsdios@126.com",
                        @"感谢您的支持"
                        ];
    
    //本地图片，不带标题
//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 20, VIEW_WIDTH, 180) imagesGroup:images];
    
//    cycleScrollView.delegate = self;
    
//    cycleScrollView.autoScrollTimeInterval = 4.0;
    
//    [self.view addSubview:cycleScrollView];
    
    
    
    //网络图片，带标题
    SDCycleScrollView *cycleScrollView2= [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, VIEW_WIDTH, 180) imageURLsGroup:imagesURL];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    
    cycleScrollView2.delegate = self;
    
    cycleScrollView2.titlesGroup = titles;
    
    cycleScrollView2.autoScrollTimeInterval = 10.0;
    
    [self.view addSubview:cycleScrollView2];

}

#pragma mark -label
-(void)addLabel{
    selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH/4, 225, VIEW_WIDTH/2, 30)];
    
    selectLabel.textAlignment = NSTextAlignmentCenter;
    
    selectLabel.text = @"点击了第X张图片";
    
    [self.view addSubview:selectLabel];
}
#pragma mark -代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    NSLog(@"--点击了第%ld",index);
    selectLabel.text = [NSString stringWithFormat:@"点击了第%ld张图片",index + 1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
}

@end
