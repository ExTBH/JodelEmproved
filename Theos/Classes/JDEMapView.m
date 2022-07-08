//
//  JDEMapView.m
//  MapKit
//
//  Created by Natheer on 08/07/2022.
//

#import "JDEMapView.h"

@interface JDEMapView ()
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKPointAnnotation *pin;
@property (strong, nonatomic) UIButton *btn;
@property (strong, nonatomic) CLLocation *location;
@end

@implementation JDEMapView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.darkGrayColor;    
    //NavigatioBar
    UINavigationBar *navigatioBar = [UINavigationBar new];
    navigatioBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:navigatioBar];
    [navigatioBar.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor].active = YES;
    
    navigatioBar.standardAppearance = [UINavigationBarAppearance new];
    [navigatioBar.standardAppearance configureWithDefaultBackground];
    navigatioBar.standardAppearance.backgroundColor = UIColor.blackColor;
    navigatioBar.standardAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    //NavigationBar Items
    UINavigationItem *navigationBarItem = [[UINavigationItem alloc] initWithTitle:@"Location Spoofer"];
    navigationBarItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(didTapDismissButton:)];
    
    navigatioBar.items = @[navigationBarItem];
    
    //MapView
    _mapView = [MKMapView new];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    //User Location
    _mapView.showsUserLocation = YES;
    
    [self.view addSubview:_mapView];
    [_mapView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:50].active = YES;
    [_mapView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [_mapView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [_mapView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    
    
    //Press detection
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    lpgr.minimumPressDuration = 1;
    [_mapView addGestureRecognizer:lpgr];
    //add pin at 0, 0
    _pin = [MKPointAnnotation new];
    [_mapView addAnnotation:_pin];
    
    //Overlay Button
    _btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btn addTarget:self action:@selector(didTapSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
    _btn.enabled = NO;
    _btn.translatesAutoresizingMaskIntoConstraints = NO;
    _btn.backgroundColor = [UIColor colorWithRed:1 green:.710 blue:.298 alpha:1];
    [_btn setTitle:@"Set Location To" forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _btn.tintColor = UIColor.blackColor;
    _btn.layer.cornerRadius = 9;
    [_mapView addSubview:_btn];
    [_btn.leadingAnchor constraintEqualToAnchor:_mapView.safeAreaLayoutGuide.leadingAnchor constant:20].active = YES;
    [_btn.trailingAnchor constraintEqualToAnchor:_mapView.safeAreaLayoutGuide.trailingAnchor constant:-20].active = YES;
    [_btn.bottomAnchor constraintEqualToAnchor:_mapView.safeAreaLayoutGuide.bottomAnchor constant:-50].active = YES;
    [_btn.heightAnchor constraintEqualToConstant:44].active = YES;
    
    
}

- (void)didTapDismissButton:(UIBarButtonItem*)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didTapSwitchButton:(UIButton*)sender{
    [[JDESettingsManager sharedInstance] updateSpoofedLocationWith:_location];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) { return; }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D locationFromTouch = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    _location = [[CLLocation alloc] initWithLatitude:locationFromTouch.latitude longitude:locationFromTouch.longitude];
    
    [objc_getClass("Jodel.AppHaptic") makeHeavyFeedback];
    [[CLGeocoder new] reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark*> *placeMarks, NSError *error){
        if (placeMarks.count > 0) {
            [self->_btn setTitle:[NSString stringWithFormat:@"Set Location To %@, %@",placeMarks[0].administrativeArea, placeMarks[0].country] forState:UIControlStateNormal];
            }
    }
    ];
    _pin.coordinate = locationFromTouch;
    _btn.enabled = YES;
    
}
@end