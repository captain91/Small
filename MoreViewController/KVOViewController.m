//
//  KVOViewController.m
//  SmallFeature
//
//  Created by Sun on 2017/4/7.
//  Copyright © 2017年 ssb. All rights reserved.
//

#import "KVOViewController.h"
#import "PersonModel.h"
@interface KVOViewController ()

@end

@implementation KVOViewController{
    PersonModel *personModel;
    UILabel *ageLabel;
    UILabel *nameLabel;
    
    NSInteger age;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KVO/KVC";
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUI{
    
    personModel = [[PersonModel alloc]init];
    [personModel setValue:@"六六" forKey:@"name"];
    [personModel setValue:@"518" forKey:@"age"];
    [personModel addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"age change"];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 74, VIEW_WIDTH - 40, 30)];
    nameLabel.text = [NSString stringWithFormat:@"名字: %@",[personModel valueForKey:@"name"]];
    [self.view addSubview:nameLabel];
    
    ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 115, 100, 30)];
    age = [[personModel valueForKey:@"age"] integerValue];
    ageLabel.text = [NSString stringWithFormat:@"%ld",age];
    [self.view addSubview:ageLabel];
    
    UIButton *ageBtn = [[UIButton alloc]initWithFrame:CGRectMake(125, 115, 100, 30)];
    [ageBtn setTitle:@"age++" forState:UIControlStateNormal];
    [ageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ageBtn addTarget:self action:@selector(addAge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ageBtn];
}
-(void)addAge{
    age ++;
    [personModel setValue:[NSString stringWithFormat:@"%ld",age] forKey:@"age"];
}

//实现回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"age"]) {
        ageLabel.text = [NSString stringWithFormat:@"%@",[personModel valueForKey:@"age"]];
    }
}

-(void)dealloc {
    [personModel removeObserver:self forKeyPath:@"age"];
}

@end
