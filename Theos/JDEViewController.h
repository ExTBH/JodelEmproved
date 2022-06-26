#import <UIKit/UIKit.h>
#import "Classes/JDEButtons.h"
#define PATH "Library/Application Support/JodelEmproved.bundle"

@interface JDEViewController : UIViewController
- (void)viewDidLoad;
-(BOOL)addSettingsButtonForView:(UIView*)view;
@end
