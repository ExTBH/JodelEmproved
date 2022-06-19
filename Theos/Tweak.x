#import "Tweak.h"



%hook JDLMainFeedNavigationController

-(void)viewDidLoad{
    NSLog(@"JodelTheos MFNC viewDidLoad called");
    %orig;
}

%ctor {
    %init(JDLMainFeedNavigationController=objc_getClass("Jodel.JDLMainFeedNavigationController"));
}