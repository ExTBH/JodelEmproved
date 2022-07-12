#import <UIKit/UIKit.h>
#import "Classes/JDEButtons.h"
#import "Classes/JDESettingsManager.h"
#import "Classes/JDEMapView.h"
#define VERSION "Jodel EMPROVED By @ExTBH (1.0.3)"

@interface JDEViewController : UIViewController
- (void)viewDidLoad;
-(BOOL)addSettingsButtonForView:(UIView*)view;
@end
