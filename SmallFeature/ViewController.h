//
//  ViewController.h
//  SmallFeature
//
//  Created by Sun on 16/1/21.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

    UIImageView *_zoomImageView;//变焦图片做底层
    
    UIImageView *_circleView;//类似头像的UIImageView
    UILabel *_textLabel;//类似昵称UILabel

}


@end

