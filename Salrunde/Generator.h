//
//  Generator.h
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 22/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Generator : NSObject

-(NSString *)generate:(NSString *)location withNH: (NetworkHandler *)nh;

@end
