#import "Tweak.h"


@interface UINavigationItem()
@property(nonatomic, strong, readwrite)UIBarButtonItem *customRightItem;
@property(nonatomic, strong, readwrite)UIBarButtonItem *customLeftItem;
@property(nonatomic, strong, readwrite)UIView *customTitleView;
@end
%hook JDLMainFeedNavigationController

-(void)viewDidLoad{
    NSLog(@"JodelTheos MFNC viewDidLoad called");
    %orig;
    UIView *view = [self view];
    for(UINavigationBar *subView in view.subviews) {
        if([subView isMemberOfClass:[UINavigationBar class]]){
            UINavigationItem *item = subView.items[0];
            NSLog(@"JodelTheos MFNC navBar.item :\n%@", item);
            NSLog(@"JodelTheos MFNC navBar.item.customRightItem :\n%@", item.customRightItem);
            NSLog(@"JodelTheos MFNC navBar.item.customLeftItem :\n%@", item.customLeftItem);
            NSLog(@"JodelTheos MFNC navBar.item.customTitleView :\n%@", item.customTitleView);
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStylePlain target:self action:nil];
            item.customLeftItem = backButton;
        }
    }
}

%end

%hook DefaultNavigationController

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    id orig = %orig;
    //NSLog(@"JodelTheos DNC rooVC : %@\norig : %@", rootViewController, orig);

    return orig;
}

-(void)viewDidLoad{
    //NSLog(@"JodelTheos DNC viewDidLoad called");
    %orig;
}

%end


%ctor {
    %init(JDLMainFeedNavigationController=objc_getClass("Jodel.JDLMainFeedNavigationController"),
    DefaultNavigationController=objc_getClass("Jodel.DefaultNavigationController"));
}