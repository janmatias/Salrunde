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

@property (weak, nonatomic) IBOutlet UISwitch *cardReaderSwitch;
@property (weak, nonatomic) IBOutlet UILabel *cardReaderLabel;

@property (weak, nonatomic) IBOutlet UILabel *extraLabel;
@property (weak, nonatomic) IBOutlet UISwitch *extraSwitch;

@property (weak, nonatomic) IBOutlet UILabel *blackLabel;
@property (weak, nonatomic) IBOutlet UITextField *blackTextField;

@property (weak, nonatomic) IBOutlet UILabel *cyanLabel;
@property (weak, nonatomic) IBOutlet UITextField *cyanTextField;

@property (weak, nonatomic) IBOutlet UILabel *magentaLabel;
@property (weak, nonatomic) IBOutlet UITextField *magentaTextField;

@property (weak, nonatomic) IBOutlet UILabel *yellowLabel;
@property (weak, nonatomic) IBOutlet UITextField *yellowTextField;

@property (weak, nonatomic) IBOutlet UILabel *A4Label;
@property (weak, nonatomic) IBOutlet UITextField *A4TextField;

@property (weak, nonatomic) IBOutlet UILabel *A3Label;
@property (weak, nonatomic) IBOutlet UITextField *A3TextField;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (strong, nonatomic) UITextField *selectedTextField;
@property (strong, nonatomic) NSArray *currentArray;

