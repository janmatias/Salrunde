//
//  SettingsViewController.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 27/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "SettingsViewController.h"
#import "MyNavController.h"
#import "MainViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *recipientLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipientErrorLabel;
@property (weak, nonatomic) IBOutlet UITextField *recipientTextField;

@property (weak, nonatomic) IBOutlet UITextView *attributionTextView;

@property (strong, nonatomic) NetworkHandler *nh;
@property (strong, nonatomic) NSArray *delphi;
@property (strong, nonatomic) NSArray *skranke;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Setting delegates
	self.recipientTextField.delegate = self;
	self.navigationController.delegate = self;
	
	// Setting color of error label
	self.recipientErrorLabel.textColor = [UIColor redColor];
	
	// Filling text field with saved email, if there is one
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (![((NSString *)[defaults objectForKey:@"defaultRecipient"]) isEqualToString:@""]){
		self.recipientTextField.text = [defaults objectForKey:@"defaultRecipient"];
	}
	
	[self updateUIAccordingToEmail];
	
	// Setting some properties
	self.nh = ((MyNavController *)self.navigationController).nh;
	self.delphi = [self.nh getDelphiRooms];
	self.skranke = [self.nh getSkrankeRooms];
	
	// Setting the attributed text for the attribution of the app icon
	NSString * htmlString = @"<div>App icon made by <a href=\"http://www.simpleicon.com\" title=\"SimpleIcon\">SimpleIcon</a> from <a href=\"http://www.flaticon.com\" title=\"Flaticon\">www.flaticon.com</a> is licensed under <a href=\"http://creativecommons.org/licenses/by/3.0/\" title=\"Creative Commons BY 3.0\">CC BY 3.0</a></div>";
	NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
	self.attributionTextView.attributedText = attrStr;
}

-(BOOL)save
{
	NSString *email = self.recipientTextField.text;
	if ([self IsValidEmail:email]){
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:self.recipientTextField.text forKey:@"defaultRecipient"];
		[defaults synchronize];
		return YES;
	}else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feil!" message:@"Eposten må være gyldig!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		return NO;
	}
}

- (IBAction)updateUIAccordingToEmail {
	if ([self IsValidEmail:self.recipientTextField.text] || [self.recipientTextField.text isEqualToString:@""]){
		[self.navigationItem setHidesBackButton:NO];
		[self.recipientErrorLabel setHidden:YES];
	}else{
		[self.navigationItem setHidesBackButton:YES];
		[self.recipientErrorLabel setHidden:NO];
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Resign first responder on touch outside text field
	[self.recipientTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// If email is valid, resign the first responder (the text field)
	if ([self save]){
		[textField resignFirstResponder];
	}
	return YES;
}

-(BOOL) IsValidEmail:(NSString *)checkString
{
	// regex code found online
	BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
	NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:checkString];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	// Automatically save email on back button pressed
	if ([viewController isKindOfClass:[MainViewController class]]){
		[self save];
		self.navigationController.delegate = nil;
	}
}

@end
