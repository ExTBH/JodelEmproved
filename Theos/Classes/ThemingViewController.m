#import "ThemingViewController.h"
#include "Classes/JDESettingsManager.h"


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending) // https://stackoverflow.com/a/5337804



static NSDictionary<NSNumber*, NSString*> *_ThemeOptionKeysDict(){
    return @{
        @(ThemeOptionMainColor): @"mainColor",
        @(ThemeOptionSecondaryColor): @"customLightGrayColor",
        @(ThemeOptionUserSectionColor): @"meColor",
        @(ThemeOptionChannelsSectionColor): @"channelColor",
        @(ThemeOptionNotificationsSectionColor): @"notificationColor",
        @(ThemeOptionPollCellsBackgroundColor): @"pollBgColor"
    };
}

UIColor *colorForKey(NSString *key){
    UIColor *color = [[JDESettingsManager sharedInstance].tweakSettings colorForKey:key];
    if (!color){
        return [UIColor colorNamed:key];
    }
    return color;
}

// https://stackoverflow.com/a/7323029/16619237
NSString *splitStringByUpperCase(NSString *str){

    int index = 1;
    NSMutableString* mutableInputString = [NSMutableString stringWithString:str];

    while (index < mutableInputString.length) {

        if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[mutableInputString characterAtIndex:index]]) {
            [mutableInputString insertString:@" " atIndex:index];
            index++;
        }
        index++;
    }

    return [NSString stringWithString:mutableInputString];
}


@interface ColorCell()
@end

@implementation ColorCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.accessoryView = self.colorButton;
        self.colorButton.frame = CGRectMake(0, 0, 30, 30);
        self.colorButton.layer.cornerRadius = .5 * self.colorButton.frame.size.width;
        self.colorButton.clipsToBounds = YES;
        self.colorButton.layer.borderWidth = 3;
        self.colorButton.layer.borderColor = UIColor.systemGrayColor.CGColor;
    }
    return self;
}

@end

@interface ThemingViewController()<UITableViewDelegate, UITableViewDataSource, UIColorPickerViewControllerDelegate> 
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *indexPathForColorPicker;
@end

@implementation ThemingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.title = @"Theming";

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 33;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = @"Unavailable for below iOS 14 :)";
    label.textColor = UIColor.secondaryLabelColor;
    return label;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _ThemeOptionKeysDict().allKeys.count +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == [tableView numberOfRowsInSection:0] -1){
        UITableViewCell *resetCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        resetCell.textLabel.text = @"Reset";
        resetCell.textLabel.textColor = UIColor.systemRedColor;
        resetCell.textLabel.textAlignment = NSTextAlignmentCenter;

        return resetCell;
    }
    
    ColorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"colorCell"];
    if (!cell){
        cell = [[ColorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"colorCell"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *rawKey = _ThemeOptionKeysDict()[@(indexPath.row)];
    NSString *formattedKey = [rawKey stringByReplacingOccurrencesOfString:@"Color" withString:@""];
    formattedKey = splitStringByUpperCase(formattedKey);
    cell.textLabel.text = formattedKey;
    cell.colorButton.backgroundColor = colorForKey(rawKey);
    [cell.colorButton addTarget:self action:@selector(tappedColor:) forControlEvents:UIControlEventTouchUpInside];


    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == [tableView numberOfRowsInSection:0] -1){
        for(NSString *color in _ThemeOptionKeysDict().allValues){
            [[JDESettingsManager sharedInstance].tweakSettings removeObjectForKey:color];
        }
        [tableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tappedColor:(UIButton*)sender{
    CGPoint buttonPos = [sender convertPoint:CGPointZero toView:self.tableView];
    self.indexPathForColorPicker = [self.tableView indexPathForRowAtPoint:buttonPos];

    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14")){
        UIColorPickerViewController *colorPicker = [UIColorPickerViewController new];
        colorPicker.delegate = self;
        [self presentViewController:colorPicker animated:YES completion:nil];
    }
}

- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController{
    ColorCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPathForColorPicker];
    cell.colorButton.backgroundColor = viewController.selectedColor;
    [[JDESettingsManager sharedInstance].tweakSettings setColor:viewController.selectedColor
        forKey:_ThemeOptionKeysDict()[@(self.indexPathForColorPicker.row)]];
}
@end

