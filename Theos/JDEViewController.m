#import "JDEViewController.h"


// Private declarations; this class only.
@interface JDEViewController()
@end

@implementation JDEViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed: 0.73 green: 0.33 blue: 0.83 alpha: 0.5];
    NSLog(@"JDELogs %s ", __PRETTY_FUNCTION__);
    //Alert for if the -addSettingsButton Failed.
    


}

-(BOOL)addSettingsButtonForView:(UIView*)view{
    @try {
        UIButton *btn = [[[JDEButtons alloc] init] defaultButton];
        [view addSubview:btn];
        //Constraints
        [btn.topAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.topAnchor constant:10].active = YES;
        [btn.leadingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.leadingAnchor constant:15].active = YES;
        [btn.widthAnchor constraintEqualToAnchor:view.widthAnchor multiplier:0.25].active = YES;

        
        NSLog(@"JDELogs try YES\n%s ", __PRETTY_FUNCTION__);
        return YES;
    }
    @catch(NSException *exception){
        NSLog(@"JDELogs catch YES\n%s ", __PRETTY_FUNCTION__);
        return NO;
    }
}


@end