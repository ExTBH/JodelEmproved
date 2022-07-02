#import <UIKit/UIKit.h>
#import "Classes/JDEButtons.h"
#define PATH "var/mobile/Library/Application Support/JodelEmproved.bundle"
#define VERSION "Jodel EMPROVED By @ExTBH (0.0.5)"

@interface JDEViewController : UIViewController
- (void)viewDidLoad;
-(BOOL)addSettingsButtonForView:(UIView*)view;
@end
