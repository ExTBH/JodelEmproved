#import "JDEViewController.h"


// Private declarations; this class only.
@interface JDEViewController()
@end

@implementation JDEViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"JDELogs %s ", __PRETTY_FUNCTION__);
    //Alert for if the -addSettingsButton Failed.
    


}

-(BOOL)addSettingsButton{
    @try {
        //UIButton *btn = [[[JDEButtons alloc] init] defaultButton];
        UIView *superView = [JDLMainFeedNavigationController viewIfLoaded]; 
        NSLog(@"JDELogs %@ YES\n%s ", superView, __PRETTY_FUNCTION__);
    }
    @catch(NSException *exception){
        NSLog(@"JDELogs catch YES\n%s ", __PRETTY_FUNCTION__);
        return NO;
    }
    @finally {
        NSLog(@"JDELogs finally YES\n%s ", __PRETTY_FUNCTION__);
        return YES;
    }
}


@end