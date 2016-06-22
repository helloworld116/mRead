//
//  ImageCell.h
//  mRead
//
//  Created by admin on 16/6/22.
//  Copyright © 2016年 wenzhengguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imgv;
- (void)setImageUrl:(NSString *)imageUrl;
@end
