//
//  ATshowView.m
//  学渣思政
//
//  Created by jiang aoteng on 16/3/20.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "ATshowView.h"


@interface ATshowView ()


@end

@implementation ATshowView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
-(void)initContentViewWithString:(NSString *)content{
    UITextField * filed = [[UITextField alloc]init];
    filed.text = content;

    filed.font = [UIFont systemFontOfSize:13];
    CGFloat w = self.frame.size.width*0.2;
    
    CGRect rect = [filed.text boundingRectWithSize:CGSizeMake(w, MAXFLOAT)  options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:filed.font} context:nil];
    filed.bounds = CGRectMake(0, 0, w, rect.size.height);
    filed.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    NSLog(@"%@",filed);
    filed.backgroundColor = [UIColor brownColor];
    filed.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:filed];
    
    UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_1.frame = CGRectMake(filed.frame.origin.x, filed.frame.origin.y+filed.frame.size.height,self.frame.size.width * 0.25 , self.frame.size.height *0.05);
    [btn_1 setBackgroundColor:[UIColor greenColor]];
    btn_1.titleLabel.text = @"确定";
    [self addSubview:btn_1];
    
    UIButton *btn_2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn_2.frame = CGRectMake(filed.frame.origin.x+filed.frame.size.width*0.5, filed.frame.origin.y+filed.frame.size.height,self.frame.size.width * 0.25 , self.frame.size.height *0.05);
    [btn_2 setBackgroundColor:[UIColor greenColor]];
    btn_2.titleLabel.text = @"取笑";
    btn_2.titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:btn_2];
}

@end
