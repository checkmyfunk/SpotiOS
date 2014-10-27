//
//  ViewController.m
//  SpotiOS
//
//  Created by Vitali Potchekin on 9/14/14.
//  Copyright (c) 2014 Vitali Potchekin. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *parkingSigns;

-(void)loadData;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"ParkData.db"];
    [self loadData];
    
    _mapView.delegate = self;
    _locationManager.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    //show user location
    _mapView.showsUserLocation = YES;
    
}


- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 2000, 2000);
    [_mapView setRegion:region animated:NO];
}

//follow user's location
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//load data from db

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from signs";
    
    // Get the results.
    if (self.parkingSigns != nil) {
        self.parkingSigns = nil;
    }
    self.parkingSigns = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"The content of arry is%@", self.parkingSigns);
}

@end
