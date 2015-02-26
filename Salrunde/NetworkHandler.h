//
//  NetworkHandler.h
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 19/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room.h"

@interface NetworkHandler : NSObject

- (NSUInteger)getDelphiRows;

- (NSUInteger)getSkrankeRows;

-(NSArray *)getDelphiRooms;

-(NSArray *)getSkrankeRooms;

- (NSString *)getDelphiLabelForIndex:(NSInteger)index;

- (NSString *)getSkrankeLabelForIndex:(NSInteger)index;

-(Room *)getRoomForName:(NSString *)name;

@end
