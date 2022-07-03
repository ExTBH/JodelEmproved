#import "JDEViewController.h"


// Private declarations; this class only.
@interface JDEViewController()  <UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSDictionary *config;
@property (strong,nonatomic) NSDictionary *sections;
@property (strong,nonatomic) NSArray *generalSection;
@end

@implementation JDEViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    NSBundle *mainBundle = [NSBundle bundleWithPath:@PATH];
    NSString *configPath = [mainBundle pathForResource:@"config" ofType:@"json"];
    if (configPath == nil){
        return;
    }
    _config = [self dictFromFile:configPath];
    _sections = [_config objectForKey:@"sections"];
    _generalSection = [_sections objectForKey:@"General"];


    
    
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

-(void)removeSettingsVC:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)switchValueChanged:(UISwitch*)sender{

    #define CASE(str)  if ([__s__ isEqualToString:(str)]) 
    #define SWITCH(s)  for (NSString *__s__ = (s); ; )
    #define DEFAULT  

    SWITCH (sender.accessibilityLabel) {
        CASE (@"save_images") {
            break;
        }
        CASE (@"upload_images") {
            break;
        }
        CASE (@"spoof_loc") {
            break;
        }
        CASE (@"copy_paste") {
            break;
        }
        CASE (@"confirm_vote") {
            break;
        }
        CASE (@"confirm_reply") {
            break;
        }
        CASE (@"anti_screenshot") {
            break;
        }
        CASE (@"anti_track") {
            break;
        }
        DEFAULT {
            break;
        }
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

        
        return YES;
    }
    @catch(NSException *exception){
        return NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}

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
    
    if(indexPath.section == 0){
        NSDictionary *row = _generalSection[indexPath.row];
        NSString *tag = row[@"tag"];
        NSNumber *isDisabled = row[@"disabled"];
        NSLog(@"JDELogs isDisabled %@", isDisabled);
        cell.textLabel.text = row[@"name"];
        switchCell.accessibilityLabel = row[@"tag"];
        cell.tag = [tag intValue];
        if([isDisabled boolValue]){
            cell.contentView.alpha = 0.4;
            cell.userInteractionEnabled = NO;
        }
        if([[row objectForKey:@"default"] boolValue]){
            [switchCell setOn:YES animated:NO];
        }

    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = [_generalSection count];
            break;
    }
    return rows;
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