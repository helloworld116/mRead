//
//  ImageCell.m
//  mRead
//
//  Created by admin on 16/6/22.
//  Copyright © 2016年 wenzhengguang. All rights reserved.
//

#import "ImageCell.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

dispatch_queue_t downloadQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.download", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

@implementation ImageCell
- (void)awakeFromNib {
    self.imgv.image = nil;
}

- (void)setImageUrl:(NSString *)imageUrl {
    self.imgv.image = nil;
    dispatch_async(downloadQueue(), ^{
        if ([[SDWebImageManager sharedManager].imageCache diskImageExistsWithKey:imageUrl]) {
            [[SDWebImageManager sharedManager].imageCache queryDiskCacheForKey:imageUrl done:^(UIImage *image, SDImageCacheType cacheType) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imgv.image = image;
                });
            }];
        } else {

            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"is main thread %@", @([NSThread isMainThread]));
                    self.imgv.image = image;
                    NSLog(@"image size is %@", NSStringFromCGSize(image.size));
                });
            }];
        }
    });
}
@end
