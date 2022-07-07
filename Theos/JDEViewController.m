#import "JDEViewController.h"


// Private declarations; this class only.
@interface JDEViewController()  <UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) JDESettingsManager *settingsManager;
@end

@implementation JDEViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _settingsManager = [JDESettingsManager sharedInstance];
    if (_settingsManager == nil) {NSLog(@"JDELogs Fatal error in [_settingsManager init] fix ASAP");}

    
    //Objects
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    navBar.standardAppearance = [[UINavigationBarAppearance alloc] init];
    [navBar.standardAppearance configureWithDefaultBackground];

    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    [navItem setTitle:@"EMPROVED"];

    UIBarButtonItem *closeButton =  [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                            style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(removeSettingsVC:)];


    closeButton.tintColor = UIColor.redColor;
    _tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    //Set Views
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    navBar.translatesAutoresizingMaskIntoConstraints = NO;
    navBar.translucent = NO;
    navBar.items = @[navItem];
    [navItem setLeftBarButtonItem:closeButton];


    

    //Styles
    self.view.backgroundColor = [UIColor blackColor];
    _tableView.backgroundColor = [UIColor colorWithRed:.149 green:.149 blue:.165 alpha:1];
    _tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    navItem.leftBarButtonItem.tintColor = UIColor.blackColor;
    navBar.standardAppearance.backgroundColor = [UIColor colorWithRed:1 green:.710 blue:.298 alpha:1];

    //SubViews
    [self.view addSubview:navBar];
    [self.view addSubview:_tableView];



    //Constraints
    [navBar.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [navBar.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor].active = YES;
    
    [_tableView.topAnchor constraintEqualToAnchor:navBar.safeAreaLayoutGuide.bottomAnchor].active = YES;
    [_tableView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor].active = YES;
    [_tableView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor].active = YES;
}


-(BOOL)addSettingsButtonForView:(UIView*)view{
    @try {
        UIButton *btn = [[[JDEButtons alloc] init] defaultButton];
        [view addSubview:btn];
        //Constraints
        [btn.topAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.topAnchor constant:10].active = YES;
        [btn.leadingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.leadingAnchor constant:15].active = YES;
        [btn.widthAnchor constraintEqualToAnchor:view.widthAnchor multiplier:0.25].active = YES;

        
        return YES;
    }
    @catch(NSException *exception){
        return NO;
    }
}

-(void)removeSettingsVC:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)switchValueChanged:(UISwitch*)sender{ if (![_settingsManager featureStateChangedTo:sender.on forTag:sender.tag]) {[sender setOn:!sender.on animated:YES];}}

- (void)didTapLocationButton:(UIButton*)sender{



}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [_settingsManager numberOfFeatures]; }

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor colorWithRed:.149 green:.149 blue:.165 alpha:1];

    //Side Toggle
    UISwitch *switchCell = [[UISwitch alloc] init];
    switchCell.onTintColor = [UIColor colorWithRed:1 green:.710 blue:.298 alpha:1];
    [switchCell addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchCell;

    switchCell.tag = [[_settingsManager featureTagForRow:indexPath.row] intValue];
    [switchCell setOn:[_settingsManager featureStateForTag:switchCell.tag] animated:NO];

    //Main Text
    UILabel *featureName = [[UILabel alloc] init];
    featureName.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:featureName];
    featureName.text = [_settingsManager featureNameForRow:indexPath.row];
    featureName.textColor = [UIColor colorWithRed:1 green:.710 blue:.298 alpha:1];
    [featureName.leadingAnchor constraintEqualToAnchor:cell.safeAreaLayoutGuide.leadingAnchor constant:20].active = YES;

    //Sub Text
    UILabel *featureDesc = [[UILabel alloc] init];
    featureDesc.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:featureDesc];
    featureDesc.text = [_settingsManager featureDescriptionForRow:indexPath.row];
    //Style and rePosition
    if(featureDesc.text == nil){[featureName.centerYAnchor constraintEqualToAnchor:cell.safeAreaLayoutGuide.centerYAnchor].active = YES;}
    else{
        [featureName.topAnchor constraintEqualToAnchor:cell.safeAreaLayoutGuide.topAnchor constant:5].active = YES;
        featureDesc.textColor = UIColor.lightGrayColor;
        featureDesc.font = [UIFont systemFontOfSize:13];
        [featureDesc.topAnchor constraintEqualToAnchor:featureName.safeAreaLayoutGuide.bottomAnchor constant:5].active = YES;
        [featureDesc.leadingAnchor constraintEqualToAnchor:cell.safeAreaLayoutGuide.leadingAnchor constant:20].active = YES;
    }

    if(indexPath.row == 2){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:@selector(didTapLocationButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"Set Location" forState:UIControlStateNormal];
        [cell.contentView addSubview:btn];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btn.centerYAnchor constraintEqualToAnchor:cell.safeAreaLayoutGuide.centerYAnchor].active = YES;
        [btn.trailingAnchor constraintEqualToAnchor:cell.contentView.safeAreaLayoutGuide.trailingAnchor constant:-20].active = YES;
    }

    //Disable Buttons
    if([[_settingsManager featureDisabledForRow:indexPath.row] isEqual:@YES]) { cell.contentView.alpha = 0.4; cell.userInteractionEnabled = NO; }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 55;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel *statusMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    statusMessage.text = @"This is still under development.\rReport all bugs to @ExTBH";
    statusMessage.textColor = UIColor.blackColor;
    statusMessage.textAlignment = NSTextAlignmentCenter;
    statusMessage.numberOfLines = 0;
    statusMessage.backgroundColor = [UIColor colorWithRed:1 green:.710 blue:.298 alpha:.9];
    return statusMessage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 0)];
    UILabel *label = [[UILabel alloc] init];
    [view addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @VERSION;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = UIColor.lightGrayColor;

    [label.leadingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.leadingAnchor constant:20].active = YES;
    
    return view;
}

@end