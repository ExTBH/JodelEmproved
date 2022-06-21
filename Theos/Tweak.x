#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JDEViewController.h"

@interface JDLMainFeedNavigationController : UINavigationController

@end
%hook JDLMainFeedNavigationController

-(void)viewDidLoad{
    %orig;
    UIView *view = [self viewIfLoaded];
    JDEViewController *JDEVC = [[JDEViewController alloc] init];

    NSLog(@"JDELogs %@", view);
    bool didAddSettingsButton = [JDEVC addSettingsButton];
    if(!didAddSettingsButton){
        NSLog(@"JDELogs Failed to load Alert");
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
    //[self addChildViewController:JDEVC];
}
%end


%ctor {
    %init(JDLMainFeedNavigationController=objc_getClass("Jodel.JDLMainFeedNavigationController"));
}