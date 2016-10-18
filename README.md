# GDChartView
## 透過線條繪製簡單的圖表

1.支援autolayout

2.顯示一條(或兩條)線圖表

3.點擊小圓點，顯示數值。

4.如果沒有數值，則跳過。(填入NSNotFound)

## Example Code
```objc
NSArray *line1_vals = @[@(111),@(118),@(109),@(122),@(115),@(106),@(NSNotFound),@(120)];
NSArray *line2_vals = @[@(90),@(80),@(77),@(89),@(71),@(81),@(NSNotFound),@(91)];
    
[self.chartView reloadChartWithBackgroundColor:[UIColor colorWithRed:210.0/255.0 green:240.0/255.0 blue:225.0/255.0 alpha:1.0]
                                   FirstChartColor:[UIColor colorWithRed:61.0/255.0 green:137.0/255.0 blue:205.0/255.0 alpha:1.0]
                                       firstValues:line1_vals
                                  secondChartColor:[UIColor colorWithRed:46.0/255.0 green:187.0/255.0 blue:124.0/255.0 alpha:1.0]
                                      secondValues:line2_vals];
```
## Demo

![alt tag1](https://github.com/KevinLiou/GDChartView/blob/master/GDChartSample/screenshot1.png)
![alt tag2](https://github.com/KevinLiou/GDChartView/blob/master/GDChartSample/screenshot2.png)




[![Demo](http://img.youtube.com/vi/8ChRlkzgaAY/0.jpg)](http://www.youtube.com/watch?v=8ChRlkzgaAY)
