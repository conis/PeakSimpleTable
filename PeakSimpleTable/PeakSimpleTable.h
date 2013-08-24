//
//  UISimpleTable.h
//  Created by conis on 7/26/13.
//  Copyright (c) 2013 conis. All rights reserved.
//  License: MIT
/*
 根据NSArray，创建简单的表格
 1. 仅支持ARC，非ARC需要处理release
 2. 
*/
#import <UIKit/UIKit.h>
#import "UIView+Helpers.h"

@protocol PeakSimpleTableDelegate;

@interface PeakSimpleTable : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) id<PeakSimpleTableDelegate> delegate;
//header的高度
@property (nonatomic) CGFloat headerHeight;
//是否显示header
@property (nonatomic) BOOL showHeader;
//标题的背景
@property (nonatomic, strong) UIColor *headerBackgroundColor;
//单元格的背景
@property (nonatomic, strong) UIColor *cellBackgroundColor;
//列之间的距离
@property (nonatomic) CGFloat columnSpacing;
//标题的字段
@property (nonatomic, strong) UIFont *headerFont;
//内容的字体
@property (nonatomic, strong) UIFont *contentFont;
//字段名称
@property (nonatomic, strong) NSArray *fields;
-(void) reloadData;
@end

//委托协议
@protocol PeakSimpleTableDelegate <NSObject>
@optional
//完成列内容，可以再设置label的颜色，字体等
-(void) peakSimpleTable: (PeakSimpleTable *) simpleTable didFinishContent: (UILabel *) contentLabel column: (NSInteger) col row: (NSInteger) row field: (NSString *) field;
//标题完成
-(void) peakSimpleTable: (PeakSimpleTable *) simpleTable didFinishHeader: (UILabel *) headerLabel column: (NSInteger) col field: (NSString *) field;
//获取列宽度
-(CGFloat) peakSimpleTable: (PeakSimpleTable *) simpleTable widthForColumn: (NSInteger) col field: (NSString *) field;
//获取行高
-(CGFloat) peakSimpleTable: (PeakSimpleTable *) simpleTable heightForRow: (NSInteger) row;
//委托必需要提供的内容
@required
//获取列标题
-(NSString *) peakSimpleTable: (PeakSimpleTable *) simpleTable headerForColumn: (NSInteger) col field: (NSString *) field;
//获取列内容
-(NSString *) peakSimpleTable: (PeakSimpleTable *) simpleTable contentForColumn: (NSInteger) col row: (NSInteger) row field: (NSString *) field;
//获取数据的数量
-(NSInteger) peakSimpleTable: (PeakSimpleTable *) simpleTable numberOfRowsInSection: (NSInteger) section;
@end
