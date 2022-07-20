#import <UIKit/UIKit.h>
#import "Classes/JDEButtons.h"
#import "Classes/JDESettingsManager.h"
#import "Classes/JDEMapView.h"


@interface JDEViewController : UIViewController
- (void)viewDidLoad;
-(BOOL)addSettingsButtonForView:(UIView*)view;
@end
