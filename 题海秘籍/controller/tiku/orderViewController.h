//
//  orderViewController.h
//  学渣思政
//
//  Created by jiang aoteng on 16/5/8.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "ATViewController.h"
#import "data.h"
@class orderViewController;
@protocol orderViewControllerDelegate <NSObject>

-(void)saveWrongTpic:(orderViewController *)workView wrong:(NSMutableArray *)WrongArray;
-(void)deleteWrongTpic:(orderViewController *)workView wrong:(NSMutableArray *)WrongArray;
@end

@interface orderViewController : ATViewController{
//    @protected NSMutableArray *datas;
//    @property (copy, nonatomic) NSMutableArray *datas;
}


@property (nonatomic ,strong) NSMutableArray *tpArray;
@property (nonatomic ,copy) NSString *record;

@property (nonatomic,assign) NSInteger type;
@property(nonatomic ,copy)NSString *name;
@property (strong, nonatomic) NSMutableArray *datas;


//@property(nonatomic ,copy)NSString *key;
@property (assign, nonatomic) NSInteger index;

@property(nonatomic,weak)id<orderViewControllerDelegate>delegate;

-(NSString *)filePath;

@end