@property (nonatomic) BOOL cardReader;
@property (nonatomic) BOOL black;
@property (nonatomic) BOOL color;
@property (nonatomic) BOOL A3;
@property (nonatomic) BOOL A4;
@property (nonatomic) BOOL storageUnit;

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
	
	// currently under testing
	[self setUpWithAutoLayout:[self createDictionaryForAL]];
	// Back to normal
	
	
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
	
	self.cardReader = self.room.kortleser;
	self.color = self.room.farge;
	self.black = self.room.svart;
	self.A3 = self.room.A3;
	self.A4 = self.room.A4;
	self.storageUnit = self.room.lager;
	self.originalCenter = self.view.center;
	self.textFields = [NSArray arrayWithObjects:self.A4TextField, self.A3TextField, self.blackTextField, self.cyanTextField, self.magentaTextField, self.yellowTextField, nil];
	self.lagerPaperValues = [NSArray arrayWithObjects:@"<10", @"10-20", @"20+", nil];
	self.printerPaperValues = [NSArray arrayWithObjects:@"0", @"<2", @"2-4", @"5-20", @"20+", nil];
	self.lagerTonerValues = [NSArray arrayWithObjects:@"0", @"<2", @"2-4", @"5-20", @"20+", nil];
	self.printerTonerValues = [NSMutableArray arrayWithObjects:@"<10%", @"10-20%", @">20%", nil];
	/*
	self.printerTonerValues = [[NSMutableArray alloc] init];
	for (int i = 0; i<101; i++) {
		[self.printerTonerValues addObject:[NSString stringWithFormat:@"%i%%", i]];
	}*/
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
/*
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
*/
#pragma mark TextField/TextView Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	self.selectedTextField = textField;
	
	if (self.storageUnit) {
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
	if (self.storageUnit){
		def = [self.lagerTonerValues objectAtIndex:2];
		def2 = [self.lagerPaperValues objectAtIndex:2];
	}else{
		//def = @"50%";
		def = [self.printerTonerValues objectAtIndex:2];
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
		if (self.storageUnit){
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
	
	if (self.storageUnit){
		self.cardReaderSwitch.hidden = YES;
		self.cardReaderLabel.hidden = YES;
		
		if (!self.A3){
			self.A3Label.hidden = YES;
			self.A3TextField.hidden = YES;
		}
		
	}else{
		if (!self.cardReader){
			self.cardReaderSwitch.hidden = YES;
			self.cardReaderLabel.hidden = YES;
		}
		if (!self.black) {
			self.blackTextField.hidden = YES;
		}
		if (!self.color) {
			if (self.room.xero){
				self.cyanLabel.text = @"Xerographic module";
			}else{
				self.cyanLabel.hidden = YES;
				self.cyanTextField.hidden = YES;
			}
			if (self.room.fuser){
				self.magentaLabel.text = @"Fuser module";
			}else{
				self.magentaLabel.hidden = YES;
				self.magentaTextField.hidden = YES;
			}
			self.yellowLabel.hidden = YES;
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
	if (!self.storageUnit){
		prosent = @"%";
	}
	
	if (![defaults objectForKey:[NSString stringWithFormat:@"%@_date", self.name]]){
		return;
	}
	if (self.A4){
		self.A4TextField.text = ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_A4", self.name]]);
	}
	if (self.black){
		self.blackTextField.text = [NSString stringWithFormat: @"%@%@", ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_black", self.name]]), prosent];
	}
	if (self.cardReader){
		self.cardReaderSwitch.on = [((NSNumber *)[defaults objectForKey:[NSString stringWithFormat:@"%@_kortleser", self.name]]) boolValue];
	}
	
	if ([self.room.name isEqualToString:@"Real. Bib."]) {
		self.extraSwitch.on = [((NSNumber *)[defaults objectForKey:[NSString stringWithFormat:@"%@_extra", self.name]]) boolValue];
	}
	
	if (self.A3){
		self.A3TextField.text = ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_A3", self.name]]);
	}
	
	if (self.color) {
		self.cyanTextField.text = [NSString stringWithFormat: @"%@%@", ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_cyan", self.name]]), prosent];
		
		self.magentaTextField.text = [NSString stringWithFormat: @"%@%@", ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_magenta", self.name]]), prosent];
		
		self.yellowTextField.text = [NSString stringWithFormat: @"%@%@", ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_yellow", self.name]]), prosent];
	}else{
		if (self.room.xero){
			self.cyanTextField.text = [NSString stringWithFormat: @"%@%@", ((NSString *)[defaults objectForKey:[NSString stringWithFormat:@"%@_xero", self.name]]), prosent];
		}
		if (self.room.fuser){
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
	if (self.cardReader){
		[defaults setObject:[NSNumber numberWithBool:self.cardReaderSwitch.on] forKey:[NSString stringWithFormat: @"%@_kortleser", self.name]];
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
	if (self.black){
		[defaults setObject:[self.blackTextField.text stringByReplacingOccurrencesOfString:@"%" withString:@""] forKey:[NSString stringWithFormat: @"%@_black", self.name]];
	}
	if (self.color){
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

-(NSDictionary*)createDictionaryForAL
{
	NSDictionary *labelDictionary = [[NSDictionary alloc] init];
	
	int count = 0;
	
	//[labelDictionary setValue:@"Svart" forKey:[NSNumber numberWithInt:count]];
	
	
	
	return @{@0 : @"Svart", @1 : @"Cyan", @2 : @"Magenta", @3 : @"Yellow", @4 : @"Kort", @5 : @"Op", @6 : @"A4", @7 : @"A3"};
}

-(void)setUpWithAutoLayout:(NSDictionary*)labelDictionary
{
	NSArray* labels = [self genLabelsFromDic:labelDictionary];
	NSArray *fields = [self genFieldsFromDic:labelDictionary];
	
	[self connectFields:fields AndLabels:labels AndLabelDic:labelDictionary];
	
	UILabel *commentLabel = [UILabel new];
	commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
	commentLabel.text = @"Kommentar:";
	[self.view addSubview:commentLabel];
	
	UITextView *commentField = [UITextView new];
	commentField.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:commentField];
	self.commentTextView = commentField;
	
	// generate autolayout
	
	NSDictionary *metrics = @{@"offsetTop" : @20,
							  @"commentWidth" : [NSNumber numberWithInt: self.view.frame.size.width-24],
							  @"horizontalOffset" : @12,
							  @"offsetLF" : @5,
							  @"offsetFL" : @12,
							  @"gap": @80};
	
	NSDictionary *v_dic = @{@"labels0" : labels[0],
							@"labels1" : labels[1],
							@"labels2" : labels[2],
							@"labels3" : labels[3],
							
							@"labels10" : labels[4],
							@"labels11" : labels[5],
							@"labels12" : labels[6],
							@"labels13" : labels[7],
							
							@"fields0" : fields[0],
							@"fields1" : fields[1],
							@"fields2" : fields[2],
							@"fields3" : fields[3],
							
							@"fields10" : fields[4],
							@"fields11" : fields[5],
							@"fields12" : fields[6],
							@"fields13" : fields[7],
							
							@"commentLabel" : commentLabel,
							@"commentField" : commentField,
							
							@"top" : self.topLayoutGuide,
							@"bottom" : self.bottomLayoutGuide};
	
	NSArray *column1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[top]-offsetTop-[labels0]-offsetLF-[fields0]-offsetFL-[labels1]-offsetLF-[fields1]-offsetFL-[labels2]-offsetLF-[fields2]-offsetFL-[labels3]-offsetLF-[fields3]-offsetFL-[commentLabel]-offsetLF-[commentField]-[bottom]"
															   options:0
															   metrics:metrics
																 views:v_dic];
	[self.view addConstraints:column1];
	
	NSArray *column2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[top]-offsetTop-[labels10]-offsetLF-[fields10]-offsetFL-[labels11]-offsetLF-[fields11]-offsetFL-[labels12]-offsetLF-[fields12]-offsetFL-[labels13]-offsetLF-[fields13]"
															   options:NSLayoutFormatAlignAllLeading
															   metrics:metrics
																 views:v_dic];
	[self.view addConstraints:column2];
	
	NSArray *row1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-gap-[labels0]-gap-[labels10]"
															options:0
															metrics:metrics
															  views:v_dic];
	[self.view addConstraints:row1];
	
	NSArray *row2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-gap-[labels1]-gap-[labels11]"
															options:0
															metrics:metrics
															  views:v_dic];
	[self.view addConstraints:row2];
	
	NSArray *row3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-gap-[labels2]-gap-[labels12]"
															options:0
															metrics:metrics
															  views:v_dic];
	[self.view addConstraints:row3];
	
	NSArray *row4 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-gap-[labels3]-gap-[labels13]"
															options:0
															metrics:metrics
															  views:v_dic];
	[self.view addConstraints:row4];
	
	
	NSArray *row11 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-gap-[fields0(80)]-gap-[fields10(80)]"
															options:0
															metrics:metrics
															  views:v_dic];
	
	[self.view addConstraints:row11];
	
	NSArray *row12 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-gap-[fields1(80)]-gap-[fields11(80)]"
															options:0
															metrics:metrics
															  views:v_dic];
	[self.view addConstraints:row12];
	
	NSArray *row13 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-gap-[fields2(80)]-gap-[fields12(80)]"
															options:0
															metrics:metrics
															  views:v_dic];
	[self.view addConstraints:row13];
	
	NSArray *row14 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-gap-[fields3(80)]-gap-[fields13(80)]"
															options:0
															metrics:metrics
															  views:v_dic];
	[self.view addConstraints:row14];
	
	NSArray *rowCL = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-horizontalOffset-[commentLabel]"
															options:0
															metrics:metrics
															  views:v_dic];
	[self.view addConstraints:rowCL];
	
	NSArray *rowC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-horizontalOffset-[commentField(commentWidth)]"
															 options:0
															 metrics:metrics
															   views:v_dic];
	[self.view addConstraints:rowC];
	
	
}

