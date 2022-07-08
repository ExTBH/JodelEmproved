#import <UIKit/UIKit.h>
#import "Classes/JDEButtons.h"
#import "Classes/JDESettingsManager.h"
#import "Classes/JDEMapView.h"
#define PATH "var/mobile/Library/Application Support/JodelEmproved.bundle"
#define VERSION "Jodel EMPROVED By @ExTBH (1)"

@interface JDEViewController : UIViewController
- (void)viewDidLoad;
-(BOOL)addSettingsButtonForView:(UIView*)view;
@end
