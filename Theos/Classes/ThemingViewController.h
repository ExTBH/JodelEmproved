#import <UIKit/UIKit.h>
#import "Exts.h"
@interface ThemingViewController : UIViewController
@end

@interface ColorCell : UITableViewCell
@property (nonatomic, strong) UIButton *colorButton;
@end


#define main "mainColor"
#define secondary "customLightGrayColor"
#define user "meColor"
#define userDot "channelNotification"
#define channel "channelColor"
#define channelDot "declineColor" // channel and notification Dots
#define notification "notificationColor"
#define pollCell "pollBgColor"


typedef NS_ENUM(NSUInteger, ThemeOption){
    ThemeOptionMainColor,
    ThemeOptionSecondaryColor,
    ThemeOptionUserSectionColor,
    ThemeOptionChannelsSectionColor,
    ThemeOptionNotificationsSectionColor,
    ThemeOptionPollCellsBackgroundColor

};

