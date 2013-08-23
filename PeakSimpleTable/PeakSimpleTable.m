//
//  UISimpleTable.m
//  Pastime
//
//  Created by conis on 7/26/13.
//  Copyright (c) 2013 conis. All rights reserved.
//

#import "PeakSimpleTable.h"

@interface PeakSimpleTable()
@property (nonatomic, strong) UITableView *simpleTable;
@end

@implementation PeakSimpleTable
static NSString *kCellKey = @"static";
static NSInteger kTagBase = 1000;

#pragma mark 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self createComponent];
    }
    return self;
}

- (id)init
{
  self = [super init];
  if (self) {
    [self createComponent];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self createComponent];
  }
  return self;
}

#pragma makr 创建组件相关
//创建组件
-(void) createComponent{
  self.columnSpacing = 2;
  self.showHeader = YES;
  self.headerHeight = 40;
  self.headerFont = [UIFont boldSystemFontOfSize: 16];
  self.contentFont = [UIFont systemFontOfSize: 16];
  self.headerBackgroundColor = [UIColor grayColor];
  self.cellBackgroundColor = [UIColor whiteColor];
  
  self.simpleTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
  self.simpleTable.delegate = self;
  self.simpleTable.dataSource = self;
  self.simpleTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.simpleTable.backgroundColor = [UIColor clearColor];
  [self addSubview: self.simpleTable];
}

//创建单元格中的内容
-(void) createContent: (UIView *) superView isHeader: (BOOL) isHeader{
  //如果还没有设置header，则取第一行
  CGFloat lastRightX = self.columnSpacing;
  for (int i = 0; i < self.columnCount; i ++) {
    UILabel *label = [[UILabel alloc] init];
    [superView addSubview: label];
    label.frameSizeHeight = superView.frameSizeHeight;
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    label.tag = kTagBase + i;
    label.font = isHeader ? self.headerFont : self.contentFont;
    
    //设置宽度
    CGFloat width = CGFLOAT_MIN;
    if(self.delegate && [self.delegate respondsToSelector:@selector(peakSimpleTable:widthForColumnIndex:)]){
      width = [self.delegate peakSimpleTable:self widthForColumnIndex:i];
    };
    
    //没有通过代理获取宽度，或者返回的宽度不正确
    if(width == CGFLOAT_MIN){
      width = (superView.frameSizeWidth / self.columnCount) - self.columnSpacing;
    }
    
    //最后一列
    if(i == self.columnCount -1) width = superView.frameSizeWidth - lastRightX - self.columnSpacing;
    label.frameSizeWidth = width;
    label.frameOriginX = lastRightX;
    lastRightX = label.frameOriginX + label.frameSizeWidth + self.columnSpacing;
    label.backgroundColor = [UIColor clearColor];
    if(!isHeader) continue;
    
    //标题需要请求委托
    if(self.delegate && [self.delegate respondsToSelector:@selector(peakSimpleTable:headerForColumnIndex:)]){
      label.text = [self.delegate peakSimpleTable:self headerForColumnIndex:i];
    }else{
      label.text = nil;
    }
    
    //通知完成标题的绘制
    if(self.delegate && [self.delegate respondsToSelector:@selector(peakSimpleTable:didFinishHeader:column:)]){
      [self.delegate peakSimpleTable:self didFinishHeader:label column:i];
    }
  }
}

#pragma mark tableview的委托
//标题栏的高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return self.headerHeight;
}

//获取标题
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  //不使用标题
  if(!self.showHeader) return nil;
  
  //创建header的view
  UIView *view = [[UIView alloc] initWithSize:CGSizeMake(tableView.frameSizeWidth, self.headerHeight)];
  view.backgroundColor = self.headerBackgroundColor;
  [self createContent:view isHeader:YES];
  return view;
}

//获取行高
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if(self.delegate && [self.delegate respondsToSelector: @selector(peakSimpleTable:heightForRow:)]){
    return [self.delegate peakSimpleTable:self heightForRow: indexPath.row];
  }
  return self.headerHeight;
}

//返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  //请求委托返回总行数
  if(self.delegate && [self.delegate respondsToSelector:@selector(peakSimpleTable:numberOfRowsInSection:)]){
    return [self.delegate peakSimpleTable:self numberOfRowsInSection:section];
  }
  return 0;
}

//获取Cell
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellKey];
  
  //cell不存在，创建
  if (cell == nil){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: kCellKey];
    cell.contentView.backgroundColor = _cellBackgroundColor;
    [self createContent:cell.contentView isHeader:NO];
  }
  
  for (int i = 0; i < self.columnCount; i ++) {
    UIView *view = [cell.contentView viewWithTag: kTagBase + i];
    if(view == nil) continue;
    
    UILabel *label = (UILabel*)view;
    NSString *value = nil;
    //准备内容
    if(self.delegate && [self.delegate respondsToSelector:@selector(peakSimpleTable:contentForColumnIndex:row:)]){
      value = [self.delegate peakSimpleTable:self contentForColumnIndex: i row:indexPath.row];
    }
    label.text = value;

    if(self.delegate && [self.delegate respondsToSelector: @selector(peakSimpleTable:didFinishContent:column:)]){
        [self.delegate peakSimpleTable:self didFinishContent:label column:i row:indexPath.row];
    }
  }
  return cell;
}

//刷新数据 
-(void) reloadData{
  [self.simpleTable reloadData];
}
@end
