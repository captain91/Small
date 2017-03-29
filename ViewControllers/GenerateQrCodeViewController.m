//
//  GenerateQrCodeViewController.m
//  SmallFeature
//
//  Created by Sun on 16/2/15.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "GenerateQrCodeViewController.h"

#import "LBXScanWrapper.h"

#define TEXTVIEW_H  80
@interface GenerateQrCodeViewController ()

@end

@implementation GenerateQrCodeViewController{

    UIImageView  *qrImageView;
    
    UITextView *textViewStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"生成二维码";
    
    [self createTextField];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - createTextfiled
- (void)createTextField{
    
    textViewStr = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, VIEW_WIDTH - 20, TEXTVIEW_H)];
    
    textViewStr.layer.borderWidth = 1;
    
    textViewStr.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    textViewStr.font = [UIFont systemFontOfSize:17];
    
    textViewStr.layer.masksToBounds = YES;
    
    textViewStr.layer.cornerRadius = 5;
    
    [textViewStr becomeFirstResponder];
    
    [self.view addSubview:textViewStr];
    
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"生成二维码",@"清除内容", nil];
    for (int i = 0; i < titleArray.count; i++) {
    
        UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20 + ((VIEW_WIDTH - 60)/2 + 20) * i, TEXTVIEW_H + 20, (VIEW_WIDTH - 60)/2, 30)];
    
        [submitBtn setTitle:titleArray[i] forState:UIControlStateNormal];
    
        [submitBtn setTitleColor:[UIColor colorWithRed:60.0/255 green:130.0/255 blue:255.0/255 alpha:1] forState:UIControlStateNormal];
    
        [submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    
        submitBtn.layer.borderWidth = 0.5;
    
        submitBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
        submitBtn.layer.masksToBounds = YES;
    
        submitBtn.layer.cornerRadius = 5;
        
        submitBtn.tag = i + 100;
    
        [self.view addSubview:submitBtn];
    }
    
    
    qrImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, TEXTVIEW_H + 70, VIEW_WIDTH - 20, VIEW_WIDTH - 20)];
    
    qrImageView.userInteractionEnabled = YES;
    
    qrImageView.layer.shadowOffset = CGSizeMake(0, 2);
    
    qrImageView.layer.shadowRadius = 2;
    
    qrImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    qrImageView.layer.shadowOpacity = 0.5;
    
    [self.view addSubview:qrImageView];
    
    //添加长按手势
    UILongPressGestureRecognizer *pan = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveThePhoto:)];
    
    pan.minimumPressDuration = 0.5;
    
    [qrImageView addGestureRecognizer:pan];
}
//保存二维码
- (void)saveThePhoto:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        if(!qrImageView.image){
            
            return;
        }
        
        UIActionSheet *altSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到本地",nil];
        
        [altSheet showInView:self.view];
    }
    
}

#pragma mark - 代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    NSLog(@"%ld",(long)buttonIndex);
    //0是保存到本地，1取消
    
    if(buttonIndex == 0){
        //保存到系统相册
        UIImageWriteToSavedPhotosAlbum(qrImageView.image, self, @selector(image: didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alt show];
    }else{
    
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alt show];
    }
}
//生成事件
- (void)submitBtn:(UIButton *)button{
    
    [textViewStr resignFirstResponder];
    
    if (button.tag == 100) {
        
        if (textViewStr.text.length <= 0) {
            
            return;
        }
    }
    
    if (button.tag == 101) {
        textViewStr.text = @"";
        
        [textViewStr becomeFirstResponder];
        
        return;
    }
    
    UIImage *qrImg = [LBXScanWrapper createQRWithString:textViewStr.text size:qrImageView.bounds.size];
    
    qrImageView.image = qrImg;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (textViewStr.isFirstResponder) {
        [textViewStr resignFirstResponder];
    }
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
 
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
@end
