//
//  ATbutton.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/14.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "ATbutton.h"

#define Height 15
#define Widht  45

@implementation ATbutton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//    self.layer.borderColor = [UIColor grayColor].CGColor;
//    self.layer.borderWidth = 1;
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 3.f;
    
//    self.size = CGSizeMake(60, rect.size.height);
    [self setTintColor:[UIColor grayColor]];
    [self setBackgroundColor:[UIColor redColor]];
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, contentRect.size.height, contentRect.size.height);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.height+10 , 0, contentRect.size.height*2 , contentRect.size.height);
}
@end
