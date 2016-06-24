//
//  FourthViewController.m
//  mRead
//
//  Created by admin on 16/6/24.
//  Copyright © 2016年 wenzhengguang. All rights reserved.
//

#import "FourthViewController.h"
#import "RegexKitLite.h"
#import "UIView+YYAdd.h"
#import <NSAttributedString+YYText.h>
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import <YYLabel.h>
#import <YYTextRunDelegate.h>
#include <pthread.h>

static NSString *const body = @"乐言居：取法自然乐活山间\n${/images/article/201606/20160616175326693.jpg}\n蜜桃小院：温润的安居所 \n${/images/article/201606/20160616175331796.jpg}\n\n${/images/article/201606/20160616175333866.jpg}\n飞鸟集：每个旅人都是飞鸟\n${/images/article/201606/20160616175336473.jpg}\n\n${/images/article/201606/20160616175338503.jpg}\n\n${/images/article/201606/20160616175345452.jpg}\n半野艺舍：一个纯粹的当代艺术交流空间\n${/images/article/201606/20160616175347434.jpg}\n\n${/images/article/201606/20160616175352113.jpg}\n\n${/images/article/201606/20160616175355795.jpg}\n\n${/images/article/201606/20160616175359606.jpg}\n栖迟：衡门之下，可以栖迟 \n${/images/article/201606/20160616175406557.jpg}\n\n${/images/article/201606/20160616175412205.jpg}\n\n${/images/article/201606/20160616175415430.jpg}\n可以住：一家接近“家”气质的生活旅舍 \n${/images/article/201606/20160616175417857.jpg}\n\n${/images/article/201606/20160616175423278.jpg}\n\n${/images/article/201606/20160616175428194.jpg}\n\n${/images/article/201606/20160616175432625.jpg}\n无垠：来一场艺术与设计的漫游\n${/images/article/201606/20160616175436180.jpg}\n\n${/images/article/201606/20160616175438100.jpg}\n\n${/images/article/201606/20160616175445888.jpg}\n良筑：慢慢走，遇见厦门的精致优雅 \n${/images/article/201606/20160616175449597.jpg}\n\n${/images/article/201606/20160616175455146.jpg}\n\n${/images/article/201606/20160616175459859.jpg}\n己已巳：一座老宅，八个房东 \n${/images/article/201606/20160616175506185.jpg}\n\n${/images/article/201606/20160616175508911.jpg}\n\n${/images/article/201606/20160616175512086.jpg}\n玩味旅社：感受一屋子的好设计";
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
typedef void (^LYImageAttachmentDownloadSuccessBlock)(UIImage *image, NSRange range);

@interface LYTextImageViewAttachment : YYTextAttachment
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign) CGSize placeholderSize;

- (instancetype)initWithImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage placeholderSize:(CGSize)placeholderSize;
@end

@implementation LYTextImageViewAttachment {
    UIImageView *_imageView;
}

- (instancetype)initWithImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage placeholderSize:(CGSize)placeholderSize {
    self = [super init];
    if (self) {
        self.imageURL = imageURL;
        self.placeholderImage = placeholderImage;
        self.placeholderSize = placeholderSize;
    }
    return self;
}

- (void)setContent:(id)content {
    _imageView = content;
}

- (id)content {
    /// UIImageView 只能在主线程访问
    if (pthread_main_np() == 0) return nil;
    if (_imageView) return _imageView;
    _imageView = [UIImageView new];
    _imageView.size = self.placeholderSize;
    [_imageView sd_setImageWithURL:self.imageURL placeholderImage:self.placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //        CGFloat height = image.size.height * _size.width /
        //                         image.size.width;
        //        CGSize imageSize = CGSizeMake(_size.width, height);
        //        _imageView.size = imageSize;
        if (image) {
            _imageView.image = image;
        }
    }];
    return _imageView;
}
@end

@interface FourthViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSString *body;
@end

@implementation FourthViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.body = body;
    [self addLabel];
}

