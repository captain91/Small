//
//  AddPicAndTextViewController.m
//  SmallFeature
//
//  Created by Sun on 16/9/20.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "AddPicAndTextViewController.h"
//第三方添加图文
#import "KKGrowUpInputView.h"
#import "KKPhotoPickerManager.h"
#import "AppDelegate.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SVProgressHUD.h"

#import "SPhotosView.h"

@interface AddPicAndTextViewController ()<KKInputViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) KKGrowUpInputView *inputView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UILabel *textLabel;
@property(nonatomic,strong) UILabel *progressLabel;

@property(nonatomic,strong) SPhotosView *sphotosView;
@end

@implementation AddPicAndTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加图文";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self addViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - addViews
-(void)addViews{
    [self.view addSubview:self.sphotosView];
    [self.view addSubview:self.inputView];
//    [self.scrollView addSubview:self.textLabel];
//    [self.view addSubview:self.progressLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputHChange:) name:@"textInputFrameChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputHChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputHChange:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 发送文字
//发送键按下
-(void)returnBtnClickedWithText:(NSString *)text{

    NSLog(@"text: %@",text);
    self.textLabel.text = text;
    [self.inputView.textView resignFirstResponder];
}
-(void)tapAtScrollView{
    if (self.inputView.isEditing) {//有键盘隐藏键盘
        [self.inputView.textView resignFirstResponder];
    }else{
        //没有键盘发图模式改变inputView的高度
        [self.scrollView setContentOffset:CGPointMake(0, self.inputView.inputH - 49) animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.inputView.frame = CGRectMake(0, self.view.frame.size.height - self.inputView.inputH, self.view.frame.size.width, self.inputView.inputH);
        } completion:^(BOOL finished) {
            self.inputView.picBtn.hidden = YES;
            self.inputView.photoBtn.hidden = YES;
        }];
    }
}
//键盘变动,更新frame
- (void)inputHChange:(NSNotification *)noti {
    if ([noti.name isEqualToString:@"UIKeyboardWillShowNotification"]) {
        [self.scrollView setContentOffset:CGPointMake(0, self.inputView.inputH+self.inputView.keyboardHeight-49) animated:NO];
    }else if ([noti.name isEqualToString:@"UIKeyboardWillHideNotification"]){
        if(!self.inputView.isClickPlus){
            [self.scrollView setContentOffset:CGPointMake(0, self.inputView.inputH-49) animated:NO];
        }
        self.inputView.isClickPlus = NO;
    }else if ([noti.name isEqualToString:@"textInputFrameChange"]){
        CGFloat offset = [[noti.userInfo valueForKey:@"offset"] floatValue];
        [self.scrollView setContentOffset:CGPointMake(0, offset-49) animated:YES];
    }
}

#pragma mark - 照片
//图库
- (void)ChooseFromAlbum {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).maxPicNum = 9 ;
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).selectedPicNum = 0;
    [[KKPhotoPickerManager shareInstace] getImagesfromController:self completionBlock:^(NSMutableArray *imageArray) {
        //NSLog(@"Array %@",imageArray);
        //获得选择的图片
        for (int i = 0;i<imageArray.count; i++) {
            //发送图片
            UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10 + i%3 * 80, 30 + i/3*80, 70, 70)];
            imageView1.image = imageArray[i];
            [self.scrollView addSubview:imageView1];
        }
        //上传图片到服务器
//        [self uploadImageToServerWithImageArray:imageArray];
        
        [self showImageWithArray:imageArray];
        
    }];
}
//拍照
- (void)openCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //发送图片方法
//    _backImgView.image = image;
    
//    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 70, 70)];
//    imageView1.image = image;
//    [self.scrollView addSubview:imageView1];
    
    //上传图片到服务器
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    [imageArray addObject:image];
    
//    [self uploadImageToServerWithImageArray:imageArray];
    
    [self showImageWithArray:imageArray];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - showImage
-(void)showImageWithArray:(NSArray *)photos{

    self.sphotosView.photos = photos;
    self.sphotosView.frame = CGRectMake(10, 70, VIEW_WIDTH - 20, [SPhotosView sizeWithPhotosCount:(int)photos.count]);
    
}

