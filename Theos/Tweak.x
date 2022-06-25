#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JDEViewController.h"

@interface JDLMainFeedNavigationController : UINavigationController
//@property (strong, nonatomic) UIViewController *test;
-(BOOL)addSettingsButton;
-(void)presentJDEViewController:(id)sender;
@end
%hook JDLMainFeedNavigationController

JDEViewController *JDEvc;

//%property (strong, nonatomic) UIViewController *test;

-(void)viewDidLoad{
    %orig;
    UIViewController *JDLmainFeedViewController = [[self childViewControllers] firstObject];
    JDEvc= [[JDEViewController alloc] init];

    bool didAddSettingsButton = [self addSettingsButton];
    if(!didAddSettingsButton){
        NSLog(@"JDELogs ifstat");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Restart the APP!" message:@"Failed to load the Settings Button" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *dismissAlert = [UIAlertAction actionWithTitle:@"dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:dismissAlert];
        [JDLmainFeedViewController presentViewController:alert animated:YES completion:nil];
    }
}

%new
-(BOOL)addSettingsButton{
    @try {
        UIView *view = [self viewIfLoaded];
        UIButton *btn = [[[JDEButtons alloc] init] defaultButton];
        [btn addTarget:self action:@selector(presentJDEViewController:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        //Constraints
        [btn.topAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.topAnchor constant:10].active = YES;
        [btn.leadingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.leadingAnchor constant:15].active = YES;
        [btn.widthAnchor constraintEqualToAnchor:view.widthAnchor multiplier:0.25].active = YES;

        
        return YES;
    }
    @catch(NSException *exception){
        return NO;
    }
}

%new
-(void)presentJDEViewController:(id)sender{
    [self presentViewController:JDEvc animated:YES completion:nil];
}
%end


//Enable Paste In New Posts
%hook PlaceholderTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (action == @selector(paste:))
        return YES;
    if (action == @selector(copy:))
        return YES;
    if (action == @selector(selectAll:))
        return YES;
    return %orig;
}

%end


%ctor {
    %init(JDLMainFeedNavigationController=objc_getClass("Jodel.JDLMainFeedNavigationController"),
    PlaceholderTextView=objc_getClass("Jodel.PlaceholderTextView"));
}