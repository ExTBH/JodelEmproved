#import "JDEButtons.h"


@implementation JDEButtons
-(UIButton*)defaultButton{
    //init
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.layer.masksToBounds = YES;
    //colors
    btn.layer.borderColor = [UIColor colorWithRed:1 green:0.710 blue:0.298 alpha:1].CGColor;
    [btn setTintColor:[UIColor colorWithRed:1 green:0.710 blue:0.298 alpha:1]];
    //sizes
    btn.layer.borderWidth = 2;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 10;

    return btn;
}

-(UIButton*)boldButton{
    //init
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    //colors
    [btn setTintColor:[UIColor whiteColor]];
    //sizes

    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];


    return btn;
}
- (UIButton*)buttonWithImageNamed:(NSString*)image{
    //init
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setImage:[UIImage systemImageNamed:image] forState:UIControlStateNormal]; //@"arrow.down.circle"
    //colors
    [btn setTintColor:[UIColor whiteColor]];
    //sizes
    btn.imageView.layer.transform = CATransform3DMakeScale(1.7, 1.7, 0);

    return btn;
}
@end