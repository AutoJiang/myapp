//
//  ATshowView.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/10.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "ATshowView.h"

@implementation ATshowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(ATshowView*)initWithFrame:(CGRect)frame withFont:(UIFont*)font data:(data*)data{
    self = [super initWithFrame:frame];
    if (self) {
        UITextView *topicTextField = [[UITextView alloc]init];
        
        topicTextField.x = frame.size.width*0.05;
        topicTextField.y = frame.size.height*0.1;
        topicTextField.width =frame.size.width*0.9;
        topicTextField.userInteractionEnabled = NO;
        topicTextField.backgroundColor = [UIColor greenColor];
        [self addSubview:topicTextField];
        _topicTextField = topicTextField;
        _font = font;
        [self reloadData:data];
    }
    return self;
}
-(void)reloadData:(data*)data{
    _topicTextField.text = data.title;
    [self updateHeight];
}
-(void)updateHeight{
    CGSize contentSize = [_topicTextField.text sizeWithFont:_font constrainedToSize:CGSizeMake(_topicTextField.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    _topicTextField.height = contentSize.height+10;
}

@end
