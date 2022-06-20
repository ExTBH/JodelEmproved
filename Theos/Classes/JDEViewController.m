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
    if(![self didAddSettingsButton]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Restart the APP!" 
                                    message:@"Failed to load the Settings Button" 
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *dismissAlert = [UIAlertAction actionWithTitle:@"OK" 
                                    style:UIAlertActionStyleDefault
                                    handler:nil];
        //^(UIAlertAction * action) {}
        [alert addAction:dismissAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }


}

-(BOOL)didAddSettingsButton{
    @try {
    }
    @catch(NSException *exception){
        return NO;
    }
    @finally {
        return YES;
    }
}


@end