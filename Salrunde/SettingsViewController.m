//
//  SettingsViewController.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 27/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "SettingsViewController.h"
#import "MyNavController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *recipientLabel;
@property (weak, nonatomic) IBOutlet UITextField *recipientTextField;

@property (weak, nonatomic) IBOutlet UITextView *attributionLabel;

@property (strong, nonatomic) NetworkHandler *nh;
@property (strong, nonatomic) NSArray *delphi;
@property (strong, nonatomic) NSArray *skranke;

@property (weak, nonatomic) IBOutlet UIButton *SaveAllDelphiButton;
@property (weak, nonatomic) IBOutlet UIButton *SaveAllSkrankeButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.recipientTextField.delegate = self;
	
	UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"Lagre" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = close;
	//[self.navigationItem setHidesBackButton:YES];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (![((NSString *)[defaults objectForKey:@"defaultRecipient"]) isEqualToString:@""]){
		self.recipientTextField.text = [defaults objectForKey:@"defaultRecipient"];
	}
	if (![((NSNumber *)[defaults objectForKey:@"DEBUG"]) boolValue]) {
		self.SaveAllDelphiButton.hidden = YES;
		self.SaveAllSkrankeButton.hidden = YES;
	}else{
		self.nh = ((MyNavController *)self.navigationController).nh;
		self.delphi = [self.nh getDelphiRooms];
		self.skranke = [self.nh getSkrankeRooms];
	}
	
	NSString * htmlString = @"<div>App icon made by <a href=\"http://www.simpleicon.com\" title=\"SimpleIcon\">SimpleIcon</a> from <a href=\"http://www.flaticon.com\" title=\"Flaticon\">www.flaticon.com</a> is licensed under <a href=\"http://creativecommons.org/licenses/by/3.0/\" title=\"Creative Commons BY 3.0\">CC BY 3.0</a></div>";
	NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
	
	self.attributionLabel.attributedText = attrStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)save
{
	
	NSString *email = self.recipientTextField.text;
	if ([self IsValidEmail:email]){
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:self.recipientTextField.text forKey:@"defaultRecipient"];
		//[self.navigationController popViewControllerAnimated:YES];
		return YES;
	}else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feil!" message:@"Eposten må være gyldig!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		return NO;
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.recipientTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([self save]){
		[textField resignFirstResponder];
	}
	return YES;
}

-(BOOL) IsValidEmail:(NSString *)checkString
{
	BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
	NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:checkString];
}

- (IBAction)saveAll:(UIButton *)sender {
	
	if ([sender.titleLabel.text isEqualToString:@"Save All Delphi"]){
		[self saveLoc:self.delphi];
	}else if ([sender.titleLabel.text isEqualToString:@"Save All Skranke"]){
		[self saveLoc:self.skranke];
	}
}

-(void)saveLoc:(NSArray *)rooms
{
	for (Room *r in rooms){
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		if ([((NSDate *)[defaults objectForKey: [NSString stringWithFormat:@"%@_date", r.name]]) timeIntervalSinceNow] < 86400) {
			continue;
		}
		[defaults setObject:[NSDate date] forKey:[NSString stringWithFormat: @"%@_date", r.name]];
		if (r.A4){
			[defaults setObject:@"2-4" forKey:[NSString stringWithFormat: @"%@_A4", r.name]];
		}
		if (r.svart) {
			[defaults setObject:@"42" forKey:[NSString stringWithFormat: @"%@_black", r.name]];
		}
		if (r.kortleser){
			[defaults setObject:@1 forKey:[NSString stringWithFormat: @"%@_kortleser", r.name]];
		}
		if ([r.name isEqualToString:@"Real. Bib."]) {
			[defaults setObject:@1 forKey:[NSString stringWithFormat: @"%@_extra", r.name]];
		}
		if (r.A3) {
			[defaults setObject:@"2-4" forKey:[NSString stringWithFormat: @"%@_A3", r.name]];
		}
		if (r.farge){
			[defaults setObject:@"42" forKey:[NSString stringWithFormat: @"%@_cyan", r.name]];
			[defaults setObject:@"42" forKey:[NSString stringWithFormat: @"%@_magenta", r.name]];
			[defaults setObject:@"42" forKey:[NSString stringWithFormat: @"%@_yellow", r.name]];
		}
		
		[defaults setObject:@"This is a comment" forKey:[NSString stringWithFormat: @"%@_kommentar", r.name]];
		
		[defaults synchronize];
		
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
