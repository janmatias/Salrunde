//
//  PrinterViewController.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 19/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "PrinterViewController.h"
#import "LocationTableViewController.h"
#import "MapViewController.h"

@interface PrinterViewController ()

@property (nonatomic) CGPoint originalCenter;

@property (weak, nonatomic) IBOutlet UISwitch *kortleserSwitch;
@property (weak, nonatomic) IBOutlet UILabel *kortleserLabel;

@property (weak, nonatomic) IBOutlet UILabel *extraLabel;
@property (weak, nonatomic) IBOutlet UISwitch *extraSwitch;

@property (weak, nonatomic) IBOutlet UISlider *blackSlider;
@property (weak, nonatomic) IBOutlet UITextField *blackTextField;

@property (weak, nonatomic) IBOutlet UILabel *cyanLabel;
@property (weak, nonatomic) IBOutlet UISlider *cyanSlider;
@property (weak, nonatomic) IBOutlet UITextField *cyanTextField;

@property (weak, nonatomic) IBOutlet UILabel *magentaLabel;
@property (weak, nonatomic) IBOutlet UISlider *magentaSlider;
@property (weak, nonatomic) IBOutlet UITextField *magentaTextField;

@property (weak, nonatomic) IBOutlet UILabel *yellowLabel;
@property (weak, nonatomic) IBOutlet UISlider *yellowSlider;
@property (weak, nonatomic) IBOutlet UITextField *yellowTextField;

@property (weak, nonatomic) IBOutlet UILabel *A4Label;
@property (weak, nonatomic) IBOutlet UITextField *A4TextField;

@property (weak, nonatomic) IBOutlet UILabel *A3Label;
@property (weak, nonatomic) IBOutlet UITextField *A3TextField;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (strong, nonatomic) UITextField *selectedTextField;
@property (strong, nonatomic) NSArray *currentArray;

@property (nonatomic) BOOL kortleser;
@property (nonatomic) BOOL svart;
@property (nonatomic) BOOL farge;
@property (nonatomic) BOOL A3;
@property (nonatomic) BOOL A4;
@property (nonatomic) BOOL lager;

@property (strong, nonatomic) NSArray *lagerTonerValues;
@property (strong, nonatomic) NSArray *lagerPaperValues;
@property (strong, nonatomic) NSArray *printerPaperValues;
@property (strong, nonatomic) NSMutableArray *printerTonerValues;
@property (strong, nonatomic) NSArray *textFields;


@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) UIToolbar *inputAccessoryToolbar;

@end

@implementation PrinterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (!self.room.tynnklient){
		UIBarButtonItem *map = [[UIBarButtonItem alloc] initWithTitle:@"Kart" style:UIBarButtonItemStylePlain target:self action:@selector(showMap)];
		self.navigationItem.rightBarButtonItem = map;
	}
	
	[self setProperties];
	
	[self setUpPicker];
	[self setUpAccessoryToolbar];
	[self setUpTextFields];
	
	[self iterateOverOptions]; // Hide the correct fields according to what the printer has
	
	[self setTextFields]; // Sets default text in the text fields
	[self syncWithUserDefaults]; // Sets last saved data in the fields
}

-(void)setProperties
{
	self.navigationController.delegate = self;
	self.title = self.room.name;
	
	self.kortleser = self.room.kortleser;
	self.farge = self.room.farge;
	self.svart = self.room.svart;
	self.A3 = self.room.A3;
	self.A4 = self.room.A4;
	self.lager = self.room.lager;
	self.originalCenter = self.view.center;
	self.textFields = [NSArray arrayWithObjects:self.A4TextField, self.A3TextField, self.blackTextField, self.cyanTextField, self.magentaTextField, self.yellowTextField, nil];
	self.lagerPaperValues = [NSArray arrayWithObjects:@"<10", @"10-20", @"20+", nil];
	self.printerPaperValues = [NSArray arrayWithObjects:@"0", @"<2", @"2-4", @"5-20", @"20+", nil];
	self.lagerTonerValues = [NSArray arrayWithObjects:@"0", @"<2", @"2-4", @"5-20", @"20+", nil];
	self.printerTonerValues = [[NSMutableArray alloc] init];
	for (int i = 0; i<101; i++) {
		[self.printerTonerValues addObject:[NSString stringWithFormat:@"%i%%", i]];
	}
}

#pragma mark Picker View Methods

-(void)setUpPicker
{
	self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/4)];
	self.picker.delegate = self;
	self.picker.dataSource = self;
	[self.picker setShowsSelectionIndicator:YES];
}

