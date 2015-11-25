//
//  ZGRequest.m
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/24.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import "ZGRequest.h"
#import "ZGNetworkConfig.h"
#import "ZGNetworkPrivate.h"

@interface ZGRequest ()
@property (strong, nonatomic) id cacheJson;

@end

@implementation ZGRequest

- (NSInteger) cacheTimeInSeconds{

    return -1;
}
- (long long)cacheVersion{

    return 0;
}

- (id)cacheSensitiveData{
    return nil;
}

- (void)checkDirectory:(NSString *)path{
    BOOL isDir;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        
    }else
    {
        if (!isDir) {
            NSError *error =nil;
            [fileManager removeItemAtPath:path error:&error];
        }
    
    }

}

- (void)createBaseDirectoryAtPath:(NSString *)path{
    __autoreleasing NSError *error =nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                             withIntermediateDirectories :YES
                                              attributes :nil
                                                   error :&error];
    if (error) {
        ZGLog(@"create cache directory failed, error=%@",error);
    }else{
        
    }
        




}


@end
