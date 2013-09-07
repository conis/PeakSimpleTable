PeakSimpleTable
===============

简单的数据列表，用于显示简单的报表式数据，支持对每一个单元格设置格式

#Information

Conis

Blog: [http://iove.net](http://iove.net)

E-mail: [conis.yi@gmail.com](conis.yi@gmail.com)

项目主页: [https://github.com/conis/PeakSimpleTable](https://github.com/conis/PeakSimpleTable)

#Screenshot
![screenshot](https://raw.github.com/conis/PeakSimpleTable/master/screenshot-1.png)

#Usage
自用项目，暂时没有时间写使用说明，请参考代码，欢迎Fork或者翻译。
`PeakSimpleTable`可以用于简单的行列式报表显示，可以自定义每一个单元格的样式。

##init

	PeakSimpleTable *simpleTable = [[PeakSimpleTable alloc] initWithFrame: self.bounds];
	
	simpleTable.delegate = self;
	
	[self addSubview: simpleTable];

##property

	//委托
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

## method
	//重新加载数据
	-(void) reloadData;
##delegate

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

#LICENSE

MIT

