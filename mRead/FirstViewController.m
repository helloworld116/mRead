//
//  FirstViewController.m
//  mRead
//
//  Created by admin on 16/6/22.
//  Copyright © 2016年 wenzhengguang. All rights reserved.
//

#import "FirstViewController.h"
#import "ImageCell.h"
#import "SecondViewController.h"
@interface FirstViewController ()
@property (nonatomic, strong) NSArray *imageUrls;
@end

@implementation FirstViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.imageUrls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ImageCell";
    ImageCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *imageUrl = self.imageUrls[indexPath.row];
    [cell setImageUrl:imageUrl];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    //    UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThirdViewController"];
    UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FourthViewController"];
    [self.navigationController pushViewController:nextViewController animated:YES];
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
