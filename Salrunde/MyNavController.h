//
//  MyNavController.h
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 19/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetworkHandler.h"

@interface MyNavController : UINavigationController

@property (strong, nonatomic) NetworkHandler* nh;

@end
