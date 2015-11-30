//
//  FCSException.h
//  mar_client_iphone
//
//  Created by Melvin on 11-9-6.
//  Copyright 2011 Mar114. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FCSException : NSException
{
}

- (id) initWithReason: (NSString*) aReason
             userInfo: (NSDictionary*) aUserInfo;

- (id) initWithReason: (NSString*) aReason;
@end

@interface RetException : FCSException
{
}
@end

@interface ExitException : RetException
{
}
@end