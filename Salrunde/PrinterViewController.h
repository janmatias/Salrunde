//
//  PrinterViewController.h
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 19/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface PrinterViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Room *room;

-(void)save;

@end
