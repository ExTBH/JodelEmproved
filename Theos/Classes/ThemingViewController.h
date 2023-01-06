#import <UIKit/UIKit.h>
#import "Exts.h"
@interface ThemingViewController : UIViewController
@end

@interface ColorCell : UITableViewCell
@property (nonatomic, strong) UIButton *colorButton;
@end


typedef NS_ENUM(NSUInteger, ThemeOption){
    ThemeOptionMainColor,
    ThemeOptionSecondaryColor,
    ThemeOptionUserSectionColor,
    ThemeOptionChannelsSectionColor,
    ThemeOptionNotificationsSectionColor,
    ThemeOptionPollCellsBackgroundColor

};

