//
//  DelphiTableViewController.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 19/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "LocationTableViewController.h"
#import "MyNavController.h"
#import "NetworkHandler.h"
#import "RoomCell.h"
#import "PrinterViewController.h"
#import "Generator.h"
#import "MapViewController.h"

@interface LocationTableViewController ()

@property (strong, nonatomic) NetworkHandler* nh;
@property (strong, nonatomic) Generator *generator;
@property (strong, nonatomic) Room *selected;
@property (strong, nonatomic) NSString *nameOfRoomThatGeneratedError;
@property (nonatomic) BOOL SIMULATOR;

@end

@implementation LocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.nh = ((MyNavController *)self.navigationController).nh;
	
	self.generator = [[Generator alloc] init];
	
	self.tableView.rowHeight = 44;
	self.title = self.location;
	
	UIBarButtonItem *generate = [[UIBarButtonItem alloc] initWithTitle:@"Epost" style:UIBarButtonItemStylePlain target:self action:@selector(generateReport)];
	self.navigationItem.rightBarButtonItem = generate;

	self.SIMULATOR = NO;
	if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"]){
		self.SIMULATOR = YES;
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		if ([self.location isEqualToString:@"Skranke"]){
			return [self.nh getSkrankeRows];
		}else if ([self.location isEqualToString:@"Delphi"]){
			return [self.nh getDelphiRows];
		}
	}
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellIdentifier = @"RoomCell";
	
    RoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell){
		[tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
		cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	}
	
	if ([self.location isEqualToString:@"Skranke"]){
		cell.roomLabel.text = [self.nh getSkrankeLabelForIndex:indexPath.row];
	}else if ([self.location isEqualToString:@"Delphi"]){
		cell.roomLabel.text = [self.nh getDelphiLabelForIndex:indexPath.row];
	}
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.selected = [self.nh getRoomForName: ((RoomCell *)[tableView cellForRowAtIndexPath:indexPath]).roomLabel.text];
	[self performSegueWithIdentifier:@"showRoom" sender:nil];
}

-(void)generateReport
{
	if ([self allRoomsEditedLast24H]){
		NSString *tmp = [self.generator generate:self.location withNH:self.nh];
		[self showEmailView: tmp forLoc:self.location];
	}else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feil!" message:[NSString stringWithFormat:@"%@ har ikke blitt lagret!", self.nameOfRoomThatGeneratedError] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}

-(BOOL)allRoomsEditedLast24H
{
	NSArray *rooms;
	
	if ([self.location isEqualToString:@"Skranke"]){
		rooms = [self.nh getSkrankeRooms];
	}else if ([self.location isEqualToString:@"Delphi"]){
		rooms = [self.nh getDelphiRooms];
	}
	
	for (int i = 0; i < [rooms count]; i++) {
		NSDate *savedDate = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_date", ((Room *)[rooms objectAtIndex:i]).name]];
		
		if (savedDate == nil || [savedDate timeIntervalSinceNow] >= 86400){
			self.nameOfRoomThatGeneratedError = ((Room *)[rooms objectAtIndex:i]).name;
			return false;
		}
	}
	return true;
}

# pragma mark - Email

-(void)showEmailView:(NSString *)contents forLoc:(NSString *)loc
{
	NSLog(@"Can device send email: %i", [MFMailComposeViewController canSendMail]);
	if (!self.SIMULATOR && [MFMailComposeViewController canSendMail]){
		MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
		mailer.mailComposeDelegate = self;
		NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
		NSDateComponents *components = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
		NSInteger day = [components day];
		NSInteger month = [components month];
		NSInteger year = [components year];
		NSString *startSubject;
		
		[f setPaddingCharacter:@"0"];
		[f setMinimumIntegerDigits:2];
		
		NSString * yearString = [f stringFromNumber:[NSNumber numberWithInteger:year]];
		NSString * monthString = [f stringFromNumber:[NSNumber numberWithInteger:month]];
		NSString * dayString = [f stringFromNumber:[NSNumber numberWithInteger:day]];
		
		if ([loc isEqualToString:@"Delphi"]) {
			startSubject = @"";
		}else if ([loc isEqualToString:@"Skranke"]){
			startSubject = @"Re: ";
		}
		
		[mailer setSubject:[NSString stringWithFormat:@"%@Salrunde %@-%@-%@", startSubject, yearString, monthString, dayString]];
		[mailer setMessageBody:contents isHTML:NO];
		
		NSString *rec = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultRecipient"];
		if (![rec isEqualToString:@""]){
			[mailer setToRecipients:[NSArray arrayWithObjects:rec, nil]];
		}
		[self presentViewController:mailer animated:YES completion:nil];
		
	}else{
		UIPasteboard *paste = [UIPasteboard generalPasteboard];
		[paste setString:contents];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Epost feil!" message:@"Kunne ikke sende epost. Innholdet er lagt til utklippstavlen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OBS!" message:@"Noe gikk galt! Eposten ble ikke sendt!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the drafts folder.");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
			[alert show];
			break;
		default:
			NSLog(@"Mail not sent.");
			[alert show];
			break;
	}
 
	// Remove the mail view
	[self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString:@"showRoom"]){
		NSLog(@"showRoom: %@", self.selected.name);
		((PrinterViewController *)[segue destinationViewController]).name = self.selected.name;
		((PrinterViewController *)[segue destinationViewController]).room = self.selected;
	}
}


@end
