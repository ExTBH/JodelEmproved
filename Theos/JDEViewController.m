#import "JDEViewController.h"
#include "Classes/ThemingViewController.h"
#include <UIKit/UIImage.h>
#import "Classes/JDELogsVC.h"

// Private declarations; this class only.
@interface JDEViewController()  <UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) UITableView *JETableview;
@property (strong, nonatomic) JDESettingsManager *settingsManager;
@end

@implementation JDEViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _settingsManager = [JDESettingsManager sharedInstance];
    [self configureLookAndBar];
    [self configureTableview];

}

// MARK: - General Methods
- (void)configureLookAndBar{
    // Who likea transparent background?
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    //Bar buttons you know
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self
                                                                        action:@selector(removeSettingsVC:)];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"location"] 
                                                                        style:UIBarButtonItemStyleDone target:self 
                                                                        action:@selector(didTapLocationButton:)];
}
- (void)configureTableview{
    self.JETableview = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    self.JETableview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.JETableview];
    self.JETableview.delegate = self;
    self.JETableview.dataSource = self;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.JETableview.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.JETableview.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.JETableview.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.JETableview.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    self.JETableview.sectionHeaderHeight = 33;
}


-(void)removeSettingsVC:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)switchValueChanged:(UISwitch*)sender{ [_settingsManager featureStateChangedTo:sender.isOn forTag:sender.tag]; }

- (void)didTapLocationButton:(UIButton*)sender{
    JDEMapView *mapView = [JDEMapView new];
    mapView.title = [_settingsManager localizedStringForKey:@"change_location"];
    [self.navigationController pushViewController:mapView animated:YES];
}

