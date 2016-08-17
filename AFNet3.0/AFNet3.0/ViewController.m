//
//  ViewController.m
//  AFNet3.0
//
//  Created by MrJalen on 16/8/17.
//  Copyright © 2016年 lianjiang. All rights reserved.
//

#import "ViewController.h"
#import "AFNetAPIClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    [[AFNetAPIClient sharedJsonClient].setRequest(@"getjobs").RequestType(GET).Parameters(@{@"pagenum":@(1)}) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"JSON"
                                                        message: @"The request is successful"
                                                       delegate: self
                                              cancelButtonTitle: @"Cancel"
                                              otherButtonTitles: @"OK", nil];
        [alert show];
    } progress:^(NSProgress *progress) {
        NSLog(@"%@",progress);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];




//    //上传图片
//    UIImage *img = [UIImage imageNamed:@"1"];
//
//    NSData *data = UIImageJPEGRepresentation(img, 0.5);
//
//    NSDictionary *dic = @{@"timestamp" : @"1457403110",
//                          @"file"      : data,
//                          @"xtype"     :@"bang_album",
//                          @"token"     : @"8a3dead8022c6c85248efca767c9ecfaf8836617"};
//
//    [[AFNetAPIClient sharedJsonClient].setRequest(@"upload.php").Parameters(dic).filedata(data).name(@"Filedata").filename(@"Filedata.jpg").mimeType(@"image/jpeg") uploadfileWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"Success");
//    } progress:^(NSProgress *progress) {
//        NSLog(@"%@",progress);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error);
//    }];


//    // 下载文件
//    [[AFNetAPIClient sharedJsonClient].setRequest(@"http://120.25.226.186:32812/resources/videos/minion_02.mp4") downloadWithSuccess:^(NSURLResponse *response, NSURL *filePath) {
//        NSLog(@"Success");
//    } progress:^(NSProgress *progress) {
//        NSLog(@"%@",progress);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error);
//    }];

}

@end
