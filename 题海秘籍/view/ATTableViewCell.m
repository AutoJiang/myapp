//
//  ATTableViewCell.m
//  学渣思政
//
//  Created by jiang aoteng on 16/3/14.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "ATTableViewCell.h"
#define interval 5

@interface ATTableViewCell ()

@end

@implementation ATTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    self.separatorInset = UIEdgeInsetsMake(20, 20, 20 , 20);
//    self.imageView.frame = CGRectMake(10, 5, 50, 50);
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

-(UIImageView *)imageview{
    if (_imageview == nil) {
        CGFloat X = self.frame.size.height - interval*2;
        _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, interval, X, X)];
        [self.contentView addSubview:_imageview];
    }
    return _imageview;
}

-(UILabel *)lable{
    if (_lable == nil) {
        _lable = [[UILabel alloc]init];
        CGFloat X = self.imageview.frame.origin.x + self.imageview.frame.size.width + 20;
        CGFloat Y = self.imageview.frame.origin.y;
        CGFloat H = self.imageview.frame.size.height;
        CGFloat W = self.frame.size.width - X - 50;
        _lable.frame = CGRectMake(X, Y, W, H);
        [self.contentView addSubview:_lable];
    }
    return _lable;
}

-(void)addButtonLine{
    self.line = [[UIView alloc]init];
    CGFloat X = self.imageview.frame.origin.x + self.imageview.frame.size.width + 5;
    CGFloat Y = self.frame.size.height;
    CGFloat W = self.frame.size.width - X -20;
    CGFloat H = 1;
    self.line.frame = CGRectMake(X, Y, W, H);
    self.line.backgroundColor = [UIColor grayColor];
    self.line.alpha = 0.3;
    [self addSubview:self.line];
}
-(UIView *)line{
    if (_line == nil) {
        _line =[[UIView alloc]init];
        CGFloat X = self.imageview.frame.origin.x + self.imageview.frame.size.width + 5;
        CGFloat Y = self.frame.size.height;
        CGFloat W = self.frame.size.width - X -20;
        CGFloat H = 1;
        self.line.frame = CGRectMake(X, Y, W, H);
        self.line.backgroundColor = [UIColor grayColor];
        [self addSubview:self.line];
    }
    return _line;
}
@end
