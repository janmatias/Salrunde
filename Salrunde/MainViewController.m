//
//  ViewController.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 19/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "MainViewController.h"
#import "LocationTableViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"Innstillinger" style:UIBarButtonItemStylePlain target:self action:@selector(pressSettings)];
	self.navigationItem.rightBarButtonItem = settings;
	
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void)pressSettings
{
	[self performSegueWithIdentifier:@"showSettings" sender:nil];
}

- (IBAction)showLocation:(UIButton *)sender {
	[self performSegueWithIdentifier:@"showLocation" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"showLocation"]){
		((LocationTableViewController *) segue.destinationViewController).location = ((UIButton *) sender).titleLabel.text;
	}
}

@end
