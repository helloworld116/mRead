//
//  SecondViewController.m
//  mRead
//
//  Created by admin on 16/6/22.
//  Copyright © 2016年 wenzhengguang. All rights reserved.
//

#import "SecondViewController.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

dispatch_queue_t scrollDownloadQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.bona.scroll.download", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}
static const CGFloat padding = 10.f;
static CGFloat imageTotalHeight = 0;

@interface SecondViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *imageUrls;
@end

@implementation SecondViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    imageTotalHeight = 0;
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    dispatch_async(scrollDownloadQueue(), ^{
        for (NSString *imageUrl in self.imageUrls) {
            if ([[SDWebImageManager sharedManager].imageCache diskImageExistsWithKey:imageUrl]) {
                [[SDWebImageManager sharedManager].imageCache queryDiskCacheForKey:imageUrl done:^(UIImage *image, SDImageCacheType cacheType) {
                    [self scrollViewAddImageView:image];
                }];
            } else {
                [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                }
                    completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        if (finished) {
                            if (image) {
                                [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:imageUrl];
                            }
                            [self scrollViewAddImageView:image];
                        }
                    }];
            }
        }
    });
}

- (void)scrollViewAddImageView:(UIImage *)image {
    if (image) {
        NSLog(@"image size is %@", NSStringFromCGSize(image.size));
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat width = SCREEN_WIDTH - 2 * padding;
            CGFloat height = image.size.height / image.size.width * width;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(padding, imageTotalHeight + padding, width, height);
            imageTotalHeight += (height + 2 * padding);
            [self.scrollView addSubview:imageView];
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, imageTotalHeight);
            //        [self.scrollView setNeedsLayout];
        });
    }
}

#pragma mark - get
- (NSArray *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = @[ @"http://121.41.79.70/images/article/201606/20160616175326693.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175331796.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175333866.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175336473.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175338503.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175345452.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175347434.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175352113.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175355795.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175359606.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175406557.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175412205.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175415430.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175417857.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175423278.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175428194.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175432625.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175436180.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175438100.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175445888.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175449597.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175455146.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175459859.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175506185.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175508911.jpg",
                        @"http://121.41.79.70/images/article/201606/20160616175512086.jpg" ];
    }
    return _imageUrls;
}

@end
