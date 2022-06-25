#import "JDEViewController.h"


// Private declarations; this class only.
@interface JDEViewController()  <UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>
@property(strong,nonatomic) UITableView *tableView;
@end

@implementation JDEViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
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

-(void)removeSettingsVC:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)switchValueChanged:(UISwitch*)sender{

    NSLog(@"JDELogs");
    
    switch (sender.tag) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            break;
    }
    
}

-(BOOL)addSettingsButtonForView:(UIView*)view{
    @try {
        UIButton *btn = [[[JDEButtons alloc] init] defaultButton];
        [view addSubview:btn];
        //Constraints
        [btn.topAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.topAnchor constant:10].active = YES;
        [btn.leadingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.leadingAnchor constant:15].active = YES;
        [btn.widthAnchor constraintEqualToAnchor:view.widthAnchor multiplier:0.25].active = YES;

        
        NSLog(@"JDELogs try YES\n%s ", __PRETTY_FUNCTION__);
        return YES;
    }
    @catch(NSException *exception){
        NSLog(@"JDELogs catch YES\n%s ", __PRETTY_FUNCTION__);
        return NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor colorWithRed:.149 green:.149 blue:.165 alpha:1];
    cell.textLabel.text = @"Download Images";
    cell.textLabel.textColor = [UIColor colorWithRed:1 green:.710 blue:.298 alpha:1];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    UISwitch *switchCell = [[UISwitch alloc] init];
    switchCell.onTintColor = [UIColor colorWithRed:1 green:.710 blue:.298 alpha:1];
    switchCell.accessibilityIdentifier = @"seve_images";
    [switchCell addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchCell;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Fake Karma";
            switchCell.accessibilityIdentifier = @"spoofed_karma";
            break;
        case 1:
            cell.textLabel.text = @"Download Images";
            switchCell.accessibilityIdentifier = @"save_posts";
            break;
        case 2:
            cell.textLabel.text = @"Screenshot Protection";
            switchCell.accessibilityIdentifier = @"disable_screenshot";
            break;

    }

    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *footer = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footer"];
    
    
    footer.textLabel.text = @"Jodel EMPROVED By ExT (1.0.0 ALPHA)";
    footer.textLabel.textColor = UIColor.lightGrayColor;
    footer.textLabel.textAlignment = NSTextAlignmentLeft;
    footer.textLabel.font = [UIFont systemFontOfSize:10];
    
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"\tJodel EMPROVED By @ExT_BH (1.0.0)"];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:[UIColor lightGrayColor]];
    
    return label;
}

@end