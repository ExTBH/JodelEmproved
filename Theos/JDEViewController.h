#import <UIKit/UIKit.h>
#import "Classes/JDEButtons.h"
#import "Classes/JDESettingsManager.h"
#define PATH "var/mobile/Library/Application Support/JodelEmproved.bundle"
#define VERSION "Jodel EMPROVED By @ExTBH (0.7)"

@interface JDEViewController : UIViewController
@property (strong, nonatomic) NSUserDefaults *tweakSettings;
- (void)viewDidLoad;
-(BOOL)addSettingsButtonForView:(UIView*)view;
@end
