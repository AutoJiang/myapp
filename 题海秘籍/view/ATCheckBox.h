//
//  EICheckBox.h
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATCheckBoxDelegate;

@interface ATCheckBox : UIButton {
    id<ATCheckBoxDelegate> delegate;
    BOOL _checked;
    id _userInfo;
}

@property(nonatomic, assign)id<ATCheckBoxDelegate> delegate;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic, retain)id userInfo;

- (id)initWithDelegate:(id)delegate;

@end

@protocol ATCheckBoxDelegate <NSObject>

@optional

- (void)didSelectedCheckBox:(ATCheckBox *)checkbox checked:(BOOL)checked;

@end
