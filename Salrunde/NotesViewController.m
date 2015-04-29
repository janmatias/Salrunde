//
//  NotesViewController.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 09/04/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "NotesViewController.h"
#import "MainViewController.h"
#import "LocationTableViewController.h"
#import "PrinterViewController.h"
#import "Constants.h"

@interface NotesViewController()

@property (weak, nonatomic) IBOutlet UITextView *notes;

@property (strong, nonatomic) UIBarButtonItem *delete;
@property (strong, nonatomic) UIBarButtonItem *done;
@property (strong, nonatomic) UIBarButtonItem *undo;

@property BOOL resized;

@property CGFloat height;

@end

@implementation NotesViewController


-(void)viewDidLoad
{
	self.title = @"Notater";
	
	self.navigationController.delegate = self;
	self.notes.delegate = self;
	
	[self.notes setContentOffset:CGPointMake(0, 0) animated:NO];
	self.notes.text = [[NSUserDefaults standardUserDefaults] objectForKey:kNotesKey];
	
	self.done = [[UIBarButtonItem alloc] initWithTitle:@"Ferdig" style:UIBarButtonItemStylePlain target:self action:@selector(pressDone)];
	self.undo = [[UIBarButtonItem alloc] initWithTitle:@"Angre" style:UIBarButtonItemStylePlain target:self action:@selector(pressUndo)];
	self.delete = [[UIBarButtonItem alloc] initWithTitle:@"Slett" style:UIBarButtonItemStylePlain target:self action:@selector(pressDelete)];
	self.navigationItem.rightBarButtonItem = self.delete;
	
	self.notes.layer.borderWidth = 1.0f;
	self.notes.layer.borderColor = [[UIColor grayColor] CGColor];
	[self.notes scrollRangeToVisible:NSMakeRange(0, 0)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
	self.resized = NO;
	[self.navigationController setToolbarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)pressDone
{
	[self.notes resignFirstResponder];
	[self save];
	self.navigationItem.rightBarButtonItem = self.delete;
}

-(void)pressDelete
{
	if (![self.notes.text isEqualToString:@""]){
		self.notes.text = @"";
		self.navigationItem.rightBarButtonItem = self.undo;
	}
}

-(void)pressUndo
{
	self.notes.text = [[NSUserDefaults standardUserDefaults] objectForKey:kNotesKey];
	self.navigationItem.rightBarButtonItem = self.delete;
}

-(void)keyboardDidShow:(NSNotification *)not
{
	NSLog(@"Resized: %i", self.resized);
	if (!self.resized){
		self.height = [[not.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height - self.navigationController.toolbar.frame.size.height;
		self.notes.frame = CGRectMake(self.notes.frame.origin.x, self.notes.frame.origin.y, self.notes.frame.size.width, self.notes.frame.size.height - self.height - 50);
		[self.view layoutIfNeeded];
		self.resized = YES;
	}else{
		self.notes.frame = CGRectMake(self.notes.frame.origin.x, self.notes.frame.origin.y, self.notes.frame.size.width, self.notes.frame.size.height + self.height);
		self.height = [[not.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height - self.navigationController.toolbar.frame.size.height;
		self.notes.frame = CGRectMake(self.notes.frame.origin.x, self.notes.frame.origin.y, self.notes.frame.size.width, self.notes.frame.size.height - self.height);
		[self.view layoutIfNeeded];
	}
}

-(void)keyboardWillHide:(NSNotification *)not
{
	if (self.resized){
		self.notes.frame = CGRectMake(self.notes.frame.origin.x, self.notes.frame.origin.y, self.notes.frame.size.width, self.notes.frame.size.height + self.height + 50);
		[self.view layoutIfNeeded];
		self.resized = NO;
	}
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if (![viewController isKindOfClass:[self class]])
	{
		[self save];
		self.navigationController.delegate = nil;
	}
}

-(void)textViewDidBeginEditing:(UITextField *)textField
{
	self.navigationItem.rightBarButtonItem = self.done;
}

-(void)save
{
	[[NSUserDefaults standardUserDefaults] setObject:self.notes.text forKey:kNotesKey];
}

-(BOOL)automaticallyAdjustsScrollViewInsets
{
	return NO;
}
@end
