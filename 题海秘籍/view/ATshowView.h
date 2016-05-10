//
//  ATshowView.h
//  学渣思政
//
//  Created by jiang aoteng on 16/5/10.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "data.h"

@interface ATshowView : UIScrollView

@property (weak, nonatomic) UITextView *topicTextField;

@property (weak, nonatomic) UIFont *font;

-(void)reloadData:(data*)data;

-(ATshowView*)initWithFrame:(CGRect)frame withFont:(UIFont*)font data:(data*)data;
@end
