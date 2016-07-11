//
//  ViewController.m
//  美女轮播
//
//  Created by iphone18 on 16/5/26.
//  Copyright © 2016年 apple18. All rights reserved.
//

#import "ViewController.h"
#import "FUScrollView.h"
#import "MJExtension.h"
#import "FUModel.h"

#define kCurrentPage pageCl.currentPage
#define kOffSetX scrollView.contentOffset.x/414

@interface ViewController ()<UIScrollViewDelegate>
{
    
    NSArray *tempArray;
    UIImageView *imageView;
    UIPageControl *pageCl;
    
    BOOL isRight;
    
    UIImageView *leftImageView;
    UIImageView *rightImageView;
    
    NSTimer *timerr;
}
@end

@implementation ViewController


static long count = 0;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self loadData];
}

- (void)loadData{
    
    NSString *str = @"http://apis.baidu.com/txapi/mvtp/meinv?num=10";
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"get";
    
    [request addValue:@"bb3a63413439b889453d2884f243df69" forHTTPHeaderField:@"apikey"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        tempArray = dict[@"newslist"];
        
        tempArray = [FUModel mj_objectArrayWithKeyValuesArray:tempArray];
        
        
        [self performSelectorOnMainThread:@selector(setScrollView) withObject:nil waitUntilDone:YES];
    }];
    
    [dataTask resume];
}


- (void)setPageCl{
    
    pageCl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 706-64, 414, 30)];
    
    pageCl.numberOfPages = 10;
    
    pageCl.backgroundColor = [UIColor magentaColor];
    
    pageCl.alpha = 0.4;
    
    [self.view addSubview:pageCl];
    
}


- (void)updateImage{
    
    FUModel *model = tempArray[count];
    
    self.title = model.title;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.picUrl]];
    
    imageView.image = [UIImage imageWithData:data];
    
}


#pragma mark 手势 updateImage

- (void)addGesture{
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, 706-64)];
    
    [self.view addSubview:imageView];
    
    
    [self setPageCl];
    
    [self updateImage];
    
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe)];
    
    [self.view addGestureRecognizer:rightSwipe];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe)];
    
    [self.view addGestureRecognizer:leftSwipe];
    
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updatePage) userInfo:nil repeats:YES];
    
    timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    
}

- (void)updatePage{
    
    kCurrentPage++;
    
    count++;
    
    if (count > tempArray.count-1) {
        
        count = 0;
        
        kCurrentPage = 0;
    }
    
    [self updateImage];
}



- (void)leftSwipe{
    
    [self updatePage];
}

- (void)rightSwipe{
    
    count--;
    
    kCurrentPage--;
    
    if (count<0) {
        
        count = tempArray.count-1;
        
        kCurrentPage = tempArray.count-1;
    }
    
    [self updateImage];
}



#pragma mark scrollView updateImage

- (void)setScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 414, 706-64)];
    
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(414*3, 706-64);
    scrollView.contentOffset = CGPointMake(414, 0);
    
    scrollView.tag = 777;
    
    scrollView.pagingEnabled = YES;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    scrollView.delegate = self;
    
    [self setImageView:scrollView];
    
    [self setPageCl];
}

- (void)setImageView:(UIScrollView *)scrollView{
    
    leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, 706-64)];
    
    [scrollView addSubview:leftImageView];
    
    [self updateLeftImage:tempArray.lastObject];
    
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(414, 0, 414, 706-64)];
    
    [scrollView addSubview:imageView];
    
    [self updateImage];
    
    
    rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(414*2, 0, 414, 706-64)];
    
    [scrollView addSubview:rightImageView];
    
    [self updateRightImage:tempArray[count+1]];

    
    timerr = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updatePageOfScroll) userInfo:nil repeats:YES];
    
   timerr.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];

}

- (void)updatePageOfScroll{
    
    count++;
    
    if (count>tempArray.count-1) {
        
        count = 0;
        kCurrentPage = 0;
    }else{
        
        kCurrentPage++;
    }
    
   
    UIScrollView *scrollView = [self.view viewWithTag:777];
    
    [self updateImageView:scrollView];
}

- (void)updateRightImage:(FUModel *)model{
    
    
    FUModel *rightModel = model;
    
    self.title = model.title;
    
    NSData *rightData = [NSData dataWithContentsOfURL:[NSURL URLWithString:rightModel.picUrl]];
    
    rightImageView.image = [UIImage imageWithData:rightData];
    
}

- (void)updateLeftImage:(FUModel *)model{
    
    
    FUModel *leftModel = model;
    
    self.title = model.title;
    
    NSData *leftData = [NSData dataWithContentsOfURL:[NSURL URLWithString:leftModel.picUrl]];
    
    leftImageView.image = [UIImage imageWithData:leftData];
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
        if (kOffSetX>=1.5) {
            
            count++;
            
            if (count>tempArray.count-1) {
                
                count = 0;
                
                kCurrentPage = 0;
            }else{
                
               kCurrentPage++;
            }
            
            
        }else if (kOffSetX<=0.5){
            
            count--;
            
            if (count<0) {
                
                count = tempArray.count-1;
                
                kCurrentPage = tempArray.count-1;
                
            }else{
                
                kCurrentPage--;
            }
            
        }

    //让定时器暂停
    timerr.fireDate = [NSDate distantFuture];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"count===%ld",count);
    NSLog(@"currentPage==%ld",kCurrentPage);
    
    //取消延迟执行的方法
   // [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self updateImageView:scrollView];
    
    //打开定时器
    timerr.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
}

- (void)updateImageView:(UIScrollView *)scrollView{
    
    scrollView.contentOffset = CGPointMake(414, 0);
    
    if (count == tempArray.count-1) {
        
        [self updateRightImage:tempArray.firstObject];
        
        [self updateLeftImage:tempArray[count-1]];
        
    }else if (count == 0){
        
        [self updateRightImage:tempArray[count+1]];
        
        [self updateLeftImage:tempArray.lastObject];
        
    }else{
        
        [self updateRightImage:tempArray[count+1]];
        
        [self updateLeftImage:tempArray[count-1]];
        
    }
    
    [self updateImage];

    
}


@end
