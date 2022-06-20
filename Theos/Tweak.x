#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JDEManager.h"

@interface JDLMainFeedNavigationController : UINavigationController
@end
%hook JDLMainFeedNavigationController

-(void)viewDidLoad{
    %orig;
    JDEManager *JDEManager = [[JDEManager alloc] init];
    
    NSLog(@"JDELogs %@", JDEvc);
    //UIView *view = [self view];
    //[self addChildViewController:JDEvc];
}
%end


%ctor {
    %init(JDLMainFeedNavigationController=objc_getClass("Jodel.JDLMainFeedNavigationController"));
}