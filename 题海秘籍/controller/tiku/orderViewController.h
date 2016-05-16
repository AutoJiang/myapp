//
//  orderViewController.h
//  学渣思政
//
//  Created by jiang aoteng on 16/5/8.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "ATViewController.h"
#import "data.h"
#import "ATshowView.h"
#import "ATbutton.h"
@class orderViewController;
@protocol orderViewControllerDelegate <NSObject>

-(void)saveWrongTpic:(orderViewController *)workView wrong:(NSMutableArray *)WrongArray;
-(void)deleteRightTpic:(orderViewController *)workView right:(NSMutableArray *)RightArray pos:(NSInteger)pos;
@end

@interface orderViewController : ATViewController

@property (nonatomic ,strong) NSMutableArray *tpArray;
@property (nonatomic ,copy) NSString *record;

@property (nonatomic,assign) NSInteger type;
@property(nonatomic ,copy)NSString *name;
@property (strong, nonatomic) NSMutableArray *datas;

@property (assign, nonatomic) NSInteger index;

@property(nonatomic,weak)id<orderViewControllerDelegate>delegate;

@property (nonatomic ,assign)NSInteger upAllCount;

@property (nonatomic, assign)BOOL isExam;

@property (nonatomic ,weak) ATbutton *rBtn;

@property (weak, nonatomic) ATbutton *wBtn;

@property (nonatomic, copy) void(^resetYes)();

@property (nonatomic, copy) void(^resetNo)();


-(void)setSwipe;

-(NSString *)filePath;

-(void)setBtnEnable;

-(void)setBtnUnable;

-(void)delRight;

-(void)autoChange;

-(void)loadNext;

-(void)saveToFile;

-(void)resetData;

@end