-(void)connectFields:(NSArray *)fields AndLabels: (NSArray *)labels AndLabelDic: (NSDictionary *)dic
{

	if (self.black){
		self.blackLabel = labels[0];
		self.blackTextField = fields[0];
	}
	if (self.color){
		//self.cyanLabel =
	}
	
}

-(NSArray*)genLabelsFromDic: (NSDictionary *)labelDictionary
{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	UILabel *label0 = [UILabel new];
	label0.translatesAutoresizingMaskIntoConstraints = NO;
	label0.text = [labelDictionary objectForKey:@0];
	[self.view addSubview:label0];
	[array addObject:label0];
	
	UILabel *label1 = [UILabel new];
	label1.translatesAutoresizingMaskIntoConstraints = NO;
	label1.text = [labelDictionary objectForKey:@1];
	[self.view addSubview:label1];
	[array addObject:label1];
	
	UILabel *label2 = [UILabel new];
	label2.translatesAutoresizingMaskIntoConstraints = NO;
	label2.text = [labelDictionary objectForKey:@2];
	[self.view addSubview:label2];
	[array addObject:label2];
	
	UILabel *label3 = [UILabel new];
	label3.translatesAutoresizingMaskIntoConstraints = NO;
	label3.text = [labelDictionary objectForKey:@3];
	[self.view addSubview:label3];
	[array addObject:label3];
	
	UILabel *label10 = [UILabel new];
	label10.translatesAutoresizingMaskIntoConstraints = NO;
	label10.text = [labelDictionary objectForKey:@4];
	[self.view addSubview:label10];
	[array addObject:label10];
	
	UILabel *label11 = [UILabel new];
	label11.translatesAutoresizingMaskIntoConstraints = NO;
	label11.text = [labelDictionary objectForKey:@4];
	[self.view addSubview:label11];
	[array addObject:label11];
	
	UILabel *label12 = [UILabel new];
	label12.translatesAutoresizingMaskIntoConstraints = NO;
	label12.text = [labelDictionary objectForKey:@5];
	[self.view addSubview:label12];
	[array addObject:label12];
	
	UILabel *label13 = [UILabel new];
	label13.translatesAutoresizingMaskIntoConstraints = NO;
	label13.text = [labelDictionary objectForKey:@6];
	[self.view addSubview:label13];
	[array addObject:label13];
	
	return array;
}

