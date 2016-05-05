//
//  briefViewController.h
//  学渣思政
//
//  Created by jiang aoteng on 16/5/2.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface briefViewController : UIViewController

@property (strong, nonatomic)NSString *brief;

@property (nonatomic, copy) void (^briefBlock)(NSString *text);

@end
