#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JDEViewController.h"

@interface JDLMainFeedNavigationController : UINavigationController

-(BOOL)addSettingsButton;
-(void)presentJDEViewController:(id)sender;
@end
%hook JDLMainFeedNavigationController

JDEViewController *JDEvc;


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
        [btn.leadingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.leadingAnchor constant:20].active = YES;
        [btn.widthAnchor constraintEqualToAnchor:view.widthAnchor multiplier:0.25].active = YES;

        
        return YES;
    }
    @catch(NSException *exception){
        return NO;
    }
}

%new
-(void)presentJDEViewController:(id)sender{
    NSBundle *mainBundle = [NSBundle bundleWithPath:@PATH];
    NSString *configPath = [mainBundle pathForResource:@"config" ofType:@"json"];
    // present UIAlert later
    if (configPath == nil){
        return;
    }
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


@interface PictureFeedViewController : UIViewController
@end
%hook PictureFeedViewController

- (void)viewDidLoad{
    %orig;
    @try {
        UIView *view = [self viewIfLoaded];
        UIButton *btn = [[[JDEButtons alloc] init] saveButton];
        [btn addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        //Constraints
        [btn.trailingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.trailingAnchor constant:-77].active = YES;
        [btn.bottomAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.bottomAnchor constant:-45].active = YES;
        //[btn.widthAnchor constraintEqualToAnchor:view.widthAnchor multiplier:0.25].active = YES;
    }
    @catch(NSException *exception){
    }
}

%new
- (bool)saveImage:(id)sender{
    @try{
        UIView *view = [self view];
        view = [[view subviews] firstObject];
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(capturedImage, nil, nil, nil);
        return YES;
    }
    @catch(NSException *exception){
        return NO;
    }
}

- (void)refresh:(id)unknown{
    NSLog(@"JDELogs unknown ; %@", unknown);
    %orig;
}

%end

%ctor {
    %init(JDLMainFeedNavigationController=objc_getClass("Jodel.JDLMainFeedNavigationController"),
    PlaceholderTextView=objc_getClass("Jodel.PlaceholderTextView"),
    PictureFeedViewController=objc_getClass("Jodel.PictureFeedViewController"));
}