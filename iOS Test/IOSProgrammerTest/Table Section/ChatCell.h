//
//  TableSectionTableViewCell.h
//  IOSProgrammerTest
//
//
//  Created by Kritsakorn on 7/24/15.
//  Copyright (c) 2015 Kritsakorn. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ChatData.h"
@interface ChatCell : UITableViewCell
- (void)loadWithData:(ChatData *)chatData;
@end
