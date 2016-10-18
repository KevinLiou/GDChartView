//
//  ViewController.m
//  GDChartSample
//
//  Created by ctitv on 2016/10/18.
//  Copyright © 2016年 test. All rights reserved.
//

#import "ViewController.h"
#import "GDChartView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet GDChartView *chartView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.label1.text = @"MAX: 122";
    self.label2.text = @"MAX: 91";
}

- (void)viewDidLayoutSubviews {
    NSArray *line1_vals = @[@(111),@(118),@(109),@(122),@(115),@(106),@(NSNotFound),@(120),@(116),@(110),@(105),@(120),@(112),@(107),@(NSNotFound),@(110),@(111),@(118),@(109),@(122),@(115),@(106),@(NSNotFound),@(120),@(116),@(110),@(105),@(120),@(112),@(107)];
    NSArray *line2_vals = @[@(90),@(80),@(77),@(89),@(71),@(81),@(NSNotFound),@(91),@(80),@(77),@(89),@(71),@(81),@(77),@(NSNotFound),@(89),@(90),@(80),@(77),@(89),@(71),@(81),@(NSNotFound),@(90),@(80),@(77),@(89),@(71),@(81),@(77)];
    
    [self.chartView reloadChartWithBackgroundColor:[UIColor colorWithRed:210.0/255.0 green:240.0/255.0 blue:225.0/255.0 alpha:1.0]
                                   FirstChartColor:[UIColor colorWithRed:61.0/255.0 green:137.0/255.0 blue:205.0/255.0 alpha:1.0]
                                       firstValues:line1_vals
                                  secondChartColor:[UIColor colorWithRed:46.0/255.0 green:187.0/255.0 blue:124.0/255.0 alpha:1.0]
                                      secondValues:line2_vals];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
