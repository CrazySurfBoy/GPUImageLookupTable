//
//  ViewController.h
//  ImageFilter
//
//  Created by SurfBoy on 1/14/16.
//  Copyright © 2016 CrazySurfboy. All rights reserved.

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import "GPUImage.h"

@interface ViewController : UIViewController {

}

@property(nonatomic, strong) NSMutableArray *filterList;
@property(nonatomic, strong) UIImage *originalImage;
@property(nonatomic, strong) UIButton *selectedFilterButton;
@property (nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIView *filterView;



/**
 *  滤镜视频
 *
 */
- (void)initFilterView;



/**
 *  创建滤镜
 *
 */
- (void)crateFilters;




/**
 *  点击滤镜效果
 *
 *  @param id sender
 */
-(void)filterButtonClick:(id)sender;



/**
 *  图片进行滤镜添加操作
 *
 *  @param UIImage 要处理的图片
 *  @param NSString 原始颜色查找表图片名
 *
 *  @return UIImage 返回滤镜后的图片
 */
- (UIImage *)filterImage:(UIImage *)originalImage withLUTNamed:(NSString *)lutName;

@end

