@interface JDLMainFeedNavigationController : UINavigationController
@property(nonatomic, readonly) UINavigationBar *navigationBar;
@property(nonatomic, readonly, strong) UINavigationItem *navigationItem;
-(void)viewDidLoad;
-(id)initWithRootViewController:(UIViewController *)rootViewController;
-(void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end