//
//  HealthKitViewController.m
//  SmallFeature
//
//  Created by Sun on 2017/2/28.
//  Copyright © 2017年 ssb. All rights reserved.
//

#import "HealthKitViewController.h"
#import <HealthKit/HealthKit.h>
@interface HealthKitViewController ()

@end

@implementation HealthKitViewController {
    HKHealthStore *healthStore;
    UILabel *stepLabel;
    void (^_cycleReferenceBlock)(void);
    
    UIView *_loadingV;
    UIActivityIndicatorView *_indicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"计步器";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self blockTest];

    //调用block
    if (self.titleBlock) {        
        self.titleBlock(@"我是Health");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 84, VIEW_WIDTH - 20, 30)];
    stepLabel.textAlignment = 1;
    stepLabel.textColor = [UIColor blueColor];
    [self.view addSubview:stepLabel];
    
    UIButton *countStep = [[UIButton alloc]initWithFrame:CGRectMake(50, 120, 100, 30)];
    [countStep setTitle:@"统计步数" forState:UIControlStateNormal];
    [countStep setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [countStep addTarget:self action:@selector(getData) forControlEvents:UIControlEventTouchUpInside];
    countStep.layer.cornerRadius = 5;
    countStep.layer.borderColor = [UIColor lightGrayColor].CGColor;
    countStep.layer.borderWidth = 0.5;
    [self.view addSubview:countStep];
    
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(200, 120, 100, 30)];
    [downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downSomething) forControlEvents:UIControlEventTouchUpInside];
    downBtn.layer.cornerRadius = 5;
    downBtn.layer.borderWidth = 0.5;
    downBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:downBtn];
    
    _loadingV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _loadingV.center = self.view.center;
    _loadingV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _loadingV.clipsToBounds = YES;
    _loadingV.hidden = YES;
    _loadingV.layer.cornerRadius = 10;
    [self.view addSubview:_loadingV];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.frame = CGRectMake(0, 0, 40, 40);
    _indicator.center = CGPointMake(_loadingV.frame.size.width/2, _loadingV.frame.size.height/2);
    [_loadingV addSubview:_indicator];
}

-(void)blockTest {
    _cycleReferenceBlock = ^ {
        NSLog(@"这就是block");
    };
    _cycleReferenceBlock();
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"后台执行");
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"主线程执行");
    });
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"创建一次");
    });
    //延时2s
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        NSLog(@"延时2秒后执行");
    });
}

-(void)getData {
    if (self.titleBlock) {
        self.titleBlock(@"计步器");
    }

    if (![HKHealthStore isHealthDataAvailable]) {
        NSLog(@"设备不支持");
        return;
    }
    
    healthStore = [[HKHealthStore alloc]init];
    
    //设置需要获取的权限，这里设置了步数
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSSet *healthSet = [NSSet setWithObjects:stepCount, nil];
    
    //从健康应用中获取权限
    [healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"获取步数权限成功");
            //调用方法
            [self readStepCount];
        }else{
            NSLog(@"获取步数权限失败");
        }
    }];
}

//查询数据
- (void)readStepCount {
    //查询采样信息
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //NSSortDescriptors用来告诉healthStore怎样将结果排序
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    /*查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标，这里我们需要查询的步数是一个
     HKSample类所以对应的查询类就是HKSampleQuery。
     下面的limit参数传1表示查询最近一条数据,查询多条数据只要设置limit的参数值就可以了
     */
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc]initWithSampleType:sampleType predicate:[self predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (!error && results) {
//            NSLog(@"resultcount = %ld  result = %@",results.count,results);
            //计算当天的步数
            NSInteger totleSteps = 0;
            for (HKQuantitySample *quantitSample in results) {
                HKQuantity *tity = quantitSample.quantity;
                HKUnit *heightUnit = [HKUnit countUnit];
                double userHeight = [tity doubleValueForUnit:heightUnit];
                totleSteps += userHeight;
            }
            //刷新UI回到主线程
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                stepLabel.text = [NSString stringWithFormat:@"最新数据:%ld",(long)totleSteps];
            }];
        }
    }];
    
    //执行查询
    [healthStore executeQuery:sampleQuery];
}

//获取当天的时间段
- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

#pragma mark - downSomething
-(void)downSomething {
    if (_indicator.isHidden == YES) {
        [_indicator startAnimating];
        _indicator.hidden = NO;
        _loadingV.hidden = NO;
    }else{
        [_indicator stopAnimating];
        _indicator.hidden = YES;
        _loadingV.hidden = YES;
    }
    
    //延时2s
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        NSLog(@"延时5秒后执行");
        [_indicator stopAnimating];
        _indicator.hidden = YES;
        _loadingV.hidden = YES;
    });
}
@end
