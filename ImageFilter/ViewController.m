//
//  ViewController.m
//  ImageFilter
//
//  Created by SurfBoy on 1/14/16.
//  Copyright © 2016 CrazySurfboy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    // Init
    self.view.backgroundColor = [UIColor colorFromHexCode:@"282e36"];
    self.title = @"图片滤镜";
    self.originalImage = [UIImage imageNamed:@"demo_375.png"];


    // 显示的图像
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, SCREEN_WDITH, SCREEN_WDITH)];
    [self.view addSubview:self.imageView];

    // 滤镜工具栏
    [self initFilterView];

}


// 滤镜
- (void)initFilterView {

    // 配置信息
    self.filterList = [[NSMutableArray alloc] init];

    // 滤镜数据
    NSDictionary *filterData1 = @{@"lookupImage":@"OriginalLookupTable.png", @"title":@"原图"};
    [self.filterList addObject:filterData1];

    NSDictionary *filterData2 = @{@"lookupImage":@"LookupTable1.png", @"title":@"怀旧"};
    [self.filterList addObject:filterData2];

    NSDictionary *filterData3 = @{@"lookupImage":@"LookupTable2.png", @"title":@"黑白"};
    [self.filterList addObject:filterData3];

    // 滤镜区域
    self.filterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT - 64 - 100, SCREEN_WDITH, 100 )];
    [self.filterView setBackgroundColor:[UIColor colorFromHexCode:@"3a424d"]];
    [self.view addSubview:self.filterView];

    // 创建选择滑动的滤镜
    [self crateFilters];
}



// 创建滤镜
- (void)crateFilters {

    // 总数
    NSInteger filterTotal = [self.filterList count];

    // 预览的效果图 - 一般做法是需要压缩成当前图像的大小，例如 60 *60 例子我是直接使用的。
    UIImage *smallImage = self.originalImage;

    NSInteger i;
    for (i=0; i< filterTotal; i++) {

        NSMutableDictionary *tempFilterData = self.filterList[i];

        // Box
        UIView *filterBoxView = [[UIView alloc] initWithFrame:CGRectMake(i*70, 10.0, 70.0f, 80.0f)];
        [self.filterView addSubview:filterBoxView];

        // 预览的图像
        UIImage *filteredImage = [self filterImage:smallImage withLUTNamed:tempFilterData[@"lookupImage"]];
        UIImageView *tempFilterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 60.0f, 60.0f)];
        tempFilterImageView.image = filteredImage;
        [filterBoxView addSubview:tempFilterImageView];

        // 文字
        UILabel *filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 60.0, 60.0, 20.0)];
        filterLabel.text = tempFilterData[@"title"];
        filterLabel.backgroundColor = [UIColor colorWithRed:66/255.0 green:212/255.0 blue:153/255.0 alpha:0.75];
        filterLabel.font = [UIFont systemFontOfSize:11];
        filterLabel.textAlignment = NSTextAlignmentCenter;
        filterLabel.textColor = [UIColor whiteColor];
        [filterBoxView addSubview:filterLabel];

        // 操作
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionButton.frame  = CGRectMake(10, 0.0f, 60.0f, 80.0f);
        [[actionButton layer] setBorderColor:[[UIColor colorFromHexCode:@"057fed"] CGColor]];
        actionButton.tag = i + 20;
        [actionButton addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside |UIControlEventTouchDragOutside];
        [filterBoxView addSubview:actionButton];
    }

    // 默认选中原图
    UIButton *originalButton = [self.view viewWithTag:20];
    [self filterButtonClick:originalButton];
}



// 点击滤镜效果
-(void)filterButtonClick:(id)sender {

    self.selectedFilterButton = (UIButton *)sender;

    // 生成大的效果图
    NSMutableDictionary *tempData = self.filterList[self.selectedFilterButton.tag - 20];
    UIImage *filteredImage = [self filterImage:self.originalImage withLUTNamed:tempData[@"lookupImage"]];
    self.imageView.image = filteredImage;
}



// 图片进行滤镜添加操作
- (UIImage *)filterImage:(UIImage *)originalImage withLUTNamed:(NSString *)lutName {

    // 建立原图与
    GPUImagePicture *originalImageSource = [[GPUImagePicture alloc] initWithImage:originalImage];
    GPUImagePicture *lookupImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:lutName]];

    // 使用这个滤镜类就可以直接对图片进行滤镜添加操作
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];

    // 进行滤镜处理
    [originalImageSource addTarget:lookupFilter];
    [originalImageSource processImage];

    [lookupImageSource addTarget:lookupFilter];
    [lookupImageSource processImage];

    [lookupFilter useNextFrameForImageCapture];


    return [lookupFilter imageFromCurrentFramebufferWithOrientation:UIImageOrientationUp];
}



@end
