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
    
    //MapView
    _mapView = [MKMapView new];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    //User Location
    _mapView.showsUserLocation = YES;
    
    [self.view addSubview:_mapView];
    [_mapView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
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
    _btn.backgroundColor = [UIColor colorWithRed: 0.98 green: 0.49 blue: 0.05 alpha: 1.00];
    [_btn setTitle:[[JDESettingsManager sharedInstance] localizedStringForKey:@"map_change_location_hint"]  forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _btn.tintColor = UIColor.labelColor;
    _btn.layer.cornerRadius = 9;
    [_mapView addSubview:_btn];
    [_btn.leadingAnchor constraintEqualToAnchor:_mapView.safeAreaLayoutGuide.leadingAnchor constant:20].active = YES;
    [_btn.trailingAnchor constraintEqualToAnchor:_mapView.safeAreaLayoutGuide.trailingAnchor constant:-20].active = YES;
    [_btn.bottomAnchor constraintEqualToAnchor:_mapView.safeAreaLayoutGuide.bottomAnchor constant:-50].active = YES;
    [_btn.heightAnchor constraintEqualToConstant:44].active = YES;
    
    
}

- (void)didTapSwitchButton:(UIButton*)sender{
    [[JDESettingsManager sharedInstance] updateSpoofedLocationWith:_location];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) { return; }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D locationFromTouch = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    _location = [[CLLocation alloc] initWithLatitude:locationFromTouch.latitude longitude:locationFromTouch.longitude];
    
    [objc_getClass("Jodel.AppHaptic") makeHeavyFeedback];
    [[CLGeocoder new] reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark*> *placeMarks, NSError *error){
        if (placeMarks.count > 0) {
            [self->_btn setTitle:[NSString stringWithFormat:@"%@ %@, %@", [[JDESettingsManager sharedInstance]
                                                                            localizedStringForKey:@"map_change_location"],
                                                                            placeMarks[0].administrativeArea,
                                                                            placeMarks[0].country] forState:UIControlStateNormal];
            }
    }
    ];
    _pin.coordinate = locationFromTouch;
    _btn.enabled = YES;
    
}
@end