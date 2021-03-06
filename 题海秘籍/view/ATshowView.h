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

@property (nonatomic, copy) void(^addWrong)();

@property (nonatomic, copy) void(^deleteRight)();

@property (nonatomic, assign)BOOL isExam;


-(void)reloadData:(data*)data;

-(ATshowView*)initWithFrame:(CGRect)frame withFont:(UIFont*)font data:(data*)data exam:(BOOL)isExam;

@end
