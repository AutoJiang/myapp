//
//  user.h
//  学渣思政
//
//  Created by jiang aoteng on 16/5/1.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface user : NSObject

@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *password;
@property (nonatomic, copy)NSString *image;
@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSString *brief;

@property (nonatomic, assign)int sx_sum;
/**
 sx_times表示章节练习次数
 */
@property (nonatomic, assign)int sx_times;
/**
 sx_timex表示模拟考试次数
 */
@property (nonatomic, assign)int sx_timex;
@property (nonatomic, assign)int sx_error;
@property (nonatomic, assign)int sx_max;
@property (nonatomic, assign)int sx_min;

@property (nonatomic, assign)int mks_sum;
@property (nonatomic, assign)int mks_times;
@property (nonatomic, assign)int mks_timex;
@property (nonatomic, assign)int mks_error;
@property (nonatomic, assign)int mks_max;
@property (nonatomic, assign)int mks_min;

@property (nonatomic, assign)int jds_sum;
@property (nonatomic, assign)int jds_times;
@property (nonatomic, assign)int jds_timex;
@property (nonatomic, assign)int jds_error;
@property (nonatomic, assign)int jds_max;
@property (nonatomic, assign)int jds_min;

@property (nonatomic, assign)int mg_sum;
@property (nonatomic, assign)int mg_times;
@property (nonatomic, assign)int mg_timex;
@property (nonatomic, assign)int mg_error;
@property (nonatomic, assign)int mg_max;
@property (nonatomic, assign)int mg_min;

@property (nonatomic, assign)int mg2_sum;
@property (nonatomic, assign)int mg2_times;
@property (nonatomic, assign)int mg2_timex;
@property (nonatomic, assign)int mg2_error;
@property (nonatomic, assign)int mg2_max;
@property (nonatomic, assign)int mg2_min;

@end
