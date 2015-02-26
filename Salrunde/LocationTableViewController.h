//
//  DelphiTableViewController.h
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 19/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface LocationTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSString *location;

@end