#define COOKIE @"Cookie"
#pragma mark - 上传图片到服务器
- (void)uploadImageToServerWithImageArray:(NSArray *)imageArray{
    
    //分析师
    NSString *cookie = @"topmasteruserName=18837102961;topmasteruserCode=cfe67ed2b7d698b6c84ba441ee8fcda9";
    //普通用户
//    NSString *cookie = @"topmasteruserName=13712341234;topmasteruserCode=95938f55824e5437201c9e876771bd3d";

    
    //上传之前要压缩图片
    NSArray *newImageArray = [self countImageWithImageArray:imageArray];
    
    NSString *uploadUrl = @"http://192.168.6.82/api/file?a=uploadFiles";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer setValue:cookie forHTTPHeaderField:COOKIE];
    AFHTTPRequestOperation * operation = [manager POST:uploadUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSLog(@"addImages");
        NSString * imageName = @"";
        for (int i = 0; i < newImageArray.count; i++) {
            NSData *imageData;
            NSString *mineType;
            if (UIImagePNGRepresentation(newImageArray[i])==nil) {
                imageData = UIImageJPEGRepresentation(newImageArray[i], 1);
                mineType = @"image/jpg";
                imageName = [NSString stringWithFormat:@"%@.jpg",imageName];
            }else{
                imageData = UIImagePNGRepresentation(newImageArray[i]);
                mineType = @"image/png";
                imageName = [NSString stringWithFormat:@"%@.png",imageName];
            }
            
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"img%d",i] fileName:imageName mimeType:mineType];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"seccess %@",responseObject[@"message"]);
        self.progressLabel.alpha = 0;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"fail %@",error);
        self.progressLabel.alpha = 0;
        
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {        
//        NSLog(@"百分比:%f",totalBytesWritten*1.0/totalBytesExpectedToWrite * 100);
        if (totalBytesWritten*1.0/totalBytesExpectedToWrite == 1.0) {
            self.progressLabel.alpha = 0;
        }else{
            self.progressLabel.alpha = 1;
            NSString * progressText = [NSString stringWithFormat:@"上传中百分比:%.f",totalBytesWritten*1.0/totalBytesExpectedToWrite*100];
            self.progressLabel.text = progressText;
            [SVProgressHUD showErrorWithStatus:progressText];
        }
    }];
    
}
//压缩图片
-(NSArray *)countImageWithImageArray:(NSArray *)imageArray{

    UIImage *tempImage;
    CGSize imageSize;
    UIImage * newImage;
    NSMutableArray *newImageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i< imageArray.count; i++) {
        tempImage = imageArray[i];
        imageSize.height = tempImage.size.height/5;
        imageSize.width = tempImage.size.width/5;
        tempImage = [self imageWithImage:tempImage scaledToSize:imageSize];
        NSData * imageData = UIImageJPEGRepresentation(tempImage, 1);
        newImage = [UIImage imageWithData:imageData];
        [newImageArray addObject:newImage];
    }
    return newImageArray;
}

//对图片尺寸进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark - 懒加载
- (KKGrowUpInputView *)inputView {
    if (_inputView == nil) {
        _inputView = [[KKGrowUpInputView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
        _inputView.isNeedVoiceButton = NO;
        //        _inputView.isNeedAddButton = NO;
        [_inputView setUI:self];//你需要的设置请在这个方法前设置
        _inputView.inputDelegate = self;
        [_inputView.picBtn addTarget:self action:@selector(ChooseFromAlbum) forControlEvents:UIControlEventTouchUpInside];
        [_inputView.photoBtn addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputView;
}
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)];
        _scrollView.contentSize =CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-48);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAtScrollView)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.scrollView.frame.size.height - 100, self.view.frame.size.width -40, 100)];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor redColor];
    }
    return _textLabel;
}

- (UILabel *)progressLabel {
    if (_progressLabel == nil) {
        _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, 20)];
        _progressLabel.textColor = [UIColor redColor];
        _progressLabel.textAlignment = 1;
    }
    return _progressLabel;
}

- (SPhotosView *)sphotosView {
    if (_sphotosView == nil) {
        _sphotosView = [[SPhotosView alloc]init];
        _sphotosView.deletePhotoDelegate = self;
    }
    return _sphotosView;
}


//代理方法
- (void)deletePhotoWithIndex:(NSInteger)photoIndex{
    NSLog(@"删除数组中的照片");
}
















@end
