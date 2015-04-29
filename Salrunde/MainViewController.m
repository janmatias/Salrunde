//
//  ViewController.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 19/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "MainViewController.h"
#import "LocationTableViewController.h"

@implementation MainViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"Innstillinger" style:UIBarButtonItemStylePlain target:self action:@selector(pressSettings)];
	self.navigationItem.rightBarButtonItem = settings;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNotes)];
	[self.navigationController.toolbar addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setToolbarHidden:NO];
}

-(void)pressSettings
{
	[self performSegueWithIdentifier:@"showSettings" sender:nil];
}

-(void)showNotes
{
	[self performSegueWithIdentifier:@"showNotes" sender:nil];
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
