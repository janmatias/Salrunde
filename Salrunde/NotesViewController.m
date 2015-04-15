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

@interface NotesViewController()

@property (weak, nonatomic) IBOutlet UITextView *notes;

@property (strong, nonatomic) UIBarButtonItem *delete;
@property (strong, nonatomic) UIBarButtonItem *done;
@property (strong, nonatomic) UIBarButtonItem *undo;

@property CGFloat height;

@end

@implementation NotesViewController


-(void)viewDidLoad
{
	self.navigationController.delegate = self;
	self.notes.delegate = self;
	
	[self.notes setContentOffset:CGPointMake(0, 0) animated:NO];
	self.notes.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"notes"];
	
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
	self.notes.text = @"";
	self.navigationItem.rightBarButtonItem = self.undo;
}

-(void)pressUndo
{
	self.notes.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"notes"];
	self.navigationItem.rightBarButtonItem = self.delete;
}

-(void)keyboardDidShow:(NSNotification *)not
{
	self.height = [[not.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height - self.navigationController.toolbar.frame.size.height;
	for (NSLayoutConstraint *con in self.notes.constraints){
		NSLog(@"desc: %@", con.description);
	}
	self.notes.frame = CGRectMake(self.notes.frame.origin.x, self.notes.frame.origin.y, self.notes.frame.size.width, self.notes.frame.size.height - self.height);
	[self.view layoutIfNeeded];
}

-(void)keyboardWillHide:(NSNotification *)not
{
	self.notes.frame = CGRectMake(self.notes.frame.origin.x, self.notes.frame.origin.y, self.notes.frame.size.width, self.notes.frame.size.height + self.height);
	[self.view layoutIfNeeded];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([viewController isKindOfClass:[MainViewController class]] ||
		[viewController isKindOfClass:[LocationTableViewController class]] ||
		[viewController isKindOfClass:[PrinterViewController class]])
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
	[[NSUserDefaults standardUserDefaults] setObject:self.notes.text forKey:@"notes"];
}

-(BOOL)automaticallyAdjustsScrollViewInsets
{
	return NO;
}
@end
