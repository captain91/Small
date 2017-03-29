//
//  KMPlaceholderTextView.m
//  KMMessageBox
//
//  Created by fengxi on 15-1-28.
//  Copyright (c) 2015年 KeithMorning. All rights reserved.
//

#import "KMPlaceholderTextView.h"

@interface KMPlaceholderTextView()
@property (strong,nonatomic) UILabel *placeTextLab;
@property (strong,nonatomic) UIImageView *subLine;
@property (nonatomic,copy) void(^viewSize)(CGSize);
@end
@implementation KMPlaceholderTextView
-(void)awakeFromNib{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextChange:) name:UITextViewTextDidChangeNotification object:nil];
    self.scrollEnabled=NO;
    
}
-(instancetype)initWithFrame:(CGRect)frame PlaceText:(NSString *)placeText PlaceColor:(UIColor *)placeColor{
    self=[super initWithFrame:frame];
    if (self) {
        self.scrollEnabled=NO;
        
        _placeText=placeText;
        _placeColor=placeColor;
        _Textnil=YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextChange:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}

#pragma mark subline draw
-(void)addLineView{
    [_subLine removeFromSuperview];
    _subLine=[UIImageView new];
    //_subLine.image = [UIImage imageNamed:@"subline.png"];
    [_subLine setContentMode:UIViewContentModeScaleToFill];
    [self addSubline:_subLine];
    
}
#pragma mark 在textview中添加下划线,以及传递UItextView高度
-(void)TextViewSizeChange:(void (^)(CGSize))Textviewsize{
    
    //NSLog(@"3");
        self.viewSize=Textviewsize;//self.viewSize=Textviewsize;只是代表   把Textviewsize对象赋值给self.viewSize对象，只做了指针的转换，当self.viewSize(size);//调用  时候，就会去调用Textviewsize的实现
   // NSLog(@"4");
    
}
//改变_subLine的位置
-(void)addSubline:(UIView *)view{
    CGSize size= [self sizeThatFits:CGSizeMake(self.contentSize.width, 1000.0)];
    if (view) {
        CGRect frame=CGRectMake(2, size.height-3, self.bounds.size.width-4, 3.0);
        view.frame=frame;
    }
    [self addSubview:view];
    if (self.viewSize)//判断实现没
    {
         self.viewSize(size);//调用
    }
}
#pragma mark 隐藏或显示placeText
-(void)TextChange:(NSNotification *)notification{
    if (self.text.length==0) {
        _Textnil=YES;
    }else{
        _Textnil=NO;
    }
    [self addLineView];
    
    if (self.placeText.length==0) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        if (_Textnil) {
            [[self viewWithTag:999] setAlpha:1.0];
        }else{
            [[self viewWithTag:999] setAlpha:0];
        }
    }];
    
}

#pragma mark 重写drawRect
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self PlaceTextLabel];
    [self addLineView];
}
#pragma mark 初始化placetext
-(void)PlaceTextLabel{
    if (self.placeText.length>0) {
        if (!_placeTextLab) {
            CGRect frame=CGRectMake(8,8, self.bounds.size.width-16, 0);
            _placeTextLab=[[UILabel alloc]initWithFrame:frame];
            _placeTextLab.font=self.font;
            _placeTextLab.backgroundColor=[UIColor clearColor];
            _placeTextLab.textColor=self.placeColor;
            _placeTextLab.tag=999;
            _placeTextLab.alpha=0;
            _placeTextLab.lineBreakMode=NSLineBreakByWordWrapping;
            _placeTextLab.numberOfLines=0;
            [self addSubview:_placeTextLab];
        }
        
        _placeTextLab.text = self.placeText;
        [_placeTextLab sizeToFit];
        [_placeTextLab setFrame:CGRectMake(8, 8, CGRectGetWidth(self.bounds)-16, CGRectGetHeight(_placeTextLab.frame))];
    }
    if (self.text.length==0 && self.placeText.length>0) {
        [[self viewWithTag:999] setAlpha:1.0];
    }
}
//重写set方法
-(void)setPlaceText:(NSString *)placeText{
    _placeText = placeText;
    _placeTextLab.text = placeText;
    [self TextChange:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