-(void)setUpAccessoryToolbar{
	self.inputAccessoryToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/8)];
	self.inputAccessoryToolbar.barStyle = UIBarStyleDefault;
	[self.inputAccessoryToolbar sizeToFit];
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	[barItems addObject:flexSpace];
	
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignFirstResponders)];
	[barItems addObject:doneBtn];
	
	[self.inputAccessoryToolbar setItems:barItems animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [self.currentArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [self.currentArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	self.selectedTextField.text = [self.currentArray objectAtIndex:row];
}

#pragma mark Slider Methods

- (IBAction)sliderChanged:(UISlider *)sender {
	
	if ([sender isEqual:self.blackSlider]) {
		self.blackTextField.text = [NSString stringWithFormat:@"%i%%", (int)round(sender.value)];
	}else if ([sender isEqual:self.cyanSlider]){
		self.cyanTextField.text = [NSString stringWithFormat:@"%i%%", (int)round(sender.value)];
	}else if ([sender isEqual:self.magentaSlider]){
		self.magentaTextField.text = [NSString stringWithFormat:@"%i%%", (int)round(sender.value)];
	}else if ([sender isEqual:self.yellowSlider]){
		self.yellowTextField.text = [NSString stringWithFormat:@"%i%%", (int)round(sender.value)];
	}
}

#pragma mark TextField/TextView Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	self.selectedTextField = textField;
	
	if (self.lager) {
		if (textField == self.A4TextField || textField == self.A3TextField){
			self.currentArray = self.lagerPaperValues;
			[self.picker reloadAllComponents];
			return YES;
		}else{
			self.currentArray = self.lagerTonerValues;
			[self.picker reloadAllComponents];
			return YES;
		}
	}else{
		if (textField == self.A4TextField || textField == self.A3TextField){
			self.currentArray = self.printerPaperValues;
			[self.picker reloadAllComponents];
			return YES;
		}else{
			self.currentArray = self.printerTonerValues;
			[self.picker reloadAllComponents];
			return YES;
		}
	}
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
	[UIView animateWithDuration:0.2 animations:^{
		int goal = self.view.frame.size.height/2.5;
		int posInView = textView.center.y;
		int move =  goal - posInView;
		
		self.view.center = CGPointMake(self.view.center.x, self.view.center.y + move);
	}];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
	[UIView animateWithDuration:0.2 animations:^{
	 self.view.center = self.originalCenter;
	}];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	int index;
	for (int i = 0; i < [self.currentArray count]; i++) {
		if ([textField.text isEqual:[self.currentArray objectAtIndex:i]]){
			index = i;
			break;
		}
	}
	[self.picker selectRow:index inComponent:0 animated:YES];
	
	[UIView animateWithDuration:0.2 animations:^{
		int goal = self.view.frame.size.height/3.5;
		int posInView = textField.center.y;
		int move =  goal - posInView;
		
		self.view.center = CGPointMake(self.view.center.x, self.view.center.y + move);
	}];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
	[UIView animateWithDuration:0.2 animations:^{
	 self.view.center = self.originalCenter;
	}];
	if (self.lager) return;
	
	if (textField == self.blackTextField){
		self.blackSlider.value = [[textField.text stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue];
	}else if (textField == self.cyanTextField){
		self.cyanSlider.value = [[textField.text stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue];
	}else if (textField == self.magentaTextField){
		self.magentaSlider.value = [[textField.text stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue];
	}else if (textField == self.yellowTextField){
		self.yellowSlider.value = [[textField.text stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue];
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark Helping Methods

-(void)setTextFields
{
	NSString *def;
	NSString *def2;
	if (self.lager){
		def = [self.lagerTonerValues objectAtIndex:2];
		def2 = [self.lagerPaperValues objectAtIndex:2];
	}else{
		def = @"50%";
		def2 = [self.printerPaperValues objectAtIndex:2];
	}
	
	if ([self.blackTextField.text  isEqual: @""]){
		self.blackTextField.text = def;
	}
	if ([self.cyanTextField.text  isEqual: @""]){
		self.cyanTextField.text = def;
	}
	if ([self.magentaTextField.text  isEqual: @""]){
		self.magentaTextField.text = def;
	}
	if ([self.yellowTextField.text  isEqual: @""]){
		self.yellowTextField.text = def;
	}
	if ([self.A4TextField.text  isEqual: @""]){
		self.A4TextField.text = def2;
	}
	if ([self.A3TextField.text  isEqual: @""]){
		self.A3TextField.text = def2;
	}
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self resignFirstResponders];
}

-(void)setUpTextFields
{
	for (UITextField *textField in self.textFields){
		if (self.lager){
			textField.delegate = self;
			textField.inputView = self.picker;
			textField.inputAccessoryView = self.inputAccessoryToolbar;
		}else{
			if (textField == self.A3TextField || textField == self.A4TextField) {
				textField.delegate = self;
				textField.inputView = self.picker;
				textField.inputAccessoryView = self.inputAccessoryToolbar;
			}else{
				textField.delegate = self;
				textField.inputView = self.picker;
				textField.inputAccessoryView = self.inputAccessoryToolbar;
			}
		}
	}
	
	self.commentTextView.delegate = self;
	self.commentTextView.inputAccessoryView = self.inputAccessoryToolbar;
	self.commentTextView.layer.borderWidth = 2.0f;
	self.commentTextView.layer.borderColor = [[UIColor grayColor] CGColor];
}

-(void)iterateOverOptions
{
	
	if ([self.room.name isEqualToString:@"Real. Bib."]) {
		self.extraLabel.text = @"reapub";
		[self.extraLabel setHidden:NO];
		[self.extraSwitch setHidden:NO];
	}
	
	if ([self.room.name isEqualToString:@"Sahara"] && [self.commentTextView.text isEqualToString:@""]){
		self.commentTextView.text = @"Alt OK!";
	}
	
	if (self.lager){
		self.cyanSlider.enabled = NO;
		self.magentaSlider.enabled = NO;
		self.blackSlider.enabled = NO;
		self.yellowSlider.enabled = NO;
		self.kortleserSwitch.hidden = YES;
		self.kortleserLabel.hidden = YES;
		
		if (!self.A3){
			self.A3Label.hidden = YES;
			self.A3TextField.hidden = YES;
		}
		
	}else{
		if (!self.kortleser){
			self.kortleserSwitch.hidden = YES;
			self.kortleserLabel.hidden = YES;
		}
		if (!self.svart) {
			self.blackSlider.enabled = NO;
			self.blackTextField.hidden = YES;
		}
		if (!self.farge) {
			if (self.room.xero){
				self.cyanLabel.text = @"Xerographic module";
			}else{
				self.cyanLabel.hidden = YES;
				self.cyanSlider.hidden = YES;
				self.cyanTextField.hidden = YES;
			}
			if (self.room.fuser){
				self.magentaLabel.text = @"Fuser module";
			}else{
				self.magentaLabel.hidden = YES;
				self.magentaSlider.hidden = YES;
				self.magentaTextField.hidden = YES;
			}
			self.yellowLabel.hidden = YES;
			self.yellowSlider.hidden = YES;
			self.yellowTextField.hidden = YES;
		}
		if (!self.A3){
			self.A3Label.hidden = YES;
			self.A3TextField.hidden = YES;
		}
		if (!self.A4){
			self.A4Label.hidden = YES;
			self.A4TextField.hidden = YES;
		}
	}
}

-(void)resignFirstResponders
{
	if ([self.commentTextView isFirstResponder]){
		[self.commentTextView resignFirstResponder];
		return;
	}
	for (UITextField *textField in self.textFields){
		if ([textField isFirstResponder]){
			[textField resignFirstResponder];
			return;
		}
	}
}

-(void)showMap
{
	[self performSegueWithIdentifier:@"showMap" sender:nil];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([viewController isKindOfClass:[LocationTableViewController class]]){
		[self save];
		self.navigationController.delegate = nil;
	}
}

#pragma mark Save/Load metods

-(void)syncWithUserDefaults // load
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *prosent = @"";
	if (!self.lager){
		prosent = @"%";
	}
	
	if (![defaults objectForKey:[NSString stringWithFormat:@"%@_date", self.name]]){
		return;
	}
	if (self.A4){
		self.A4TextField.text = ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_A4", self.name]]);
	}
	if (self.svart){
			self.blackSlider.value = [((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_black", self.name]]) intValue];
		self.blackTextField.text = [NSString stringWithFormat: @"%@%@", ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_black", self.name]]), prosent];
	}
	if (self.kortleser){
		self.kortleserSwitch.on = [((NSNumber *)[defaults objectForKey:[NSString stringWithFormat:@"%@_kortleser", self.name]]) boolValue];
	}
	
	if ([self.room.name isEqualToString:@"Real. Bib."]) {
		self.extraSwitch.on = [((NSNumber *)[defaults objectForKey:[NSString stringWithFormat:@"%@_extra", self.name]]) boolValue];
	}
	
	if (self.A3){
		self.A3TextField.text = ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_A3", self.name]]);
	}
	
	if (self.farge) {
		self.cyanSlider.value = [((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_cyan", self.name]]) intValue];
		self.cyanTextField.text = [NSString stringWithFormat: @"%@%@", ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_cyan", self.name]]), prosent];
		
		self.magentaSlider.value = [((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_magenta", self.name]]) intValue];
		self.magentaTextField.text = [NSString stringWithFormat: @"%@%@", ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_magenta", self.name]]), prosent];
		
		self.yellowSlider.value = [((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_yellow", self.name]]) intValue];
		self.yellowTextField.text = [NSString stringWithFormat: @"%@%@", ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_yellow", self.name]]), prosent];
	}else{
		if (self.room.xero){
			self.cyanSlider.value = [((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_xero", self.name]]) intValue];
			self.cyanTextField.text = [NSString stringWithFormat: @"%@%@", ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_xero", self.name]]), prosent];
		}
		if (self.room.fuser){
			self.magentaSlider.value = [((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_fuser", self.name]]) intValue];
			self.magentaTextField.text = [NSString stringWithFormat: @"%@%@", ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_fuser", self.name]]), prosent];
		}
	}
	// if comment added less than a day ago
	if ( [[NSDate date] timeIntervalSinceDate:((NSDate *)[defaults objectForKey:[NSString stringWithFormat:@"%@_date", self.name]])] < 86400){
		self.commentTextView.text = [defaults objectForKey:[NSString stringWithFormat:@"%@_kommentar", self.name]];
	}
}

-(void)save
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSDate date] forKey:[NSString stringWithFormat: @"%@_date", self.name]];
	if (self.kortleser){
		[defaults setObject:[NSNumber numberWithBool:self.kortleserSwitch.on] forKey:[NSString stringWithFormat: @"%@_kortleser", self.name]];
	}
	if ([self.room.name isEqualToString:@"Real. Bib."]) {
		[defaults setObject:[NSNumber numberWithBool:self.extraSwitch.on] forKey:[NSString stringWithFormat: @"%@_extra", self.name]];
	}
	if (self.A3) {
		[defaults setObject:self.A3TextField.text forKey:[NSString stringWithFormat: @"%@_A3", self.name]];
	}
	if (self.A4){
		[defaults setObject:self.A4TextField.text forKey:[NSString stringWithFormat: @"%@_A4", self.name]];
	}
	if (self.svart){
		[defaults setObject:[self.blackTextField.text stringByReplacingOccurrencesOfString:@"%" withString:@""] forKey:[NSString stringWithFormat: @"%@_black", self.name]];
	}
	if (self.farge){
		[defaults setObject:[self.cyanTextField.text stringByReplacingOccurrencesOfString:@"%" withString:@""] forKey:[NSString stringWithFormat: @"%@_cyan", self.name]];
		[defaults setObject:[self.magentaTextField.text stringByReplacingOccurrencesOfString:@"%" withString:@""] forKey:[NSString stringWithFormat: @"%@_magenta", self.name]];
		[defaults setObject:[self.yellowTextField.text stringByReplacingOccurrencesOfString:@"%" withString:@""] forKey:[NSString stringWithFormat: @"%@_yellow", self.name]];
	}else{
		if (self.room.xero){
			[defaults setObject:[self.cyanTextField.text stringByReplacingOccurrencesOfString:@"%" withString:@""] forKey:[NSString stringWithFormat: @"%@_xero", self.name]];
		}
		if (self.room.fuser){
			[defaults setObject:[self.magentaTextField.text stringByReplacingOccurrencesOfString:@"%" withString:@""] forKey:[NSString stringWithFormat: @"%@_fuser", self.name]];
		}
	}
	
	[defaults setObject:self.commentTextView.text forKey:[NSString stringWithFormat: @"%@_kommentar", self.name]];
	
	[defaults synchronize];
	NSLog(@"Saved room: %@", self.room.name);
	
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showMap"]){
		NSLog(@"showMapForRoom: %@", self.room.name);
		MapViewController *next = ((MapViewController *)[segue destinationViewController]);
		next.useLLF = self.room.useLLF;
		if (next.useLLF) {
			next.latitude = self.room.latitude;
			next.longitude = self.room.longitude;
			next.floor = self.room.floor;
		}else{
			next.ID = self.room.ID;
		}
	}
}

@end
