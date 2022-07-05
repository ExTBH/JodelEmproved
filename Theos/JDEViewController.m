#import "JDEViewController.h"


// Private declarations; this class only.
@interface JDEViewController()  <UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) JDESettingsManager *settingsManager;
@end

@implementation JDEViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _settingsManager = [[JDESettingsManager alloc] init];
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (NSDictionary*)dictFromFile:(NSString*)filePath{

    NSData *data = [NSData dataWithContentsOfFile:filePath];

    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [_settingsManager numberOfFeatures]; }

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor colorWithRed:.149 green:.149 blue:.165 alpha:1];
    cell.textLabel.textColor = [UIColor colorWithRed:1 green:.710 blue:.298 alpha:1];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    UISwitch *switchCell = [[UISwitch alloc] init];
    switchCell.onTintColor = [UIColor colorWithRed:1 green:.710 blue:.298 alpha:1];
    [switchCell addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchCell;
    // Disabling swithces
    // cell.contentView.alpha = 0.4;
    // cell.userInteractionEnabled = NO;

    cell.textLabel.text = [_settingsManager featureNameForRow:indexPath.row];
    switchCell.tag = [[_settingsManager featureTagForRow:indexPath.row] intValue];
    [switchCell setOn:[_settingsManager featureStateForTag:indexPath.row] animated:NO];


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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
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