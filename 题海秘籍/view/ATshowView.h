//
//  ATshowView.h
//  学渣思政
//
//  Created by jiang aoteng on 16/5/10.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "data.h"
typedef NS_ENUM(NSInteger,showType){
    showTypeSingle,
    showTypeDouble
};

@interface ATshowView : UIScrollView

@property (weak, nonatomic) UITextView *topicTextField;

@property (weak, nonatomic) UIFont *font;

@property (nonatomic, assign)showType showType;

@property (nonatomic, copy) void(^addWrong)(void);

@property (nonatomic, copy) void(^deleteRight)(void);


-(void)reloadData:(data*)data;

-(ATshowView*)initWithFrame:(CGRect)frame withFont:(UIFont*)font data:(data*)data;

@end
