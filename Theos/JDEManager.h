#import "Classes/JDEViewController.h"
#import "Classes/JDEButtons.h"


@interface JDEManager : NSObject
@property(nonatomic, strong) JDEViewController *JDEViewController;
@property(nonatomic, strong) JDEButtons *JDEButtons;
-(void)addSettingsButton;
@end