//
//  AFNetAPIClient.m
//  AFNet3.0
//
//  Created by MrJalen on 16/8/17.
//  Copyright © 2016年 Jalen. All rights reserved.
//

#import "AFNetAPIClient.h"

@interface AFNetAPIClient ()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) HTTPMethod wRequestType;
@property (nonatomic, strong) NSData *File_data;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Filename;
@property (nonatomic, copy) NSString *MimeType;
@property (nonatomic, copy) id parameters;
@property (nonatomic, copy) NSDictionary * wHTTPHeader;

@end

@implementation AFNetAPIClient

+ (AFNetAPIClient *)sharedJsonClient {
    static dispatch_once_t  onceToken;
    static AFNetAPIClient * setSharedInstance;
    
    dispatch_once(&onceToken, ^{
        setSharedInstance = [[AFNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.93hgz.com/"]];
        
    });
    return setSharedInstance;
}

- (void)netWorkReachability {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"未知信号");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"手机信号");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"wiFi信号");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"没有信号");
            }
                break;
                
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        // 返回类型默认JSON
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        // 超时时间
        self.requestSerializer.timeoutInterval = 30;
        // 返回格式
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"image/jpeg", @"image/png", nil];
        // 请求格式
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        self.securityPolicy = [self customSecurityPolicy];

    }
    return self;
}

- (AFNetAPIClient *(^)(NSString *))setRequest {
    return ^AFNetAPIClient* (NSString * url) {
        self.url = url;
        return self;
    };
}

- (AFNetAPIClient *(^)(HTTPMethod))RequestType {
    return ^AFNetAPIClient* (HTTPMethod type) {
        self.wRequestType = type;
        return self;
    };
}

- (AFNetAPIClient* (^)(id parameters))Parameters {
    return ^AFNetAPIClient* (id parameters) {
        self.parameters = parameters;
        return self;
    };
}

- (AFNetAPIClient *(^)(NSDictionary *))HTTPHeader {
    return ^AFNetAPIClient* (NSDictionary * HTTPHeaderDic) {
        self.wHTTPHeader = HTTPHeaderDic;
        return self;
    };
}

- (AFNetAPIClient* (^)(NSData * file_data))filedata {
    return ^AFNetAPIClient* (NSData * file_data) {
        self.File_data = file_data;
        return self;
    };
}

- (AFNetAPIClient* (^)(NSString * name))name {
    return ^AFNetAPIClient* (NSString * name) {
        self.Name = name;
        return self;
    };
}

- (AFNetAPIClient* (^)(NSString * filename))filename {
    return ^AFNetAPIClient* (NSString * filename) {
        self.Filename = filename;
        return self;
    };
}

- (AFNetAPIClient* (^)(NSString * mimeType))mimeType {
    return ^AFNetAPIClient* (NSString * mimeType) {
        self.MimeType = mimeType;
        return self;
    };
}

/**
 *  发送请求
 *
 *  @param Success  成功的回调
 *  @param Progress 进度的回调
 *  @param Fail     请求错误的回调
 */
- (void)startRequestWithSuccess:(JLResponseSuccess)Success progress:(JLProgress)Progress failure:(JLResponseFail)Fail {

    AFNetAPIClient * manager = [[self class] sharedJsonClient];
    //设置请求头
    [self setupHTTPHeaderWithManager:manager];

    switch (self.wRequestType) {
        case GET: {
            [manager GET:self.url parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                Progress(downloadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                Success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                Fail(task,error);
            }];
        }
            break;

        case POST: {
            [manager POST:self.url parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                Progress(downloadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                Success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                Fail(task,error);
            }];
        }
            break;

        case PUT: {
            [manager PUT:self.url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                Success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                Fail(task,error);
            }];
        }
            break;

        case DELETE: {
            [manager DELETE:self.url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                Success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                Fail(task,error);
            }];
        }
            break;

        default:
            break;
    }

}

/**
 *  上传文件
 *
 *  @param Success  成功的回调
 *  @param Progress 进度的回调
 *  @param Fail     请求错误的
 */
- (void)uploadfileWithSuccess:(JLResponseSuccess)Success progress:(JLProgress)Progress failure:(JLResponseFail)Fail {
    AFNetAPIClient * manager = [[self class] sharedJsonClient];
    [manager POST:self.url parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.File_data name:self.Name fileName:self.Filename mimeType:self.MimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        Progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Fail(task,error);
    }];
}

/**
 *  下载文件
 *
 *  @param Success  成功的回调
 *  @param Progress 进度的回调
 *  @param Fail     请求错误的
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，重新开启下载调用resume方法
 */
- (NSURLSessionDownloadTask *)downloadWithSuccess:(JLFileSuccess)Success progress:(JLProgress)Progress failure:(JLResponseFail)Fail {
    AFNetAPIClient * manager = [[self class] sharedJsonClient];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    NSURLSessionDownloadTask *downloadtask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        Progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //保存文件url (可自己改)
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSURL *fileUrl = [NSURL fileURLWithPath:cachesPath];

        return [fileUrl URLByAppendingPathComponent:[response suggestedFilename]];

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            Fail(nil,error);
        }
        else{
            Success(response,filePath);
        }
    }];
    [downloadtask resume];
    return  downloadtask;
}

- (AFNetAPIClient *)setupHTTPHeaderWithManager:(AFNetAPIClient *)manager {
    for (NSString * key in self.wHTTPHeader.allKeys) {
        [manager.requestSerializer setValue:self.wHTTPHeader[key] forHTTPHeaderField:key];
    }
    return manager;
}

- (void)cancelAllRequest {
    [self.operationQueue cancelAllOperations];
}

#pragma mark - https认证
- (AFSecurityPolicy*)customSecurityPolicy {
    // 先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxxx" ofType:@"cer"]; //证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    NSSet * set = [NSSet setWithObject:certData];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}


@end
