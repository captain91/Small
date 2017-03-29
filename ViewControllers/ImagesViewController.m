//
//  ImagesViewController.m
//  SmallFeature
//
//  Created by Sun on 16/1/27.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "ImagesViewController.h"

#import "Example1TableViewCell.h"

#import "ZLPhoto.h"

#import <LocalAuthentication/LocalAuthentication.h>

@interface ImagesViewController () <UITableViewDataSource,UITableViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerViewControllerDelegate>

@property (weak,nonatomic) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *assets;

@property (nonatomic , strong) NSMutableArray *sndoxImages;

@property (nonatomic , strong) NSMutableArray *imageNameArray;

@end

@implementation ImagesViewController{
    
    UIView *bgview;
    
    UIView *progressView;
    
    UILabel *progressText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",NSHomeDirectory());
    
    [self showView];
    
    [self touchIdCheck];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -coutomNavigationItem
- (void)customNavigationItem{
    
    self.navigationItem.title = @"机密图片";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择照片" style:UIBarButtonItemStyleDone target:self action:@selector(selectPhotos)];
}
#pragma mark - 添加指纹验证
//验证不成功显示
- (void)showView{
    
    bgview = [[UIView alloc]initWithFrame:self.view.bounds];
    
    bgview.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bgview];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 120, VIEW_WIDTH - 100, 30)];
    
    [button setTitle:@"点击进行指纹解锁" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor colorWithRed:60.0/255 green:130.0/255 blue:255.0/255 alpha:1] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(touchIdCheck) forControlEvents:UIControlEventTouchUpInside];
    
    [bgview addSubview:button];
}

#pragma mark - touchID
- (void)touchIdCheck{
    
    //初始化上下文对象
    LAContext *context = [[LAContext alloc]init];
    
    NSError *error = nil;
    
    NSString *result = @"通过home键验证已有手机指纹";
    
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                
                //验证成功
                NSLog(@"验证成功");
                
                //必须加入主线程操作，不然太慢
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [bgview removeFromSuperview];
                    
                    [self customNavigationItem];
                    //创建文件夹
                    [self initData];
                    
                    //创建tableview
                    [self tableView];
                    
                    //读取本地图片
                    [self showImages];

                }];
                
            }else{
                
                NSLog(@"%@",error.localizedDescription);
                
                switch (error.code) {
                    case LAErrorAppCancel:
                        
                        NSLog(@"切换到其他app，系统取消验证");
                        break;
                    case LAErrorUserCancel:
                        
                        NSLog(@"用户取消Touch ID验证");
                        break;
                    case LAErrorUserFallback:
                        
                        NSLog(@"Touch ID 没验证过提示用户选择输入密码，切换到主线程处理");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //需要处理
                            NSLog(@"输入密码");
                        }];
                        break;
                    case LAErrorTouchIDLockout:
                        NSLog(@"要输入开机解锁密码,系统会自动弹出");
                        break;
                        
                    default:
                        NSLog(@"三次没有验证成功,自动消失，再三次没有成功，进入验证解锁密码");
                        NSLog(@"其他情况可以直接消失不管，可以不作处理");
                        break;
                }
            }
        }];
        
    }else{
        
        NSLog(@"不支持指纹识别");
        UIAlertView *alt =[[UIAlertView alloc]initWithTitle:@"提示" message:@"不支持指纹识别,进行其他验证操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alt show];
        
    }
    
}

#pragma mark - 简单菊花 添加失败
- (void)createProgress{
    
    progressView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    progressView.backgroundColor = [UIColor colorWithRed:250.0/255 green:250.0/255 blue:250.0/255 alpha:0.5];
    
    progressView.alpha = 0;
    
    [self.view addSubview:progressView];
    
    progressText = [[UILabel alloc]initWithFrame:CGRectMake(50, VIEW_HEIGHT/3, VIEW_WIDTH - 100, 30)];
    
    progressText.textAlignment = 1;
    
    progressText.textColor = [UIColor blueColor];
    progressText.text = @"图片导入中，请稍后...";
    
    [progressView addSubview:progressText];
}
#pragma mark - 创建沙河下图片文件夹
- (void)initData{
    
    //指定新建文件夹路径
    NSString *imageDocPath = [self getImageSavePath];
    
    //创建imageFile文件夹
    [[NSFileManager defaultManager]createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    self.sndoxImages = [[NSMutableArray alloc]init];
    
    self.assets = [[NSMutableArray alloc]init];
    
    self.imageNameArray = [[NSMutableArray alloc]init];
}

//获取存放的图片路径
- (NSString *)getImageSavePath{
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *doucmentPath = [path objectAtIndex:0];
    
    //指定新建文件夹路径
    NSString *imageDocPath = [doucmentPath stringByAppendingPathComponent:@"PhotoFile"];
    
    return imageDocPath;
}

#pragma mark -TableView
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
        
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [tableView registerNib:[UINib nibWithNibName:@"Example1TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        NSString *vfl = @"V:|-0-[tableView]-20-|";
        NSDictionary *views = NSDictionaryOfVariableBindings(tableView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:views]];
        NSString *vfl2 = @"H:|-0-[tableView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:nil views:views]];
    }
    return _tableView;
}

