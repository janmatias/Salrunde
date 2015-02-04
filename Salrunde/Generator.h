//
//  Generator.h
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 22/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface Generator : NSObject <MFMailComposeViewControllerDelegate>

-(NSString *)generate:(NSString *)location;

@end
