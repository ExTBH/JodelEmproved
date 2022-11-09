#import "ThemingViewController.h"
#include "Classes/ThemingManager.h"


@interface ThemingViewController() <ColorPickerDelegate>
@end

@implementation ThemingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    HBColorPickerConfiguration *CPConfig = [HBColorPickerConfiguration new];
    CPConfig.color = UIColor.whiteColor;

    HBColorPickerViewController *colorPicker = [HBColorPickerViewController new];
    colorPicker.delegate = self;
    colorPicker.configuration = CPConfig;
    
    [self presentViewController:colorPicker animated:YES completion:nil];
}
@end