#import <UIKit/UIKit.h>
#import "Classes/JDEButtons.h"
#define PATH "var/mobile/Library/Application Support/JodelEmproved.bundle"

@interface JDEViewController : UIViewController
- (void)viewDidLoad;
-(BOOL)addSettingsButtonForView:(UIView*)view;
@end
