//
//  AFNetAPIClient.h
//  AFNet3.0
//
//  Created by MrJalen on 16/8/17.
//  Copyright © 2016年 Jalen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum {
    GET = 0,
    POST,
    PUT,
    DELETE
}HTTPMethod;

/**
 *  请求成功所走方法
 *
 *  @param response 请求返还的数据
 */
typedef void (^JLResponseSuccess)(NSURLSessionDataTask * task,id responseObject);

/**
 *  请求错误所走方法
 *
 *  @param error 请求错误返还的信息
 */
typedef void (^JLResponseFail)(NSURLSessionDataTask * task, NSError * error);

/**
 *  进度条
 *
 *  @param progress
 */
typedef void (^JLProgress)(NSProgress *progress);

/**
 *  上传文件成功回调
 *
 *  @param response response
 *  @param filePath filePath
 */
typedef void(^JLFileSuccess)(NSURLResponse * response,NSURL * filePath);

@interface AFNetAPIClient : AFHTTPSessionManager

+ (AFNetAPIClient *)sharedJsonClient;

/** 网络壮态 */
- (void)netWorkReachability;

/** 请求网址 */
- (AFNetAPIClient* (^)(NSString * url))setRequest;

/** 请求类型，默认为GET */
- (AFNetAPIClient* (^)(HTTPMethod type))RequestType;

/** 请求参数 */
- (AFNetAPIClient* (^)(id parameters))Parameters;

/** 请求头 */
- (AFNetAPIClient* (^)(NSDictionary * HTTPHeaderDic))HTTPHeader;


//................................下面是上传文件................................//
/** 上传的文件NSData */
- (AFNetAPIClient* (^)(NSData * file_data))filedata;

/** 上传的文件的参数名 */
- (AFNetAPIClient* (^)(NSString * name))name;

/** 上传的文件的文件名（要有后缀名）*/
- (AFNetAPIClient* (^)(NSString * filename))filename;

/** 上传的文件的文件类型 */
- (AFNetAPIClient* (^)(NSString * mimeType))mimeType;

//................................... end ...................................//

/**
 *  发送请求
 *
 *  @param Success  成功的回调
 *  @param Progress 进度的回调
 *  @param Fail     请求错误的回调
 */
- (void)startRequestWithSuccess:(JLResponseSuccess)Success progress:(JLProgress)Progress failure:(JLResponseFail)Fail;

/**
 *  上传文件
 *
 *  @param Success  成功的回调
 *  @param Progress 进度的回调
 *  @param Fail     请求错误的
 */
- (void)uploadfileWithSuccess:(JLResponseSuccess)Success progress:(JLProgress)Progress failure:(JLResponseFail)Fail;

/**
 *  下载文件
 *
 *  @param Success  成功的回调
 *  @param Progress 进度的回调
 *  @param Fail     请求错误的
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，重新开启下载调用resume方法
 */
- (NSURLSessionDownloadTask *)downloadWithSuccess:(JLFileSuccess)WSuccess progress:(JLProgress)Progress failure:(JLResponseFail)Fail;

/**
 *  取消所有网络请求
 */
- (void)cancelAllRequest;

@end
