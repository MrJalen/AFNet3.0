# AFNetworking3.0

AFNetworking  3.0.0 链式编程封装


1. 注意导入SSL安全证书

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


2. 发送请求

  [[AFNetAPIClient sharedJsonClient].setRequest(@"getjobs").RequestType(GET).Parameters(@{@"pagenum":@(1)}) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success");
    } progress:^(NSProgress *progress) {
        NSLog(@"%@",progress);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
3. 下载文件

  [[AFNetAPIClient sharedJsonClient].setRequest(@"http://120.25.226.186:32812/resources/videos/minion_02.mp4") downloadWithSuccess:^(NSURLResponse *response, NSURL *filePath) {
        NSLog(@"Success");
    } progress:^(NSProgress *progress) {
        NSLog(@"%@",progress);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
4. 上传图片

  UIImage *img = [UIImage imageNamed:@"1"];

    NSData *data = UIImageJPEGRepresentation(img, 0.5);

    NSDictionary *dic = @{@"timestamp" : @"1457403110",
                          @"file"      : data,
                          @"xtype"     :@"bang_album",
                          @"token"     : @"8a3dead8022c6c85248efca767c9ecfaf8836617"};

    [[AFNetAPIClient sharedJsonClient].setRequest(@"upload.php").Parameters(dic).filedata(data).name(@"Filedata").filename(@"Filedata.jpg").mimeType(@"image/jpeg") uploadfileWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success");
    } progress:^(NSProgress *progress) {
        NSLog(@"%@",progress);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
