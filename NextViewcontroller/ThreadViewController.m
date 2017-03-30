//
//  LiveViewController.m
//  SmallFeature
//
//  Created by Sun on 16/7/11.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()

@end

@implementation ThreadViewController{
    UIImageView *_imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Thread";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 界面布局
- (void)layoutUI {
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT - 64)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 500, 220, 25);
    [button setTitle:@"加载桃花" forState:UIControlStateNormal];
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark 将图片显示到界面
- (void)updateImage:(NSData *)imageData {
    UIImage *image = [UIImage imageWithData:imageData];
    _imageView.image = image;
}

#pragma mark 请求图片数据
- (NSData *)requestData {
//    @autoreleasepool {
        NSURL *url = [NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1487557818&di=5f0fdb87606d6dd9744a32058a6c63fd&src=http://ylxf.yn.gov.cn/Uploads/NewsPhoto/2016-03-24/940e7e5e-1430-4235-ad97-902c68fb9c5a.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        return data;
//    }
}

#pragma mark 加载图片
- (void)loadImage {
    NSData *data = [self requestData];
    
    //NSThread
    //主线程刷新UI
//    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];
    
    //NSOperation
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self updateImage:data];
//    }];
    
    //GCD
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [self updateImage:data];
    });
    
    @synchronized (self) {
        
    }
}

#pragma mark 多线程下载图片
- (void)loadImageWithMultiThread {
    //使用类方法
//    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];
    
//    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
//    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
//    [operationQueue addOperation:invocationOperation];
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    queue.maxConcurrentOperationCount = 3;
//    [queue addOperationWithBlock:^{
//        [self loadImage];
//    }];
    
    //GCD
    dispatch_queue_t serialQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        [self loadImage];
    });
}


//动态创建线程
- (void)dynamicCreateThread {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage) object:nil];
    thread.threadPriority = 1;
    [thread start];
}
//静态创建线程
- (void)staticCreateThread {
    [NSThread detachNewThreadWithBlock:^{
        
    }];
}
//隐式创建
- (void)implicitCreateThread {
    [self performSelectorInBackground:@selector(loadImage) withObject:nil];
}
-(void)loadImageSource:(NSString *)url {
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [UIImage imageWithData:imageData];
    if (imageData != nil) {
        [self performSelectorOnMainThread:@selector(refreshImageView:) withObject:image waitUntilDone:YES];
    }else{
        NSLog(@"there no image data");
    }
}
-(void)refreshImageView:(UIImage *)image {
    _imageView.image = image;
}
@end
