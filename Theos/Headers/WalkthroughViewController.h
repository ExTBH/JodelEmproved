#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WalkthroughViewController : UIPageViewController <UIPageViewControllerDelegate, UIScrollViewDelegate>
- (void)didTapNext; //called when ShrinkAnimationButton is tapped
- (void)showTokenAlertWithCompletion:(void (^)())completion;
@end