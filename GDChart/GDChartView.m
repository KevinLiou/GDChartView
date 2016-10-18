//
//  GDChartView.m
//  Chart
//
//  Created by Eric on 2016/9/7.
//
//

#import "GDChartView.h"
#import "GDChartDotButton.h"

#define BOTTOM_LABEL_HEIGHT 40
#define XAXISSPACE 80
#define RIGHT_LABEL_WIDTH 40

#define LINE_WIDTH 4
#define DOT_WIDTH 16

@interface GDChartView()

@property (nonatomic, assign) CGFloat yUnit;//y軸每個單位量
@property (nonatomic, assign) CGFloat yPointOfUnit;//每單位距離
@property (nonatomic, assign) GDRange yAxisRange;//y軸單位最大值最小值

@property (nonatomic, assign) CGFloat maxValue;//資料最大值
@property (nonatomic, assign) CGFloat minValue;//資料最小值
@property (nonatomic, assign) CGFloat maxValue2;//資料最大值
@property (nonatomic, assign) CGFloat minValue2;//資料最小值

//@property (strong, nonatomic) UIView *chartBackgroundView;
@property (strong, nonatomic) UIScrollView *chartScrollView;

@property (strong, nonatomic) GDChartDotButton *prevSelectDotButton;
@end

@implementation GDChartView

@synthesize yValues = _yValues;



- (void)setYValues:(NSArray *)yValues {
    _yValues = yValues;
    [self reloadChart];
}

- (void)reloadChartWithBackgroundColor:(UIColor *)backgroundColor
                       FirstChartColor:(UIColor *)firstColor
                           firstValues:(NSArray<NSNumber *> *)firstValues
                      secondChartColor:(UIColor *)secondColor
                          secondValues:(NSArray<NSNumber *> *)secondValues{
    
    self.color = firstColor;
    self.color2 = secondColor;
    
    self.yValues = firstValues;
    self.yValues2 = secondValues;
    
    self.backgroundColor = backgroundColor;
    
    [self reloadChart];
}

