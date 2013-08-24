//
//  ViewController.m
//  PeakSimpleTable-Samples
//
//  Created by conis on 8/23/13.
//  Copyright (c) 2013 conis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *datas;
@end

@implementation ViewController
static NSString *kFieldDate = @"date";
static NSString *kFieldIncome = @"income";
static NSString *kFieldExpenses = @"expenses";
static NSString *kFieldBalance = @"balance";

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  self.simpleTable.fields = @[kFieldDate, kFieldIncome, kFieldExpenses, kFieldBalance];
  self.datas = @[
                 @{kFieldDate: @"2013-08-21", kFieldIncome: @"30", kFieldExpenses: @"29"},
                 @{kFieldDate: @"2013-08-22", kFieldIncome: @"93", kFieldExpenses: @"39"},
                 @{kFieldDate: @"2013-08-23", kFieldIncome: @"60", kFieldExpenses: @"41"},
                 @{kFieldDate: @"2013-08-24", kFieldIncome: @"28", kFieldExpenses: @"19.5"}
                 ];
  self.simpleTable.delegate = self;
  //self.simpleTable.columnCount = self.headers.count;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PeakSimpleTable的委托

//返回总行数
-(NSInteger) peakSimpleTable:(PeakSimpleTable *)simpleTable numberOfRowsInSection:(NSInteger)section{
  //多返回一行的原因，是因为最后一行可以用来做统计用
  return self.datas.count + 1;
}

//返回列宽
-(CGFloat) peakSimpleTable:(PeakSimpleTable *)simpleTable widthForColumn:(NSInteger)col field:(NSString *)field{
  switch (col) {
    case 0: return 90;
    case 1: return 80;
    case 2: return 80;
    case 3: return 80;
  }
  return 0;
}

//返回标题的名称 
-(NSString *) peakSimpleTable:(PeakSimpleTable *)simpleTable headerForColumn:(NSInteger)col field:(NSString *)field{
  return @[@"日期", @"收入", @"支出", @"结余"][col];
}

//返回单元格的具体内容
-(NSString *) peakSimpleTable:(PeakSimpleTable *)simpleTable contentForColumn:(NSInteger)index row:(NSInteger)row field:(NSString *)field{
  
  //最后一行，返回统计结果
  if(row == self.datas.count){
    NSString *text = nil;
    if([field isEqualToString: kFieldExpenses] ||
       [field isEqualToString: kFieldBalance] ||
       [field isEqualToString: kFieldIncome]){
      text = [NSString stringWithFormat: @"$%.2f", [self sumForField: field]];
    }else{
      text = @"合计";
    }
    return text;
  }
  
  NSDictionary *dict = self.datas[row];
  //如果是余额，就进行计算
  if([field isEqualToString: kFieldBalance]){
    CGFloat exp = [[dict objectForKey: kFieldExpenses] floatValue];
    CGFloat inc = [[dict objectForKey: kFieldIncome] floatValue];
    return [NSString stringWithFormat: @"%0.2f", inc - exp];
  }
  
  //返回两位小数
  if([field isEqualToString: kFieldIncome] || [field isEqualToString: kFieldExpenses]){
    return [NSString stringWithFormat: @"%0.2f", [[dict objectForKey: field] floatValue]];
  }
  
  return [dict objectForKey: field];
}

//完成内容后
-(void) peakSimpleTable:(PeakSimpleTable *)simpleTable didFinishContent:(UILabel *)contentLabel column:(NSInteger)col row:(NSInteger)row field:(NSString *)field{

  //对内容进行排序，并设置不同的颜色，这里以有更多发挥，比如说大于某个值可以重点提示等。
  
  NSTextAlignment align = NSTextAlignmentRight;
  UIColor *color = [UIColor darkGrayColor];

  if([field isEqualToString: kFieldDate]){
    align = NSTextAlignmentLeft;
  }else if([field isEqualToString: kFieldBalance]){
    color = [UIColor orangeColor];
  }else if([field isEqualToString: kFieldIncome]){
    color = [UIColor greenColor];
  }else if([field isEqualToString: kFieldExpenses]){
    color = [UIColor redColor];
  }
  contentLabel.textColor = color;
  contentLabel.textAlignment = align;
}

//统计某个字段
-(CGFloat) sumForField: (NSString *) field{
  CGFloat result = 0;
  for (NSDictionary *dict in self.datas) {
    if([field isEqualToString: kFieldBalance]){
      //统计余额
      CGFloat exp = [[dict objectForKey: kFieldExpenses] floatValue];
      CGFloat inc = [[dict objectForKey: kFieldIncome] floatValue];
      result += inc - exp;
    }else{
      result += [[dict objectForKey: field] floatValue];
    }
  }
  return result;
}
@end