- (void)openLinkForIndexPath:(NSIndexPath*)indexPath{
    NSURL *url;
    switch(indexPath.row){
        case 0:
            url = [NSURL URLWithString:@"https://github.com/ExTBH/JodelEmproved/"];
            if([UIApplication.sharedApplication canOpenURL:url]){
                [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success){
                    NSLog(@"%d", success);
                }];}
            break;
        case 1:
            {
                url = [NSURL URLWithString:@"https://twitter.com/@ExTBH"];

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                message:@"DO NOT MESSAGE ME ABOUT BANS, I CAN NOT AND WIL NOT UNBAN YOU.\nIF YOU WERE GIVEN THIS IN SIDELOADED APP, NOT MY PROBLEM!"
                                preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK!" style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    if([UIApplication.sharedApplication canOpenURL:url]){
                                        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success){
                                            NSLog(@"%d", success);
                                        }];}
                                                    }];

                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                break;
            }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 2; }

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){ return 7;}
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = UIColor.clearColor;
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:label];
    
    switch (section) {
        case 0:
            label.text = [_settingsManager localizedStringForKey:@"general"];
            break;
        case 1:
            label.text = [_settingsManager localizedStringForKey:@"more"];
            break;
            
    }    label.textColor = UIColor.secondaryLabelColor;
    
    [NSLayoutConstraint activateConstraints:@[
        [label.leadingAnchor constraintEqualToAnchor:headerView.safeAreaLayoutGuide.leadingAnchor constant:20],
        [label.centerYAnchor constraintEqualToAnchor:headerView.safeAreaLayoutGuide.centerYAnchor]
    ]];
    
    
    return  headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return 44;
            break;
        default:
            return 22;
    }   

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        UIView *footerView = [UIView new];
        footerView.backgroundColor = UIColor.clearColor;

        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [footerView addSubview:label];

        NSString *info = [NSString stringWithFormat:@"Jodel EMPROVED (%@), %@, %@", PACKAGE_VERSION,
                [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"],
                [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"]];
        label.text = info;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColor.tertiaryLabelColor;

        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;

        [NSLayoutConstraint activateConstraints:@[
            [label.leftAnchor constraintEqualToAnchor:footerView.safeAreaLayoutGuide.leftAnchor constant:20],
            [label.centerYAnchor constraintEqualToAnchor:footerView.safeAreaLayoutGuide.centerYAnchor],
            [label.rightAnchor constraintEqualToAnchor:footerView.safeAreaLayoutGuide.rightAnchor constant:20],
        ]];
        return  footerView;
    }
    return nil;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsCell"];
    cell.backgroundColor = UIColor.clearColor;
    NSMutableArray<NSLayoutConstraint *> *consts = [NSMutableArray new];
    NSDictionary *infoDict = [_settingsManager cellInfoForPath:indexPath];

    //Cell Icon
    cell.imageView.image = infoDict[@"image"];
    cell.imageView.tintColor = [UIColor colorNamed:@"mainColor"];
    //Cell Label
    cell.textLabel.text = infoDict[@"title"];
    // hiding views for section 2
    if(indexPath.section == 0){

        //Switch Button
        UISwitch *switchView = [UISwitch new];
        switchView.onTintColor = [UIColor colorNamed:@"mainColor"];
        [switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        switchView.tag = indexPath.row;
        [switchView setOn:[_settingsManager featureStateForTag:indexPath.row] animated:NO];

        cell.accessoryView = switchView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if(indexPath.row == 0 || indexPath.row == 1){
            UIImage *icon = [UIImage resizeImageFromImage:infoDict[@"image"] withSize:CGSizeMake(25, 25)];
            cell.imageView.image = icon;
        }
        else if (indexPath.row == 3) {
            cell.imageView.image = [UIImage systemImageNamed:@"scribble"];
            cell.textLabel.text = @"Theming";
        }
    }

    [NSLayoutConstraint activateConstraints:consts];
    //Disabling cells
    if(infoDict[@"disabled"]){
            cell.contentView.alpha = 0.4;
            cell.userInteractionEnabled = NO;
        }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if (indexPath.row == 2){
            JDELogsVC *logsVC = [JDELogsVC new];
            [self.navigationController pushViewController:logsVC animated:YES];
        }
        else if (indexPath.row == 3) {
            ThemingViewController *themeVC = [ThemingViewController new];
            [self.navigationController pushViewController:themeVC animated:YES];
        }
        else {
            [self openLinkForIndexPath:indexPath];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}



- (UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point{
    NSMutableArray *suggestedActions = [NSMutableArray new];

    if(indexPath.section == 0){
        //Getting the cell so we can access the switch for the Menu
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //break if cell is disabled
        if(!cell.userInteractionEnabled) {return nil;}
        UISwitch *cellSwitch = cell.contentView.subviews[3];
        
        if (!cellSwitch.isOn) {
            UIAction *enable = [UIAction actionWithTitle:[_settingsManager localizedStringForKey:@"enable"] image:[UIImage systemImageNamed:@"checkmark"] identifier:nil handler:^(UIAction *handler) {
                [cellSwitch setOn:YES animated:YES];
                [self switchValueChanged:cellSwitch];
                }];
            [suggestedActions addObject:enable];
        } else {
            UIAction *disable = [UIAction actionWithTitle:[_settingsManager localizedStringForKey:@"disable"] image:[UIImage systemImageNamed:@"xmark"] identifier:nil handler:^(UIAction *handler) {
            [cellSwitch setOn:NO animated:YES];
            [self switchValueChanged:cellSwitch];
            }];
            [suggestedActions addObject:disable];
        }
        

        if(cellSwitch.tag == 2) {
            UIAction *location = [UIAction actionWithTitle:[_settingsManager localizedStringForKey:@"change_location"] image:[UIImage systemImageNamed:@"location"] identifier:nil handler:^(UIAction *handler) {
                [self didTapLocationButton:nil];
            }];
            [suggestedActions addObject:location];
        }
    }
    if(indexPath.section == 1 && indexPath.row < 2){
        UIAction *openLink = [UIAction actionWithTitle:[_settingsManager localizedStringForKey:@"link"] image:[UIImage systemImageNamed:@"link"] identifier:nil handler:^(UIAction *handler) {
                [self openLinkForIndexPath:indexPath];
            }];
        [suggestedActions addObject:openLink];
    }
    else {
        return nil;
    }
    UIMenu *menu = [UIMenu menuWithTitle:@"" children:suggestedActions];
    UIContextMenuConfiguration *menuConfig = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^(NSArray *suggestedActions) { return menu;}
    ];
    
    return  menuConfig;
}

@end