- (void)addLabel {
    YYLabel *label = [YYLabel new];
    label.displaysAsynchronously = YES;
    label.ignoreCommonProperties = YES;
    label.left = 10.f;
    label.top = 10.f;
    label.right = 10.f;
    [self.scrollView addSubview:label];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Create attributed string.
        UIFont *font = [UIFont systemFontOfSize:16];
        NSMutableAttributedString *parseBody = [NSMutableAttributedString new];
        [self.body enumerateStringsSeparatedByRegex:@"\\$\\{(.*?)\\}" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
            if (captureCount == 2) {
                NSString *text = capturedStrings[0];
                [parseBody appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:nil]];

                NSString *imageUrl = [NSString
                    stringWithFormat:@"%@%@", @"http://121.41.79.70", capturedStrings[1]];
                BOOL diskExists = [[SDWebImageManager sharedManager].imageCache diskImageExistsWithKey:imageUrl];
                NSMutableAttributedString *attachment = nil;
                UIImage *image;
                if (diskExists) {
                    image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:imageUrl];
                    CGFloat height = image.size.height * (SCREEN_WIDTH - 20) / image.size.width;
                    CGSize imageSize = CGSizeMake(SCREEN_WIDTH - 20, height);
                    image = [self scaleImage:image ToSize:imageSize];
                    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:imageSize alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                } else {
                    UIImage *placeholderImage = [UIImage imageNamed:@"default_banner"];
                    attachment = [self _attachmentWithImageURL:imageUrl placeholderImage:placeholderImage width:SCREEN_WIDTH - 20];
                }
                [parseBody appendAttributedString:attachment];
            } else if (captureCount == 1) {
                NSString *text = capturedStrings[0];
                [parseBody appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:nil]];
            }
        }];

        parseBody.yy_font = font;

        // Create text container
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(SCREEN_WIDTH - 20, CGFLOAT_MAX);
        container.maximumNumberOfRows = 0;

        // Generate a text layout.
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:parseBody];
        dispatch_async(dispatch_get_main_queue(), ^{
            label.size = layout.textBoundingSize;
            label.textLayout = layout;
            self.scrollView.contentSize = layout.textBoundingSize;
        });
    });
}

- (UIImage *)scaleImage:(UIImage *)sourceImage ToSize:(CGSize)targetSize {
    CGFloat width = sourceImage.size.width;
    CGFloat height = sourceImage.size.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(sourceImage.size, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {

            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (newImage == nil)
        NSLog(@"could not scale image");
    return newImage;
}

- (NSMutableAttributedString *)_attachmentWithImageURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage width:(CGFloat)width {
    //Placeholder图片占用的大小
    CGFloat height = placeholderImage.size.height * width / placeholderImage.size.width;
    CGSize size = CGSizeMake(width, height);

    CGFloat ascent = size.height;
    CGFloat descent = -size.height;
    CGRect bounding = CGRectMake(0, 0, size.width, size.height);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), 0, descent + bounding.origin.y, 0);
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width;

    LYTextImageViewAttachment *attachment = [[LYTextImageViewAttachment alloc] initWithImageURL:[NSURL URLWithString:imageURL] placeholderImage:placeholderImage placeholderSize:size];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = contentInsets;
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr yy_setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr yy_setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    return atr;
}

//+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
//    UIImage *newimage;
//    if (nil == image) {
//        newimage = nil;
//    } else {
//        CGSize oldsize = image.size;
//        CGRect rect;
//        if (asize.width / asize.height > oldsize.width / oldsize.height) {
//            rect.size.width = asize.height * oldsize.width / oldsize.height;
//            rect.size.height = asize.height;
//            rect.origin.x = (asize.width - rect.size.width) / 2;
//            rect.origin.y = 0;
//        } else {
//            rect.size.width = asize.width;
//            rect.size.height = asize.width * oldsize.height / oldsize.width;
//            rect.origin.x = 0;
//            rect.origin.y = (asize.height - rect.size.height) / 2;
//        }
//        UIGraphicsBeginImageContext(asize);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//        UIRectFill(CGRectMake(0, 0, asize.width, asize.height)); //clear background
//        [image drawInRect:rect];
//        newimage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//    return newimage;
//}

@end