- (void)reloadChart{
    [self layoutIfNeeded];
    
    //取出資料中的最大值與最小值
    if ([self.yValues count]) {
        self.maxValue = [self findMaxValueFromNumbers:self.yValues];
        self.minValue = [[self.yValues valueForKeyPath:@"@min.self"] floatValue];
    }
    if([self.yValues2 count]) {
        self.maxValue2 = [self findMaxValueFromNumbers:self.yValues2];
        self.minValue2 = [[self.yValues2 valueForKeyPath:@"@min.self"] floatValue];
    }
    
    //合併資料中的最大 最小值
    CGFloat yMinValue;
    if (!self.minValue) {
        yMinValue = self.minValue2;
    }else if (!self.minValue2) {
        yMinValue = self.minValue;
    }else{
        yMinValue = (self.minValue < self.minValue2) ? self.minValue : self.minValue2;
    }
    CGFloat yMaxValue = (self.maxValue > self.maxValue2) ? self.maxValue : self.maxValue2;
    
    //算出y軸座標 最大值與最小值
    CGFloat yMin = ((floor(yMinValue/self.yUnit)) - 1) * self.yUnit;
    CGFloat yMax = ((floor(yMaxValue/self.yUnit)) + 2) * self.yUnit;
    
    
    GDRange range;
    range.max = yMax;
    range.min = yMin;
    range.size = yMax - yMin;
    self.yAxisRange = range;
    
    //[1].clear prev sub views and layers
    [[self.chartScrollView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //chart screooView
    self.chartScrollView.frame = CGRectMake(0, 0, self.frame.size.width - RIGHT_LABEL_WIDTH, self.frame.size.height);
    self.chartScrollView.contentSize = CGSizeMake(XAXISSPACE*self.yValues.count, self.chartScrollView.frame.size.height);
    [self addSubview:self.chartScrollView];
    
    //[2]. create chart bg
    
    UIView *chartBackgroundView = [[UIView alloc]init];
    CGFloat chartBackgroundViewWidth = XAXISSPACE*self.yValues.count;
    chartBackgroundViewWidth = (chartBackgroundViewWidth > self.chartScrollView.frame.size.width) ? chartBackgroundViewWidth : self.chartScrollView.frame.size.width;//圖表寬度，灰色部分（這裡設定至少要和螢幕scrollview同寬)
    chartBackgroundView.frame = CGRectMake(0, 0, chartBackgroundViewWidth, self.frame.size.height-BOTTOM_LABEL_HEIGHT);
    chartBackgroundView.backgroundColor = self.backgroundColor;
    [self.chartScrollView addSubview:chartBackgroundView];
    
    
    self.yPointOfUnit = (chartBackgroundView.frame.size.height / ((yMax - yMin)/self.yUnit));
    
    //[3].create yLabels,  draw y-axis  line
    for (CGFloat y = self.yAxisRange.min, index = 0 ; y <= self.yAxisRange.max; y+=self.yUnit, index++) {
        
        //1. add yLabel
        CGFloat yOrigin = index*self.yPointOfUnit;
        yOrigin = (yOrigin > 0) ? (yOrigin - 10.0) : yOrigin;
        
        NSInteger yReverseValue = (self.yAxisRange.max+self.yAxisRange.min - y);//由上到下原本是 小->大, 重新運算變為 大->小
        
        UILabel *yLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.chartScrollView.frame.origin.x + self.chartScrollView.frame.size.width , yOrigin , RIGHT_LABEL_WIDTH, 20.0)];
        yLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        yLabel.text = [NSString stringWithFormat:@" %ld", (long)yReverseValue];
        [self addSubview:yLabel];
        
        //2. draw line
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, self.yPointOfUnit * index)];
        [path addLineToPoint:CGPointMake(chartBackgroundView.frame.size.width,self.yPointOfUnit * index)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [chartBackgroundView.layer addSublayer:shapeLayer];
    }
    
    
    //[4]. create xLabels,  draw x-axis  line
    for (NSUInteger xOrigin = 0, index = 0; xOrigin < chartBackgroundView.frame.size.width ; xOrigin += XAXISSPACE, index++) {
        
        CGFloat xMove = XAXISSPACE/2.0; //每條線往左移動半個單位
        //1. add xLabel
        UILabel *xLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOrigin , self.frame.size.height - BOTTOM_LABEL_HEIGHT , XAXISSPACE, BOTTOM_LABEL_HEIGHT)];
        xLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        xLabel.text = [NSString stringWithFormat:@" %lu", (unsigned long)index + 1];
        xLabel.textAlignment = NSTextAlignmentCenter;
        [self.chartScrollView addSubview:xLabel];
        
        
        //2. draw line
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(xOrigin + xMove, 0)];
        [path addLineToPoint:CGPointMake(xOrigin + xMove, chartBackgroundView.frame.size.height)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [chartBackgroundView.layer addSublayer:shapeLayer];
        
    }
    
    //draw chart
    [self drawChartWithData:self.yValues color:self.color onView:chartBackgroundView];
    [self drawChartWithData:self.yValues2 color:self.color2 onView:chartBackgroundView];
    
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)drawChartWithData:(NSArray<NSNumber *> *)data color:(UIColor *)color onView:(UIView *)chartBackgroundView{
    
    if (![data count]) {
        return;
    }
    
    UIBezierPath *chartPath = [UIBezierPath bezierPath];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = LINE_WIDTH;
    [chartBackgroundView.layer addSublayer:shapeLayer];
    
    
    __block BOOL isDrawnFirstPoint = NO;
    for (NSUInteger xOrigin = 0, index = 0; xOrigin < chartBackgroundView.frame.size.width ; xOrigin += XAXISSPACE, index++) {
        if ([data count] <= index) {
            break;
        }
        CGFloat xMove = XAXISSPACE/2.0; //每條線往左移動半個單位
        CGFloat yValue = [data[index] floatValue];
        
        if (yValue == NSNotFound) {
            continue;
        }
        
        //值轉為座標....!!!
        CGFloat yPoint = chartBackgroundView.frame.size.height - ((yValue - self.yAxisRange.min)/self.yUnit)*self.yPointOfUnit;
        CGPoint point;//cache the point
        if (isDrawnFirstPoint == NO) {
            point = CGPointMake(xMove + index * XAXISSPACE, yPoint);
            [chartPath moveToPoint:point];
            isDrawnFirstPoint = YES;
        }else{
            point = CGPointMake(xMove + index * XAXISSPACE , yPoint);
            [chartPath addLineToPoint:point];
        }
        
        //create dot button
        GDChartDotButton *dotButton = [GDChartDotButton buttonWithType:UIButtonTypeCustom];
        dotButton.frame = CGRectMake(0, 0, DOT_WIDTH, DOT_WIDTH);
        dotButton.center = point;
        dotButton.backgroundColor = color;
        dotButton.layer.cornerRadius = DOT_WIDTH/2.0;
        dotButton.layer.borderWidth = 2.0;
        dotButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        dotButton.valueString = [NSString stringWithFormat:@"%@", data[index]];
        [dotButton addTarget:self action:@selector(clickDotButton:) forControlEvents:UIControlEventTouchUpInside];
        [chartBackgroundView addSubview:dotButton];
    }
    
    shapeLayer.path = chartPath.CGPath;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
}

//找出value array中的最大值。
//1.假使Array為空，回傳 0
//2.最大值不包含NSNotFound
- (CGFloat)findMaxValueFromNumbers:(NSArray <NSNumber*> *)numbers {
    __block CGFloat maxValue;
    if(![numbers count]){
        return 0.0;
    }else{
        maxValue = (numbers.firstObject.floatValue == NSNotFound) ? 0 : numbers.firstObject.floatValue;
    }
    
    [numbers enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = obj.floatValue;
        if (maxValue < value && value != NSNotFound) {
            maxValue = value;
        }
    }];
    return maxValue;
}

- (void)clickDotButton:(GDChartDotButton *)sender {
    if (sender == self.prevSelectDotButton) {
        return;
    }
    
    sender.labelHidden = NO;
    self.prevSelectDotButton.labelHidden = YES;
    self.prevSelectDotButton = sender;
}

- (UIColor *)color {
    if (!_color) {
        _color = [UIColor blueColor];
    }
    return _color;
}

- (UIColor *)color2 {
    if (!_color2) {
        _color2 = [UIColor redColor];
    }
    return _color2;
}

- (CGFloat)yUnit{
    if (!_yUnit) {
        _yUnit = 10.0;
    }
    return _yUnit;
}

- (UIScrollView *)chartScrollView {
    if (!_chartScrollView) {
        _chartScrollView = [[UIScrollView alloc]init];
        _chartScrollView.bounces = NO;
    }
    return  _chartScrollView;
}

//- (UIView *)chartBackgroundView {
//    if (!_chartBackgroundView) {
//        _chartBackgroundView = [[UIView alloc]init];
//        _chartBackgroundView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:2.0];
//    }
//    return _chartBackgroundView;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
