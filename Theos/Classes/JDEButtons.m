#import "JDEButtons.h"


@implementation JDEButtons
-(UIButton*)defaultButton{
    //init
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"EMPROVED" forState:UIControlStateNormal];
    //colors
    btn.layer.borderColor = [UIColor colorWithRed:1 green:0.710 blue:0.298 alpha:1].CGColor;
    [btn setTintColor:[UIColor colorWithRed:1 green:0.710 blue:0.298 alpha:1]];
    //sizes
    btn.layer.borderWidth = 2;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 10;

    return btn;
}

-(UIButton*)saveButton{
    //init
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:@"Save" forState:UIControlStateNormal];
    //colors
    [btn setTintColor:[UIColor whiteColor]];
    //sizes

    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];


    return btn;
}
@end