-(NSArray*)genFieldsFromDic: (NSDictionary *)labelDictionary
{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	UITextField *field0 = [UITextField new];
	field0.translatesAutoresizingMaskIntoConstraints = NO;
	field0.borderStyle = UITextBorderStyleRoundedRect;
	[self.view addSubview:field0];
	[array addObject:field0];
	
	UITextField *field1 = [UITextField new];
	field1.translatesAutoresizingMaskIntoConstraints = NO;
	field1.borderStyle = UITextBorderStyleRoundedRect;
	[self.view addSubview:field1];
	[array addObject:field1];
	
	UITextField *field2 = [UITextField new];
	field2.translatesAutoresizingMaskIntoConstraints = NO;
	field2.borderStyle = UITextBorderStyleRoundedRect;
	[self.view addSubview:field2];
	[array addObject:field2];
	
	UITextField *field3 = [UITextField new];
	field3.translatesAutoresizingMaskIntoConstraints = NO;
	field3.borderStyle = UITextBorderStyleRoundedRect;
	[self.view addSubview:field3];
	[array addObject:field3];
	
	UISwitch *field10 = [UISwitch new];
	field10.translatesAutoresizingMaskIntoConstraints = NO;
	field10.on = YES;
	[self.view addSubview:field10];
	[array addObject:field10];
	
	UISwitch *field11 = [UISwitch new];
	field11.translatesAutoresizingMaskIntoConstraints = NO;
	field11.on = YES;
	[self.view addSubview:field11];
	[array addObject:field11];
	
	UITextField *field12 = [UITextField new];
	field12.translatesAutoresizingMaskIntoConstraints = NO;
	field12.borderStyle = UITextBorderStyleRoundedRect;
	[self.view addSubview:field12];
	[array addObject:field12];
	
	UITextField *field13 = [UITextField new];
	field13.translatesAutoresizingMaskIntoConstraints = NO;
	field13.borderStyle = UITextBorderStyleRoundedRect;
	[self.view addSubview:field13];
	[array addObject:field13];

	return array;
}

@end