#pragma mark - select Photo Library
- (void)selectPhotos {
    // 创建控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.selectPickers = self.assets;
    // 最多能选9张图片
    pickerVc.maxCount = 9;
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self];
    /**
     *
     传值可以用代理，或者用block来接收，以下是block的传值
     __weak typeof(self) weakSelf = self;
     pickerVc.callBack = ^(NSArray *assets){
     weakSelf.assets = assets;
     [weakSelf.tableView reloadData];
     };
     */
}
//选择完成之后调用方法
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    
    self.assets = [NSMutableArray arrayWithArray:assets];
    
    //保存到本地
    [self saveTheImages:assets];
    
    [self showImages];
}
#pragma mark - 读取图片文件
- (void)showImages{
    //移除，每次重新读取
    [self.sndoxImages removeAllObjects];
    
    [self.imageNameArray removeAllObjects];
    
    [self.assets removeAllObjects];
    
    
    //获得图片的目录文件
    NSString *photoFile = [self getImageSavePath];
    
    //深度遍历文件夹中的文件
    NSArray *fileNames = [[NSFileManager defaultManager] subpathsAtPath:photoFile];
    
    NSLog(@"%@",fileNames);
    
    for (int i = 0; i < fileNames.count; i++) {
        
        NSArray *photoN =[fileNames[i] componentsSeparatedByString:@"."];
        
        if ([photoN[0] length]>1) {
            
            UIImage *imagShow = [UIImage imageWithContentsOfFile:[photoFile stringByAppendingString:[NSString stringWithFormat:@"/%@",fileNames[i]]]];
        
            [self.sndoxImages addObject:imagShow];
            
            [self.imageNameArray addObject:fileNames[i]];
        }
    }
    
    if (self.sndoxImages.count > 0) {
        self.assets = self.sndoxImages;
    }
    //刷新tableview
    [self.tableView reloadData];
    
    //计算文件大小
    
    float sizeOfFile = [self folderSizeAtPath:photoFile];
    
    NSLog(@"文件总大小为:%fM",sizeOfFile);
    
}
#pragma mark - 存储图片
- (void)saveTheImages:(NSArray *)imageArray{

    ZLPhotoAssets *asset = [[ZLPhotoAssets alloc]init];
    
    for (int i = 0; i < imageArray.count; i++) {
        
        asset = imageArray[i];
        
        //存储图片
        [self saveImageData:asset.originImage imageName:asset.imageName];
        
        NSLog(@"写入第%d张",i );
    }
}

- (void)saveImageData:(UIImage *)image imageName:(NSString *)imageName{

    NSString *imagePath = [self getImageSavePath];
    
    NSData *data = nil;
    //判断图片是不是png格式
    if (UIImagePNGRepresentation(image)) {
        //返回为png图片
        data = UIImagePNGRepresentation(image);
    }else{
        //返回为jpg
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    
    //保存
    NSString *imageNamePath = [NSString stringWithFormat:@"/%@",imageName];
    
    [[NSFileManager defaultManager]createFileAtPath:[imagePath stringByAppendingString:imageNamePath] contents:data attributes:nil];
}

#pragma mark - 删除图片

- (void)removeImageWithImageName:(NSString *)imageName{
    
    NSString *imagePath = [self getImageSavePath];
    
    NSString *itemImage =[imagePath stringByAppendingString:[NSString stringWithFormat:@"/%@",imageName]];
    
    [[NSFileManager defaultManager]removeItemAtPath:itemImage error:nil];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sndoxImages.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    Example1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.imageview1.image = self.sndoxImages[indexPath.row];
    
    return cell;
    
}


#pragma mark - <UITableViewDelegate>
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Example1TableViewCell *cell = (Example1TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [self setupPhotoBrowser:cell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

#pragma mark - setupCell click ZLPhotoPickerBrowserViewController
- (void) setupPhotoBrowser:(Example1TableViewCell *) cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 是否可以删除照片
    pickerBrowser.editing = YES;
    // 当前选中的值
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (long)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (long)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.assets.count;
}

#pragma mark - 每个组展示什么图片,需要包装下ZLPhotoPickerBrowserPhoto
- (ZLPhotoPickerBrowserPhoto *) photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoAssets *imageObj = [self.assets objectAtIndex:indexPath.row];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    Example1TableViewCell *cell = (Example1TableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    photo.toView = cell.imageview1;
    photo.thumbImage = cell.imageview1.image;
    return photo;
}


#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>
#pragma mark 删除照片调用

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > [self.assets count]) return;
    
    NSString *imageName = self.imageNameArray[indexPath.row];
    
    NSLog(@"删除的filename：%@",imageName );
    
    [self removeImageWithImageName:imageName];
    
    [self.assets removeObjectAtIndex:indexPath.row];
    
    [self.imageNameArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView reloadData];
}

#pragma mark -计算文件大小
//通常用于删除缓存的时，计算缓存大小
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
@end
