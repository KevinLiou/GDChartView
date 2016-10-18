//
//  GDChartView.h
//  Chart
//
//  Created by ctitv on 2016/9/7.
//
//

#import <UIKit/UIKit.h>

@interface GDChartView : UIView

struct Range {
    CGFloat max;
    CGFloat min;
    CGFloat size;
};
typedef struct Range GDRange;

@property (strong, nonatomic) NSArray *yValues;//第一條線，一定要有值。
@property (strong, nonatomic) UIColor *color;

@property (strong, nonatomic) NSArray *yValues2;
@property (strong, nonatomic) UIColor *color2;

@property (strong, nonatomic) UIColor *backgroundColor;
@property (nonatomic, assign, readonly) GDRange yAxisRange;

//http://stackoverflow.com/questions/14060002/wrong-frame-size-in-viewdidload
//在viewDidLoad以外的地方呼叫重繪，EX: viewDidLayoutSubviews, viewDidAppear
- (void)reloadChart;
- (void)reloadChartWithBackgroundColor:(UIColor *)backgroundColor
                            FirstChartColor:(UIColor *)firstColor
                        firstValues:(NSArray<NSNumber *> *)firstValues
                      secondChartColor:(UIColor *)secondColor
                     secondValues:(NSArray<NSNumber *> *)secondValues;
@end
