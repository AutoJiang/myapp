//
//  ATTableViewCell.h
//  学渣思政
//
//  Created by jiang aoteng on 16/3/14.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *imageview;

@property (nonatomic, strong)UILabel *lable;

@property (nonatomic, strong)UIView *line;

-(void)addButtonLine;

@end
