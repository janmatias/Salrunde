//
//  MapViewController.h
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 29/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController

@property (nonatomic) BOOL useLLF;
@property (strong, nonatomic) NSString * ID;
@property (strong, nonatomic) NSString * latitude;
@property (strong, nonatomic) NSString * longitude;
@property (strong, nonatomic) NSString * floor;

@end
