//
//  RoomCell.h
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 19/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (strong, nonatomic) NSArray *options;

@end
