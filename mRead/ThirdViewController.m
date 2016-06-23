//
//  ThirdViewController.m
//  mRead
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 wenzhengguang. All rights reserved.
//

#import "RegexKitLite.h"
#import "TYAttributedLabel.h"
#import "TYImageCache.h"
#import "TYImageStorage.h"
#import "TYTextStorage.h"
#import "ThirdViewController.h"
//#import <SDWebImage/SDWebImageManager.h>
//#import <SDWebImage/UIImageView+WebCache.h>
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

typedef void (^bImageStorage)(TYImageStorage *storage);

static NSString *const body = @"乐言居：取法自然乐活山间\n${/images/article/201606/20160616175326693.jpg}\n蜜桃小院：温润的安居所 \n${/images/article/201606/20160616175331796.jpg}\n\n${/images/article/201606/20160616175333866.jpg}\n飞鸟集：每个旅人都是飞鸟\n${/images/article/201606/20160616175336473.jpg}\n\n${/images/article/201606/20160616175338503.jpg}\n\n${/images/article/201606/20160616175345452.jpg}\n半野艺舍：一个纯粹的当代艺术交流空间\n${/images/article/201606/20160616175347434.jpg}\n\n${/images/article/201606/20160616175352113.jpg}\n\n${/images/article/201606/20160616175355795.jpg}\n\n${/images/article/201606/20160616175359606.jpg}\n栖迟：衡门之下，可以栖迟 \n${/images/article/201606/20160616175406557.jpg}\n\n${/images/article/201606/20160616175412205.jpg}\n\n${/images/article/201606/20160616175415430.jpg}\n可以住：一家接近“家”气质的生活旅舍 \n${/images/article/201606/20160616175417857.jpg}\n\n${/images/article/201606/20160616175423278.jpg}\n\n${/images/article/201606/20160616175428194.jpg}\n\n${/images/article/201606/20160616175432625.jpg}\n无垠：来一场艺术与设计的漫游\n${/images/article/201606/20160616175436180.jpg}\n\n${/images/article/201606/20160616175438100.jpg}\n\n${/images/article/201606/20160616175445888.jpg}\n良筑：慢慢走，遇见厦门的精致优雅 \n${/images/article/201606/20160616175449597.jpg}\n\n${/images/article/201606/20160616175455146.jpg}\n\n${/images/article/201606/20160616175459859.jpg}\n己已巳：一座老宅，八个房东 \n${/images/article/201606/20160616175506185.jpg}\n\n${/images/article/201606/20160616175508911.jpg}\n\n${/images/article/201606/20160616175512086.jpg}\n玩味旅社：感受一屋子的好设计";

@interface ThirdViewController ()
@property (nonatomic, strong) TYAttributedLabel *lblBody;
@property (nonatomic, weak) IBOutlet UIScrollView *scollView;
@end

@implementation ThirdViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.lblBody = [[TYAttributedLabel alloc] init];
    self.lblBody.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 20);
    [self.scollView addSubview:self.lblBody];

    TYTextContainer *attStringCreater = [[TYTextContainer alloc] createTextContainerWithTextWidth:self.lblBody.frame.size.width];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        attStringCreater.text = body;
        attStringCreater.font = [UIFont systemFontOfSize:16];
        attStringCreater.textColor = [UIColor darkGrayColor];
        attStringCreater.linesSpacing = 0;
        [body
            enumerateStringsMatchedByRegex:@"\\$\\{(.*?)\\}"
                                usingBlock:^(NSInteger captureCount,
                                             NSString *const __unsafe_unretained
                                                 *capturedStrings,
                                             const NSRange *capturedRanges,
                                             volatile BOOL *const stop) {
                                    NSString *url = [NSString
                                        stringWithFormat:@"%@%@", @"http://121.41.79.70", capturedStrings[1]];
                                    NSRange range = capturedRanges[0];
                                    [self hanlderImageWithUrlString:url range:range callbackWithImageStorage:^(TYImageStorage *storage) {
                                        [attStringCreater addTextStorage:storage];
                                    }];
                                }];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.lblBody.textContainer = attStringCreater;
        [self.lblBody sizeToFit];
        self.scollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.lblBody.frame.size.height + 20);
    });
}

- (void)hanlderImageWithUrlString:(NSString *)urlString
                            range:(NSRange)range
         callbackWithImageStorage:(bImageStorage)callback {
    // 图片信息储存
    TYImageStorage *imageStorage = [[TYImageStorage alloc] init];
    imageStorage.margin = UIEdgeInsetsZero;
    imageStorage.range = range;
    imageStorage.placeholdImageName = @"default_banner";
    NSString *url = urlString;
    [[TYImageCache cache] imageForURL:url found:^(UIImage *image) {
        imageStorage.image = image;
        CGFloat height = image.size.height * self.lblBody.frame.size.width /
                         image.size.width;
        imageStorage.size = CGSizeMake(self.lblBody.frame.size.width, height);
        callback(imageStorage);
    }
        notFound:^{
            imageStorage.size = CGSizeMake(self.lblBody.frame.size.width, 200);
            imageStorage.imageURL = [NSURL URLWithString:url];
            callback(imageStorage);
        }];
}
@end
