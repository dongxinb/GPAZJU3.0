//
//  GZGeneralViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 2/24/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GPAZJU-Bridging-Header.h"
#import "GZGeneralViewController.h"

#import "GZSummary.h"

@interface GZGeneralViewController ()<ChartViewDelegate>

@property (strong, nonatomic) PieChartView *pieChart;
@property (strong, nonatomic) NSArray<GZSummary *> *categoryArray;

@end

@implementation GZGeneralViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self configureUI];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	self.pieChart.holeRadiusPercent = 0.4;
	[self.pieChart animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}

- (void)configureUI
{
	WS(weakSelf);
    [self customNavigationItemWithTitle:@""];

	[self.view addSubview:self.pieChart];
	[self setupCharts];
}

- (void)setupCharts
{
	NSMutableArray *yVals = [[NSMutableArray alloc] init];

	self.categoryArray = [[GZUser currentUser] getGeneralCoursesStatistics];

	NSMutableArray *x = [NSMutableArray array];

	for (NSInteger i = 0; i < self.categoryArray.count; i++) {
		GZSummary *summary = self.categoryArray[i];
		[x addObject:summary.introduction];
		[yVals addObject:[[BarChartDataEntry alloc] initWithValue:summary.creditSummary xIndex:i]];
	}

	PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals label:@""];
	dataSet.sliceSpace = 2.0;

	//	NSArray *colors = @[RGBCOLOR(80, 80, 80), RGBCOLOR(100, 100, 100), RGBCOLOR(120, 120, 120), RGBCOLOR(140, 140, 140), RGBCOLOR(160, 160, 160), RGBCOLOR(180, 180, 180), RGBCOLOR(200, 200, 200), RGBCOLOR(220, 220, 220)];
	NSMutableArray *colors = [NSMutableArray array];
	for (NSInteger i = 0; i < self.categoryArray.count; i++) {
		CGFloat f = 80 + (220 - 80) / (self.categoryArray.count - 1) * i;
		[colors addObject:RGBCOLOR(f, f, f)];
	}

	dataSet.colors = colors;

	PieChartData *data = [[PieChartData alloc] initWithXVals:x dataSet:dataSet];

	NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
	pFormatter.numberStyle = NSNumberFormatterPercentStyle;
	pFormatter.maximumFractionDigits = 1;
	pFormatter.minimumFractionDigits = 1;
	pFormatter.multiplier = @1.f;
	pFormatter.percentSymbol = @"学分";
	[data setValueFormatter:pFormatter];
	[data setValueFont:[UIFont fontWithStyle:GZFontStyleDescription]];
	//	[data setValueTextColor:UIColor.whiteColor];

	self.pieChart.data = data;
	[self.pieChart setDrawMarkers:YES];
	[self.pieChart highlightValues:nil];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase *__nonnull)chartView entry:(ChartDataEntry *__nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight *__nonnull)highlight
{
	NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase *__nonnull)chartView
{
	NSLog(@"chartValueNothingSelected");
}

#pragma mark - Getter

- (PieChartView *)pieChart
{
	if (!_pieChart) {
		_pieChart = [[PieChartView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT - 70)];
		_pieChart.delegate = self;
		_pieChart.drawHoleEnabled = YES;
		_pieChart.usePercentValuesEnabled = NO;
		_pieChart.holeTransparent = YES;
		_pieChart.holeRadiusPercent = 1.0;
		_pieChart.transparentCircleRadiusPercent = 0.43;
		_pieChart.descriptionText = @"\n以上数据仅供参考，具体请以教务网为准";
		[_pieChart setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
		_pieChart.drawCenterTextEnabled = YES;

		_pieChart.centerText = @"通识统计";
		_pieChart.rotationAngle = 0.;
		_pieChart.rotationEnabled = YES;
		_pieChart.highlightPerTapEnabled = NO;

		_pieChart.noDataText = @"No Data";

		_pieChart.legend.position = ChartLegendPositionRightOfChartInside;
		_pieChart.legend.wordWrapEnabled = YES;

		//		_pieChart.noDataTextDescription = @"noDataTextDescription";
	}
	return _pieChart;
}

@end
