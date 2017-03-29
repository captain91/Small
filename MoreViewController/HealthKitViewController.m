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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"计步器";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 84, VIEW_WIDTH - 20, 30)];
    stepLabel.textAlignment = 1;
    stepLabel.textColor = [UIColor greenColor];
    [self.view addSubview:stepLabel];
}

-(void)getData {
    if (![HKHealthStore isHealthDataAvailable]) {
        NSLog(@"设备不支持");
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
@end
