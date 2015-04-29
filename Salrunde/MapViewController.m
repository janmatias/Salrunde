//
//  MapViewController.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 29/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) CLLocationManager *locMan;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation MapViewController

-(void)viewWillDisappear:(BOOL)animated
{
	self.webView.delegate = nil;
	[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)viewWillAppear:(BOOL)animated
{
	self.title = @"Kart";
	[self.navigationController setToolbarHidden:YES];
	self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	self.webView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
	self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.spinner.center = self.view.center;
	[self.spinner startAnimating];
	[self.view addSubview:self.spinner];
	[self setUpMap];
}

-(void) setUpMap
{
	NSString *urlAddress = [self getURLAsString];
	NSURL *url = [[NSURL alloc] initWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[self.webView loadRequest:requestObj];
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
	
	NSLog(@"Map show content for URL: %@", url);
	return url;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
	[self.view addSubview:self.webView];
	[self.spinner stopAnimating];
	[self.spinner removeFromSuperview];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	NSLog(@"Error loading page!");
}
@end
