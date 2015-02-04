//
//  MapViewController.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 29/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <CLLocationManagerDelegate>

//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) CLLocationManager *locMan;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) BOOL canAccesLocation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.canAccesLocation = NO;
	self.locMan = [[CLLocationManager alloc] init];
	self.locMan.delegate = self;
	self.locMan.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	self.locMan.distanceFilter = 10;
}

-(void)viewWillDisappear:(BOOL)animated
{
	[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)viewWillAppear:(BOOL)animated
{
	self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)viewDidAppear:(BOOL)animated
{
	[self setUpLocationHandling];
	[self setUpMap];
}

-(void) setUpMap
{
	NSString *urlAddress = [self getURLAsString];
	NSURL *url = [[NSURL alloc] initWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[self.webView loadRequest:requestObj];
	[self.view addSubview:self.webView];
}

-(void)updateMap
{
	NSString *urlAddress = [self getURLAsString];
	NSURL *url = [[NSURL alloc] initWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[self.webView loadRequest:requestObj];
}

-(NSString *)getURLAsString
{
	NSMutableString *url = [NSMutableString stringWithString: @"http://use.mazemap.com/?"];
	
	NSString *campus = [@(1) stringValue];
	[url appendString:[NSString stringWithFormat:@"campusid=%@", campus]];
	
	if (self.useLLF) {
		[url appendString:[NSString stringWithFormat:@"&sharepoitype=pointinside&sharepoi=%@,%@,%@", self.latitude, self.longitude, self.floor]];
	}else{
		[url appendString:[NSString stringWithFormat:@"&desttype=poi&dest=%@", self.ID]];
	}
	
	if (self.canAccesLocation) {
		[url appendString:[NSString stringWithFormat:@"&starttype=point&start=%f,%fl", self.coordinate.latitude, self.coordinate.longitude]];
	}
	NSLog(@"Map show content for URL: %@", url);
	return url;
}

-(void)setUpLocationHandling
{
	switch ([CLLocationManager authorizationStatus]) {
		case kCLAuthorizationStatusNotDetermined:
			[self.locMan requestWhenInUseAuthorization];
			break;
		case kCLAuthorizationStatusDenied:
			//[self showNoLocationAlert];
			break;
		default:
			break;
	}
	
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	if (status == kCLAuthorizationStatusAuthorizedWhenInUse){
		self.canAccesLocation = YES;
		[self.locMan startUpdatingLocation];
	}
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	self.coordinate = ((CLLocation *)[locations lastObject]).coordinate;
	[self updateMap];
}

-(void)showNoLocationAlert
{
	
}
@end
