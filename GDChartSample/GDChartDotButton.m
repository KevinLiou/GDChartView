//
//  GDChartDotButton.m
//  gdcare
//
//  Created by ctitv on 2016/9/8.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "GDChartDotButton.h"

@interface GDChartDotButton()
@property (strong, nonatomic) UILabel *valueLabel;
@end

@implementation GDChartDotButton

- (void)setLabelHidden:(BOOL)labelHidden {
    _labelHidden = labelHidden;
    self.valueLabel.hidden = _labelHidden;
}

- (void)setValueString:(NSString *)valueString {
    _valueString = valueString;
    
    self.valueLabel.text = [NSString stringWithFormat:@" %@ ", _valueString];
    [self.valueLabel sizeToFit];
    self.valueLabel.center = CGPointMake(self.valueLabel.frame.size.width/2, self.frame.size.height + 25);
    _valueLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    _valueLabel.layer.cornerRadius = 5.0f;
    _valueLabel.clipsToBounds = YES;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _valueLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _valueLabel.textColor = self.backgroundColor;
        self.labelHidden = YES;
        _valueLabel.hidden = self.labelHidden;
        [self addSubview:_valueLabel];
    }
    return _valueLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
