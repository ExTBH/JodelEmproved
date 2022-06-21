#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JDEViewController.h"

@interface JDLMainFeedNavigationController : UINavigationController

@end
%hook JDLMainFeedNavigationController

-(void)viewDidLoad{
    %orig;
    //UIView *view = [self viewIfLoaded];
    UIViewController *JDLmainFeedViewController = [[self childViewControllers] firstObject];
    JDEViewController *JDEvc = [[JDEViewController alloc] init];
    bool didAddSettingsButton = [JDEvc addSettingsButton];
    if(!didAddSettingsButton){
        NSLog(@"JDELogs ifstat");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Restart the APP!" message:@"Failed to load the Settings Button" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *dismissAlert = [UIAlertAction actionWithTitle:@"dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:dismissAlert];
        [JDLmainFeedViewController presentViewController:alert animated:YES completion:nil];
    }
    //[self addChildViewController:JDEvc];
}
%end

@interface TabBarController : UITabBarController
@end

%hook TabBarController

-(void)viewDidLoad{
    %orig;
    NSLog(@"JDELogs TabBarController");
    
}

%end

%ctor {
    %init(JDLMainFeedNavigationController=objc_getClass("Jodel.JDLMainFeedNavigationController"),
        TabBarController=objc_getClass("Jodel.TabBarController"));
}