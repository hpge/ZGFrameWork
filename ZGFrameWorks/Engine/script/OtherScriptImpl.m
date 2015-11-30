//
//  OtherScriptImpl.m
//  mar_client_iphone
//
//  Created by Melvin on 12-2-28.
//  Copyright (c) 2012年 Mar114. All rights reserved.
//

#import "OtherScriptImpl.h"
//#import "NetWork.h"
#import "ClientConstants.h"
//#import "TimeUtil.h"
//#import "SqliteUtil.h"
#import "ZGUIConstants.h"
//#import "AlixPayInterface.h"
#import <MessageUI/MessageUI.h>
//#import "MessageUtil.h"

@implementation OtherScriptImpl

//- (NSString*) getCurrentTime: (NSArray*) params
//{
//  NSString* dateFormat = nil;
//  if (!params || [params count] < 1)
//  {
//    dateFormat = DEFAULT_DATE_FORMAT;
//  } else {
//    dateFormat = [params objectAtIndex: 0];
//  }
//  return [TimeUtil stringWithDateFormat: dateFormat];
//}
//
//- (NSString*) generateTransSeq: (NSArray*) params
//{
//  NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
//  return [NSString stringWithFormat: @"iphone%.0f", timeInterval * 1000];
//}
//
//- (FCBoolean*) isnull: (NSArray*) params
//{
//  BOOL result = YES;
//  if (params)
//  {
//    id temp = [params objectAtIndex:0];
//    if (!temp)
//    {
//      result = NO;
//    } else if ([temp isKindOfClass: [NSString class]])
//    {
//      result = [(NSString*)temp isEqualToString: NULL_STRING_VALUE];
//    } else {
//      result = NO;
//    }
//  }
//  return [FCBoolean boolWithBool: result];
//}
//
///**
// * 生成时间描述字符串 1小时内显示分钟数 1天内显示小时数 3天内显示天数 其余显示日期yyyy-mm-dd
// */
//- (NSString*) convertTimeInfo: (NSArray*) params
//{
//  id obj = [params objectAtIndex: 0];
//  if (obj)
//  {
//    NSString* result = nil;
//    double intervalTime = [obj doubleValue] / 1000;
//    double nowIntervalTime = [[NSDate date] timeIntervalSince1970];
//    double delt = nowIntervalTime - intervalTime;
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970: intervalTime];
//    if (delt < 0)
//    {
//      result = [TimeUtil stringWithDate: date Format: DEFAULT_DATE_FORMAT];
//    }
//    else if (delt < 60 * 60)
//    {
//      result = [NSString stringWithFormat: @"%f分钟前", delt / 60];
//    } else if (delt < 24 * 60 * 60)
//    {
//      result = [NSString stringWithFormat: @"%f小时前", delt / 60 * 60];
//    } else if (delt < 3 * 24 * 60 * 60)
//    {
//      result = [NSString stringWithFormat: @"%f天前", delt / 24 * 60 * 60];
//    } else
//    {
//      result = [TimeUtil stringWithDate: date Format: DEFAULT_DATE_FORMAT];
//    }
//    return result;
//  }
//  return NULL_STRING_VALUE;
//}
//
//- (NSString*) getimgurl: (NSArray*) params
//{
//  return IMAGE_SERVICE_URL;
//}
//
//- (void) clearfocus: (NSArray*) params
//{
//  return;
//}
//
//- (NSArray*) queryfieldarray: (NSArray*) params
//{
//  NSArray* contentArray = [NSArray array];
//  NSString* table = [params objectAtIndex:0];
//  NSString* column = [params objectAtIndex:1];
//  BOOL sql = [[SqliteUtil getInstence] openSql];
//  if (sql)
//  {
//    contentArray = [[SqliteUtil getInstence] getDataFromTable:table ByColumn:column];
//    [[SqliteUtil getInstence] closeSql];
//  }
//  return contentArray;
//}
//
//- (void) execsqls: (NSArray*) params
//{
//  NSArray* sqlArray = [params objectAtIndex:0];
//  [[SqliteUtil getInstence] openSql];
//  for (id sqlStr in sqlArray) {
//    LOG(@"sqlStr : %@", sqlStr);
//    [[SqliteUtil getInstence] insertOrDeleteData:sqlStr];
//  }
//  [[SqliteUtil getInstence] closeSql];
//  return;
//}

- (void) branchs: (NSArray*) params
{
  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil 
                                                      message:nil 
                                                     delegate:self 
                                            cancelButtonTitle:@"取消" 
                                            otherButtonTitles:@"分享到短信", @"分享到邮件", nil];
  [alertView show];
  return;
}

- (void) alertView: (UIAlertView*) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
  LOG(@"User selected button %ld", (long)buttonIndex);
  switch (buttonIndex) {
    case SMS:
    {
      NSURL *phoneNumberURL = [NSURL URLWithString:@"sms:"];
      LOG(@"send sms, URL = %@", phoneNumberURL);
      [[UIApplication sharedApplication] openURL:phoneNumberURL];
/*
      MessageUtil* msg = [[MessageUtil alloc] init];
      [msg messageUI];
      [msg release];
*/
    }
      break;
    case MAIL:
    {
      NSURL *phoneNumberURL = [NSURL URLWithString:@"mailto:"];
      LOG(@"send mail, URL = %@", phoneNumberURL);
      [[UIApplication sharedApplication] openURL:phoneNumberURL];
    }
/*    {
      if ([MFMailComposeViewController canSendMail]) {  
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];  
        [mailViewController setSubject:@"来自朋友的分享"];  
        //  [mailViewController addAttachmentData:[NSData dataWithData:UIImagePNGRepresentation(((EGOPhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image)] mimeType:@"png" fileName:@"Photo.png"];  
        
        NSString *msg = [NSString stringWithFormat:@"我有个文件想要分享给你，放在LeadTone手机邮箱套件上，可以通过下面链接访问：\r\n %@",url ];  
        
        [mailViewController setMessageBody:msg isHTML:NO];  
        mailViewController.mailComposeDelegate = self;  
        
        
        [self presentModalViewController:mailViewController animated:YES];  
        [mailViewController release];  
      }  
      else   {  
        alertToCustomMessage(@"请设置系统邮件！");  
      } 
    }*/
      break;
    default:
      break;
  }
}

- (void) makecall: (NSArray*) params
{
  NSMutableString* phoneNumber = [NSMutableString stringWithString:@"tel:"];
  [phoneNumber appendString:[params objectAtIndex:0]];
  LOG(@"phoneNumber : %@", phoneNumber);
  [[UIApplication sharedApplication] openURL: [NSURL URLWithString:phoneNumber]];
}
/**
 *  支付调用方法
 *
 *  @param params 参数
 *
 *  @return 返回字符
 */
- (NSString*) pay: (NSArray*) params
{
	if ([params count] < 4)
		return nil;
	NSString* orderId = [params objectAtIndex: 0];
	NSString* unknown = [params objectAtIndex: 1];
	NSString* name = [params objectAtIndex: 2];
	NSString* desc = [params objectAtIndex: 3];
	float price = [[params objectAtIndex: 4] floatValue];
//	[AlixPayInterface alixpay: orderId productName: name productDesc: desc price: price];
  return nil;
}

@end
