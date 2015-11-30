//
//  FCScriptImpl.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 11-7-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FCScriptImpl.h"
#import "FCBoolean.h"
#import "FCFuncEntry.h"
#import "CompontentParser.h"
#import "OtherUtils.h"
#import "FCSException.h"
#import "FileUtils.h"
#import "FCSession.h"
#import "Service.h"
#import "MapUtil.h"
#import "JSONParser.h"
#import "OtherScriptImpl.h"
#import "MarUIConstants.h"
#import "ClientConstants.h"
#import "CustomWaitView.h"
#import "SBJsonWriter.h"
#import "MBProgressHUD.h"

#define NEED_UPDATE 90002
#define NEED_LOGOUT 90003

extern UIWindow* g_window;

@implementation FCScriptImpl

@synthesize context;

static MBProgressHUD* waitView;
static OtherScriptImpl* otherScript;
static NSArray* sessionArray;
static NSArray* nativedataArray;
static NSMutableArray* openpageArray;

+ (void) load
{
  otherScript = [[OtherScriptImpl alloc] init];
}

/** 全局释放内存方法
 *
 *  释放静态变量
 */
+ (void) staticFree
{
	[otherScript release];
  [waitView release];
}

- (id) init {
  if (self = [super init])
  {
    self.context = nil;
  }
  return self;
}

/**
 * 构造方法.
 * 
 * @param hashtable
 *            公共控件列表
 * @param context
 *            上下文
 */
- (id) initWithContext: (id) _context
{
  self = [self init];
  self.context = _context;
  return self;
}

/**
 * 扩展Script方法.
 * 
 * @param name
 *            fcscript方法名
 * @param param
 *            参数
 * @return Object function对应的值
 */
- (id) callFunctionString: (NSString*) name 
                    Array: (NSMutableArray*) param {
  id obj = nil;
  //    name = [name lowercaseString];
  FCFuncEntry* func = [parser.funcs objectForKey: name];
  if (func)
  {
    obj = [parser callFunction: name Array: param];
    LOG(@"function result : %@", obj);
  } else {
    SEL defFunc = NSSelectorFromString([NSString stringWithFormat: @"%@:", name]);
    if (defFunc && [self respondsToSelector: defFunc])
      obj = [self performSelector: defFunc withObject: param];
    else if (defFunc && [otherScript respondsToSelector: defFunc])
      obj = [otherScript performSelector: defFunc withObject: param];
    else
      [parser parseError: [NSString stringWithFormat: @"can't find func with name: %@", name]];
  }
  return obj;
}

/**
 * 增加控件. 根据控件名找到布局，在该布局中加入一些控件或布局.
 * 
 * @param layoutName
 *            布局名称
 * @param xml
 *            新增控件XML
 * @param index
 *            控件在布局中的位置 如：<button name="login" height="110" width="100"
 *            action="" bgImg="card3.png" selectedImg="card_3.png"/> <button
 *            name="login" height="110" width="100" action=""
 *            bgImg="card3.png" selectedImg="card_3.png"/>
 * @throws Exception
 */
- (void) addWidgetsString: (NSString*) layoutName 
                   String: (NSString*) xml
                      Int: (int) widgetindex
{
  //            MarContainer* curLayout = (MarContainer*) WidgetManager._nameTable.get(layoutName);
  //            
  //            SAXHandler saxHandle = new SAXHandler(context, curLayout,
  //                                                  ((TemplateActivity) context).getAllImages(), widgetindex);
  //            StringBuffer sb = new StringBuffer();
  //            sb.append(Constants.ROOT_STAGE);
  //            sb.append(xml);
  //            sb.append(Constants.ROOT_ETAGE);
  //            // FCThreadPools.getInstance().reset();
  //            android.util.Xml.parse(sb.toString(), saxHandle);
  //            if (FCThreadPools.getInstance().isFinish()) {
  //                
  //                layout.reset();
  //                layout.adjust();
  //            }
}

- (void) resetLayout: (MarContainer*) iLayout
{
  //        iLayout.setFCWidth(0);
  //        iLayout.setFCHeight(0);
  //        for(int i=0;i<iLayout.getChildCount();i++)
  //        {
  //             MarCompontent* widget = ( MarCompontent*)iLayout.getChildAt(i);
  //            if(widget instanceof MarContainer*)
  //            {
  //                resetLayout((MarContainer*)widget);
  //            }
  //            else
  //            {
  //                widget.setFCWidth(0);
  //                widget.setFCHeight(0);
  //            }
  //        }
}

- (void) addWidgets: (NSArray*) arrayParam
{
  NSString* layoutName = [arrayParam objectAtIndex:0];
  NSString* xml = [arrayParam objectAtIndex:1];
  //    LOG(@"xml = %@", xml);
  xml = [NSString stringWithFormat: @"%@%@%@", @"<layout>", xml, @"</layout>"];
  CompontentParser* xmlParser = [[CompontentParser alloc] initWithCompontentParser: [CompontentParser getInstance]];
  MarContainer* showContainer = xmlParser.currShowContainer;
  MarCompontent* targetCompontent = [showContainer getChildCompontentByID: layoutName];
  NSData* data = [OtherUtils dataWithXMLString: xml];
  MarContainer* newContainer = (MarContainer*) [xmlParser doXMLParser: data];
  for (MarCompontent* compontent in newContainer.childCompontents)
  {
    if ([targetCompontent isKindOfClass:[MarContainer class]]) {
      [(MarContainer*)targetCompontent addChildComontent: compontent];
      compontent.rootNode = targetCompontent.rootNode;
    }
  }
  [xmlParser.currShowContainer rePaint: nil];
  [xmlParser release];
  return;
}

/**
 * 重新设置控件. 根据控件名找到布局，把该布局里控件先清空，重新加入新的控件.
 * 
 * @param layoutName
 *            布局名称
 * @param xml
 *            控件XML
 * @throws Exception
 */
- (void) setWidgets:(NSArray*) arrayParam
{
  NSString* layoutName = [arrayParam objectAtIndex:0];
  NSString* xml = [arrayParam objectAtIndex:1];
  LOG(@"%@", layoutName);
  LOG(@"%@", xml);
  xml = [NSString stringWithFormat: @"%@%@%@", @"<layout>", xml, @"</layout>"];
  CompontentParser* xmlParser = [CompontentParser getInstance];
  MarContainer* showContainer = xmlParser.currShowContainer;
  MarCompontent* targetCompontent = [showContainer getChildCompontentByID: layoutName];
  //移除所有组件
  if ([targetCompontent isKindOfClass: [MarContainer class]])
  {
    [(MarContainer*)targetCompontent removeAllChildCompontent];
  }
  NSData* data = [OtherUtils dataWithXMLString: xml];
  MarContainer* newContainer = (MarContainer*) [xmlParser doXMLParser: data];
  for (MarCompontent* compontent in newContainer.childCompontents)
  {
    if ([targetCompontent isKindOfClass:[MarContainer class]]) {
      [(MarContainer*)targetCompontent addChildComontent: compontent];
    }
  }
  [showContainer rePaint: nil];
//  [targetCompontent rePaint:showContainer];
}

/**
 * 通过控件名删除控件. 根据控件名找到布局，把该布局里控件先清空，重新加入新的控件.
 * 
 * @param layoutName
 *            布局名
 * @param name
 *            控件名称
 * @throws Exception
 */
- (void) removeWidgetString: (NSString*) layoutName
                     String: (NSString*) name
{
  CompontentParser* xmlParser = [CompontentParser getInstance];
  MarContainer* showContainer = xmlParser.currShowContainer;
  MarCompontent* targetCompontent = [showContainer getChildCompontentByID: layoutName];
  if ([targetCompontent isKindOfClass: [MarContainer class]])
  {
    [(MarContainer*)targetCompontent removeChildCompontent: name];
  }
  [showContainer rePaint: nil];
//  [targetCompontent rePaint:showContainer];
}

/**
 * 更改Radiogroup选项.
 * 
 * @param name
 *            控件名称
 * @param type
 *            类型
 * @throws FCSException
 */
- (void) changeGroupString:(NSString*) name Int: (int) type {
  //        widget = ( MarCompontent*) _hashtable.get(name);
  //        if (widget instanceof FCRadioGroup) {
  //            switch (type) {
  //                    
  //                case TOP: {
  //                    ((FCRadioGroup) widget).goFirst();
  //                    break;
  //                }
  //                case UP: {
  //                    ((FCRadioGroup) widget).goUp();
  //                    break;
  //                }
  //                case DOWN: {
  //                    ((FCRadioGroup) widget).goDown();
  //                    break;
  //                }
  //                case BOTTOM: {
  //                    ((FCRadioGroup) widget).goLast();
  //                    break;
  //                }
  //                default: {
  //                    break;
  //                }
  //            }
  //        }
}

/**
 * 设置控件Item.
 * 
 * @param widgetName
 *            控件名
 * @param itemText
 *            item文本
 * @param itemValue
 *            item值
 * @param checked
 *            item是否选中
 * @throws Exception
 */
- (void) setWidgetItemAttribute: (NSArray*) widgeArray
{
  NSString* widgetName = [widgeArray objectAtIndex: 0];
  NSString* itemText = [widgeArray objectAtIndex: 1];
  NSString* itemValue = [widgeArray objectAtIndex: 2];
  NSString* checkedOrAction = [widgeArray objectAtIndex: 3];
  LOG(@"%@", checkedOrAction);
  widget = [layout getChildCompontentByID:widgetName];
  [widget setWidgetAttributeName:itemText AttributeVale:itemValue];
}

- (NSString*) getWidgetItemAttribute: (NSArray*) widgeArray
{
  NSString* widgetName = [widgeArray objectAtIndex:0];
  NSString* itemText = [widgeArray objectAtIndex:1];
  widget = [layout getChildCompontentByID:widgetName];
  NSString* itemValue = [widget.propertiesMap objectForKey:itemText];
  return itemValue;
}

- (void) setWidgetAttrValue: (NSArray*) widgeArray
{
  NSString* widgetName = [widgeArray objectAtIndex:0];
  NSString* itemText = [widgeArray objectAtIndex:1];
  NSString* itemValue = [widgeArray objectAtIndex:2];
  layout = [MarPage getCurrentPage];
  widget = [layout getChildCompontentByID:widgetName];
  [widget setWidgetAttributeName:itemText AttributeVale:itemValue];
}

/**
 * 添加Item.
 * 
 * @param widgetName
 *            控件名
 * @param itemText
 *            item文本
 * @param itemValue
 *            item值
 * @param checked
 *            item是否选中
 * @throws Exception
 */
- (void) addWidgetItemName: (NSString*) widgetName 
                  showText: (NSString*) itemText 
                     value: (NSString*) itemValue 
                   checked: (NSString*) checkedOrAction
{
  //        widget = ( MarCompontent*) _hashtable.get(widgetName);
  //        if (widget instanceof FCRadioGroup) {
  //            ((FCRadioGroup) widget).addItem(itemText, itemValue);
  //        } else if (widget instanceof FCCheckboxGroup) {// checkbox±ÿ—°æ≠π˝Ãÿ ‚¥¶¿Ì
  //            ((FCCheckboxGroup) widget).addItem(itemText, itemValue, Boolean
  //                                               .parseBoolean(checkedOrAction));
  //        } else if (widget instanceof FCTitle) {
  //            ((FCTitle) widget).addItem(itemText, itemValue, checkedOrAction);
  //        } else if (widget instanceof FCComboBox) {
  //            ((FCComboBox) widget).addItem(itemText, itemValue);
  //        }
  //        if (FCThreadPools.getInstance().isFinish()) {
  //            layout.reset();
  //            layout.adjust();
  //        }
}

/**
 * 设置控件值.
 * 
 * @param widgetName
 *            控件名
 * @param params
 *            参数
 * @param type
 *            操作类型
 * @throws FCSException
 */
- (void) setWidgetSingleString: (NSString*) widgetName 
                        String: (NSString*) params 
                           Int: (int) type
{
  //        widget = ( MarCompontent*) _hashtable.get(widgetName);
  //        boolean isAdjust = false;
  //        switch (type) {
  //            case SETVALUE: {
  //                widget.setValue(params);
  //                //added by zhumx
  //                isAdjust = true;
  //                break;
  //            }
  //                
  //            case SETTEXT: {
  //                widget.setFCText(params);
  //                isAdjust = true;
  //                break;
  //            }
  //                
  //            case CHANGE_ROWS: {
  //                if (widget instanceof FCTextArea) {
  //                    ((FCTextArea) widget).setLineNum(Integer.parseInt(params));
  //                }
  //                isAdjust = true;
  //                break;
  //            }
  //                
  //            case SETACTION: {
  //                widget.setAction(params);
  //                break;
  //            }
  //            case CHANGE_FONTSIZE: {
  //                widget.setFontSize(Integer.parseInt(params));
  //                isAdjust = true;
  //                break;
  //            }
  //            case CHANGE_FONTCOLOR: {
  //                widget.setFontColor(Color.parseColor(params));
  //                isAdjust = true;
  //                break;
  //            }
  //            case CHANGE_ALIGN: {
  //                widget.setAlign(Integer.parseInt(params));
  //                isAdjust = true;
  //                break;
  //            }
  //            case CHANGE_WIDTH: {
  //                widget.setFCBGWidth(Integer.parseInt(params));
  //                isAdjust = true;
  //                break;
  //            }
  //            case CHANGE_HEIGHT: {
  //                widget.setFCBGHeight(Integer.parseInt(params));
  //                isAdjust = true;
  //                break;
  //            }
  //            case CHANGE_X: {
  //                widget.setBGX(Integer.parseInt(params));
  //                isAdjust = true;
  //                break;
  //            }
  //            case CHANGE_Y: {
  //                widget.setBGY(Integer.parseInt(params));
  //                isAdjust = true;
  //                break;
  //            }
  //            case CHANGE_TYPE: {
  //                if (widget instanceof FCInput) {
  //                    ((FCInput) widget).setType(Integer.parseInt(params));
  //                } else if (widget instanceof FCTextArea) {
  //                    ((FCTextArea) widget).setType(Integer.parseInt(params));
  //                }
  //                isAdjust = true;
  //                break;
  //            }
  //            case CHANGE_FORM: {
  //                if ("ver".equalsIgnoreCase(params)) {
  //                    widget.setOrientation( MarCompontent*.VERTICAL);
  //                } else if ("hor".equalsIgnoreCase(params)) {
  //                    widget.setOrientation( MarCompontent*.HORIZONTAL);
  //                }
  //                isAdjust = true;
  //                break;
  //            }
  //            case CHANGE_SELECTEDCOLOR: {
  //                widget.setSelectedColor(Color.parseColor(params));
  //                isAdjust = true;
  //                break;
  //            }
  //            case CHANGE_BGCOLOR: {
  //                widget.setSelectedColor(Color.parseColor(params));
  //                isAdjust = true;
  //                break;
  //            }
  //            case CHANGE_BGIMG:{
  //                try{
  //                    Bitmap bitmap=ImageUtil.getBitmapByPath(params, context);
  //                    widget.setFCBackground(bitmap);
  //                    isAdjust = false;
  //                }
  //                catch(Exception ex)
  //                {
  //                    FCLog.e(TAG, ex.getMessage(), ex);
  //                }
  //            }
  //            default: {
  //                break;
  //            }
  //        }
  //        
  //        if (isAdjust) {// –Ë“™÷ÿ–¬ªÊ÷∆
  //            layout.reset();
  //            layout.adjust();
  //            isAdjust = false;
  //        }
  
}

/**
 * 改变控件选中状态(FCCheckboxGroup).
 * 
 * @param widgetName
 *            控件名
 * @param status
 *            状态
 * @throws FCSException
 */
- (void) changeWidgetItemStatus: (NSArray*) paramArray
{
  NSString* widgetName = [paramArray objectAtIndex: 0];
  //  int selectedIndex = [[paramArray objectAtIndex: 1] intValue];
  //  BOOL status = [[paramArray objectAtIndex: 2] boolValue];
  CompontentParser* xmlParser = [CompontentParser getInstance];
  MarContainer* showContainer = [xmlParser currShowContainer];
  [showContainer getChildCompontentByID: widgetName];
}

/**
 * 切换皮肤
 * 
 * @param script
 *            FCScriptImpl
 * @param param
 *            其中param[0]:string 控件名称,param[1]:int 控件的哪一项,param[2]:boolean
 *            状态值
 * @throws FCSException
 */
- (void) changeSkin: (NSString*) cssName {
  //        if (cssName == null || cssName.length() == 0
  //            || "default".equals(cssName)) {
  //            cssName = Constants.CSS_STYLE_DEFOULT;
  //        }
  //        WidgetUtil.parseCSS(false, cssName, context);
  //        
  //        ((FCPage) context).refreshLayout(null);
}

/**
 * 通过布局名删除布局里所有控件.
 * 
 * @param layoutName
 *            布局名称
 * @throws Exception
 * @throws FCSException
 */
- (void) clearWidgets:(NSString*) layoutName
{
  CompontentParser* xmlParser = [CompontentParser getInstance];
  MarContainer* showContainer = [xmlParser currShowContainer];
  MarCompontent* targetContainer = [showContainer getChildCompontentByID: layoutName];
  if ([targetContainer isKindOfClass: [MarContainer class]])
  {
    [(MarContainer*)targetContainer removeAllChildCompontent];
  }
}

/**
 * 通过布局名查找对应控件的属性值
 * 
 * @param layoutName
 *            布局名称
 * @throws Exception
 * @throws FCSException
 */
- (NSString*) getWidgetValue: (NSArray*) compententName
{
  NSString* compontentID = [compententName objectAtIndex:0];
  CompontentParser* xmlParser = [CompontentParser getInstance];
  MarContainer* showContainer = [xmlParser currShowContainer];
  MarCompontent* targetContainer = [showContainer getChildCompontentByID: compontentID];
  return [targetContainer getWidgetValue];
}

/**
 * 通过布局名查找对应控件的属性值
 * 
 * @param layoutName
 *            布局名称
 * @throws Exception
 * @throws FCSException
 */
- (void) setWidgetValue: (NSArray*) compententName
{
  NSString* compontentID = [compententName objectAtIndex:0];
  CompontentParser* xmlParser = [CompontentParser getInstance];
  MarContainer* showContainer = [xmlParser currShowContainer];
  MarCompontent* targetContainer = [showContainer getChildCompontentByID: compontentID];
  [targetContainer setWidgetValue: [compententName objectAtIndex: 1]];
}

/**
 * 页面跳转获取参数,根据从参数名称查找对应的参数值.
 * 
 * @param OpenpageVlaue
 *            参数列表
 * @param param
 *            参数
 * @return String 参数值
 */
- (NSString*) getParameter: (NSMutableArray*) param
{
  CompontentParser* xmlParser = [CompontentParser getInstance];
  MarContainer* showContainer = [xmlParser currShowContainer];
  if ([param count] > 0)
  {
    return [showContainer getAttribute: [param objectAtIndex: 0]];
  }
  return nil;
}

/**
 * 跳转页面,根据返回的结果直接显示
 * 
 * @param param
 *            参数
 * @throws FCSException
 */
- (void) openPageByXml: (NSString*) xml
{
  NSData* data = [OtherUtils dataWithXMLString: xml];
  CompontentParser* xmlParser = [CompontentParser getInstance];
  MarContainer* targetContainer = xmlParser.currShowContainer;
  MarContainer* switchToContainer = (MarContainer*) [xmlParser doXMLParser: data];
  [targetContainer switchToAnother: switchToContainer];
}

/**
 * 跳转页面.
 * 
 * @param param
 *            参数
 * @throws FCSException
 */
- (void) openPage: (NSMutableArray*) param
{
  NSMutableString* pageId = [NSMutableString stringWithString: [param objectAtIndex: 0]];
  if (!pageId)
    [[[[FCSException alloc] autorelease] initWithReason: @"No page name!"] raise];
  if (![pageId hasSuffix:@"xml"])
    [pageId appendString:@".xml"];
  NSData* xmlData = [FileUtils loadXMLFromResource: pageId];
  
  CompontentParser* xmlParser = [CompontentParser getInstance];
  MarContainer* switchToContainer = (MarContainer*) [xmlParser doXMLParser: xmlData];
  
  if ([param count] > 1)  // 对传入的参数进行分解
  {
    NSString* pageValue = (NSString*) [param objectAtIndex: 1];
    // 只有一个参数时就不会出现"&",在xml中使用其转义字符&amp;,否则会报错,或者在DTD文件中加入标签
    NSRange ampRange = [pageValue rangeOfString: @"&"];
    if (ampRange.location != NSNotFound)
    {
      for (NSString* pageValueItem in [pageValue componentsSeparatedByString: @"&"])
      {
        NSArray* s = [pageValueItem componentsSeparatedByString: @"="];
        [switchToContainer setAttributeByName: [s objectAtIndex: 0]
                                attributeVale: [s count] > 1 ? [s objectAtIndex: 1] : NULL_STRING_VALUE];
      }
    } else {
      NSArray* s = [pageValue componentsSeparatedByString: @"="];
      [switchToContainer setAttributeByName: [s objectAtIndex: 0]
                              attributeVale: [s count] > 1 ? [s objectAtIndex: 1] : NULL_STRING_VALUE];
    }
  }
  MarContainer* targetContainer = xmlParser.currShowContainer;
  [targetContainer switchToAnother: switchToContainer];
}

- (void) closepage: (NSArray*) param
{
  return;
}

- (void) connetBundle: (id) bundle 
               String: (NSString*) service_name 
               String: (NSString*) page_name
{
  //  TemplateActivity pageObject = ((TemplateActivity) context);
  //  // 显示Gauge表示联网
  //  pageObject.showGauge(null);
  //  try {
  //    // 如果本地没有就进行单个服务对比请求(联网)
  //    String response = FCNetHandle.newInstance().connectNormal(
  //      FCRequestXML.sendSSURequest(service_name));
  //    if (!pageObject.isOpenGauge()) {
  //      return;// 取消联网
  //    }
  //    if (response == null) {// 网络连接失败
  //      pageObject.notifyNetError();
  //      return;
  //    }
  //    
  //    // (解析)
  //    String result = FCResponseXML.parserSSUResponse(response, context);
  //    if (!pageObject.isOpenGauge()) {
  //      return;// 取消联网
  //    }
  //    if (Constants.ALL_SUCCESS.equals(result)) {
  //      // 再次重新查询获取路径
  //      String[] pagePath = new FCDBQuery(context).queryFilePathByName(
  //                                                                     service_name, page_name);
  //      bundle.putString(Constants.DEF_PAGE, pagePath[1]);// 把文件路径传过去使得显示
  //    }
  //  } catch (Exception e) {
  //    FCLog.e(TAG, e.getMessage(), e);
  //    pageObject.notifyNetError();
  //  } finally {
  //    pageObject.closeGauge();
  //  }
}

- (void) setSession:(NSArray*) arrayParam
{
  NSString* key = [arrayParam objectAtIndex:0];
  id obj = [arrayParam objectAtIndex:1];
  if (obj)
    [[FCSession getInstance] setSession:key Obj:obj];
}

- (id) getSession:(NSArray*) arrayParam
{
  NSString* key = [arrayParam objectAtIndex:0];
  id obj = [[FCSession getInstance] getSessionByKey:key];
  return obj;
}

- (void) removeSession:(NSArray*) arrayParam
{
  NSString* key = [arrayParam objectAtIndex:0];
  [[FCSession getInstance] removeSession:key];
}

- (void) clearSession:(NSArray*) arrayParam
{
  [[FCSession getInstance] clearSession];
}

- (void) showGauge: (NSArray*) arrayParam
{
  if (waitView)
  {
    [waitView release];
  }
  [self performSelectorInBackground: @selector(startAnimating) withObject: nil];
}

- (void) startAnimating
{
	waitView = [[MBProgressHUD alloc] initWithWindow: g_window];
  waitView.removeFromSuperViewOnHide = YES;
  waitView.dimBackground = NO;
  waitView.roundMaskGray = 0.60784314;
	[g_window addSubview: waitView];
  [g_window bringSubviewToFront: waitView];
  [waitView show: NO];
}

- (NSString*) sendrequest:(NSArray*) arrayParam
{
  NSString* xml = [arrayParam objectAtIndex: 0];
  if (xml)
  {
    NSString* data = [Service sendRequestByPostBody:xml];
    if (data)
    {
      LOG(@"%@", data);
      NSString* temp = [NSString stringWithString: data];
      return temp;
    }
  }
  return @"";
}

- (void) hideGauge:(NSArray*) arrayParam
{
  if (waitView)
  {
    [waitView hide: NO];
  }
}

/**
 * 获取结点
 * 
 * @param paramArray 参数数组
 *
 * @return 结点信息
 */
- (NSString*) getnodebytagname: (NSArray*) paramArray
{
  NSString* xml = [paramArray objectAtIndex:0];
  NSString* tageName = [paramArray objectAtIndex:1];
  NSData* xmlData = [OtherUtils dataWithXMLString:xml];
  
  XMLDataParser* xmlParser = [[XMLDataParser alloc] init];
  XMLNode* rootNode = [xmlParser doXMLParser:xmlData];
  XMLNode* node = [rootNode getSingleNodeByName:tageName];

  [xmlParser outPutNode];
  if (!node || !node.content) 
  {
    return nil;
  }
  NSString* nodeStr = [NSString stringWithString:node.content];
  [xmlParser release];

  return nodeStr;
}

/**
 * 获取结点内容
 * 
 * @param paramArray 参数数组
 *
 * @return 结点内容
 */
- (NSString*) getnodevalue: (NSArray*) arrayParam
{
  NSString* nodeStr = [arrayParam objectAtIndex:0];
  NSString* tagetext = nodeStr;
  return tagetext;
}

- (NSNumber*) stringLength:(NSArray*) arrayParam
{
  NSString* str = [arrayParam objectAtIndex:0];
  int length = [str length];
  return [NSNumber numberWithInt:length];
}

- (NSString*) getNativeData: (NSArray*) arrayParam
{
  NSDictionary* dict = [FileUtils readDictionaryFromFile: DATA_FILE_NAME];
  return [dict objectForKey: [arrayParam objectAtIndex: 0]];
}

- (void) SaveNativeData: (NSArray*) arrayParam
{
  NSDictionary* dict = [FileUtils readDictionaryFromFile: DATA_FILE_NAME];
  NSMutableDictionary* mdict = [NSMutableDictionary dictionaryWithDictionary: dict];
  [mdict setValue: [arrayParam objectAtIndex: 1] forKey: [arrayParam objectAtIndex: 0]];
  [FileUtils writeDictionaryToFile: mdict Path: DATA_FILE_NAME];
}

- (void) RemoveNativeData: (NSArray*) arrayParam
{
  NSDictionary* dict = [FileUtils readDictionaryFromFile: DATA_FILE_NAME];
  NSMutableDictionary* mdict = [NSMutableDictionary dictionaryWithDictionary: dict];
  [mdict removeObjectForKey: [arrayParam objectAtIndex: 0]];
  [FileUtils writeDictionaryToFile: mdict Path: DATA_FILE_NAME];
}

/** 打开提示框
 *
 *  @param paramArray 数组信息
 */
- (void) openDialog: (NSArray*) paramArray
{
  NSString* msg = [paramArray objectAtIndex:1];
  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: nil
                                                       message: msg
                                                      delegate: self
                                             cancelButtonTitle: @"确定"
                                             otherButtonTitles: nil, nil];
  [alertView show];
  [alertView release];
}

/**
 * 重新加载布局XML.
 * 
 * @param obj
 *            XML文件路径
 * @throws Exception
 */
- (void) refreshLayout: (id) obj
{
}

- (MarCompontent*) getFocusWidget
{
  return focuswidget;
}

- (void) setFocusWidget: (MarCompontent*) _widget
{
  focuswidget = _widget;
}

- (void) log: (NSArray*) params
{
  for (id value in params)
  {
    if (value)
    {
      if ([value isKindOfClass: [NSNumber class]])
      {
        LOG(@"fscript log : %d", [value intValue]);
      } else if ([value isKindOfClass: [NSString class]])
      {
        LOG(@"fscript log : %@", value);
      } else if ([value isKindOfClass: [FCBoolean class]])
      {
        if ([value boolValue])
        {
          LOG(@"fscript log : TRUE");
        } else {
          LOG(@"fscript log : FALSE");
        }
      }
    } else {
      LOG(@"nil");
    }
  }
}

- (void) println: (NSArray*) params
{
  [self log: params];
}

/**
 * 显示地图
 */
- (void) gotomap: (NSArray*) params
{
  NSString* span = [params objectAtIndex:0];//跨度
  NSString* pointStr = [params objectAtIndex:1];
  NSString* pointArrayStr = [params objectAtIndex:2];
  
  NSDictionary* pointDict = [JSONParser dataSource:pointStr];
  NSDictionary* pointArrayDict = [JSONParser dataSource:pointArrayStr];
    
  CLLocationCoordinate2D coor;
  coor.latitude = [[pointDict objectForKey:LATITUDE] doubleValue];//纬度
  coor.longitude = [[pointDict objectForKey:LONGITUDE] doubleValue];//经度
  
  [[MapUtil getInstence] showMap:g_window Span:span Coor:coor];

//  [[MapUtil getInstence] getCurrentPoint];
  
  NSArray* pointArray = [pointArrayDict objectForKey: POINTS];
  if ([pointArray count] > 0) {
    NSMutableArray* points = [NSMutableArray array];
    for (NSDictionary* point in pointArray)
    {
      CLLocationCoordinate2D _coor;
      _coor.latitude = [[point objectForKey:LATITUDE] doubleValue];//纬度
      _coor.longitude = [[point objectForKey:LONGITUDE] doubleValue];//经度
      if (_coor.latitude != 0 && _coor.longitude != 0) {
        MapAnnotation* annotation = [[[MapAnnotation alloc] initWithPointDict: point] autorelease];
        [points addObject: annotation];
      }
    }
    for (MapAnnotation* annotation in points)
    {
      LOG(@"");
      LOG(@"latitude : %f",annotation.coordinate.latitude);
      LOG(@"longitude : %f",annotation.coordinate.longitude);
      LOG(@"title : %@",annotation.title);
      LOG(@"subtitle : %@",annotation.subtitle);
    }
    [[MapUtil getInstence] addPointsToMap:points];
  }
  return;
}

/**
 * 从fscript中获取json，解析点的信息，加载到地图上
 */
- (void) pointListJson: (NSArray*) params
{
  NSString* response = [params objectAtIndex:0];
  NSDictionary* jsonDict = [JSONParser dataSource:response];
  
  NSArray* pointList = [jsonDict objectForKey: POINTS];
  if ([pointList count] > 0) {
    NSMutableArray* pointArray = [NSMutableArray array];
    for (NSDictionary* point in pointList)
    {
      MapAnnotation* annotation = [[[MapAnnotation alloc] initWithPointDict: point] autorelease];
      [pointArray addObject: annotation];
    }
    for (MapAnnotation* annotation in pointArray)
    {
      LOG(@"%f",annotation.coordinate.latitude);
      LOG(@"%f",annotation.coordinate.longitude);
      LOG(@"%@",annotation.title);
      LOG(@"%@",annotation.subtitle);
    }
    [[MapUtil getInstence] addPointsToMap:pointArray];
  }
  return;
}

/**
 * 从fscript中获取json，获取对应的字符串
 */
- (NSString*) FCSriptJson: (NSArray*) params
{
  NSString* response = [params objectAtIndex:0];
  LOG(@"response = %@", response);
  NSDictionary* jsonDict = [JSONParser dataSource:response];
  for (int i = 1; i < [params count]; i++) {
    if (i == [params count] - 1) {
      NSString* fcscriptJsonString =[jsonDict objectForKey:[params objectAtIndex:i]];
                  LOG(@"fcscriptJsonString = %@", fcscriptJsonString);
      if ([fcscriptJsonString isKindOfClass: [NSNumber class]])
      {
        return [(NSNumber*) fcscriptJsonString stringValue];
      }
      return fcscriptJsonString;
    }
    NSDictionary* tempDict = [jsonDict objectForKey:[params objectAtIndex:i]];
    jsonDict = tempDict;
  }
  return NULL_STRING_VALUE;
}

/**
 * 从fscript中获取json，获取对应的字符串
 */
- (NSString*) FCSriptJsonContent: (NSArray*) params
{
  NSString* response = [params objectAtIndex:0];
  LOG(@"response = %@", response);
  NSDictionary* jsonDict = [JSONParser dataSource:response];
  for (int i = 1; i < [params count]; i++) {
    if (i == [params count] - 1) {
      id fcscriptJsonString =[jsonDict objectForKey:[params objectAtIndex:i]];
      if (fcscriptJsonString)
      {
        SBJsonWriter* writer = [[SBJsonWriter alloc] init];
        NSString* result = [writer stringWithObject: fcscriptJsonString];
        [writer release];
        return result;
      }
      return NULL_STRING_VALUE;
    }
    NSDictionary* tempDict = [jsonDict objectForKey:[params objectAtIndex:i]];
    jsonDict = tempDict;
  }
  return NULL_STRING_VALUE;
}

/**
 * 从fscript中获取json，获取对应的字符串数组
 */
- (NSArray*) FCSriptiJsonlist: (NSArray*) params
{
  NSString* response = [params objectAtIndex:0];
  NSDictionary* jsonDict = [JSONParser dataSource:response];
  NSMutableArray* jsonStringList = [NSMutableArray array];
  for (int i = 1; i < [params count]; i++) {
    id tempObj = [jsonDict objectForKey:[params objectAtIndex:i]];
    if ([tempObj isKindOfClass:[NSArray class]]) {
      for (NSDictionary* dict in tempObj) {
        NSString* jsonString = [dict objectForKey:[params objectAtIndex:i+1]];
        //                LOG(@"jsonString = %@", jsonString);
        if (jsonString)
          [jsonStringList addObject: jsonString];
        else
          [jsonStringList addObject: NULL_STRING_VALUE];
      }
      return jsonStringList;
    }
    else {
      jsonDict = tempObj;
    }
  }
  return jsonStringList;
}

- (NSNumber*) arraylength: (NSArray*) params
{
  NSArray* array = [params objectAtIndex:0];
  return [NSNumber numberWithInt:[array count]];
}


- (void) update: (NSArray*) params
{
  UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"提示" 
                                                       message: @"有新版本可以升级，您是否升级" 
                                                      delegate: self
                                             cancelButtonTitle: @"升级"
                                             otherButtonTitles: @"取消", nil];
  [[FCSession getInstance] setSession: @"updateUrl" Obj: [params objectAtIndex: 0]];
  [alertView setTag: NEED_UPDATE];
  [alertView show];
  [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  LOG(@"alertView.tag : %d", alertView.tag);
  LOG(@"User selected button %d", buttonIndex);
  if (alertView.tag == NEED_LOGOUT)
  {
    switch (buttonIndex) {
      case LOGOUT_YES:
        LOG(@"确定");
        [self removeSession:sessionArray];
        [self RemoveNativeData:nativedataArray];
        [self openPage:openpageArray];
        [sessionArray release];
        [nativedataArray release];
        [openpageArray release];
        break;
      case LOGOUT_NO:
        LOG(@"取消");
        break;
      default:
        break;
    }
  }
	else if (alertView.tag == NEED_UPDATE) {
    if (buttonIndex == 0)
    {
      NSString* url = [[FCSession getInstance] getSessionByKey: @"updateUrl"];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    }
	}
  [self release];
}

/** 打开选择提示框
 *
 *  @param paramArray 数组信息
 */
- (void) logoutDialog: (NSArray*) paramArray
{
  NSString* msg = [paramArray objectAtIndex:1];
  sessionArray = [[NSArray alloc] initWithObjects:[paramArray objectAtIndex:2],nil];
  nativedataArray = [[NSArray alloc] initWithObjects:[paramArray objectAtIndex:3],nil];
  openpageArray = [[NSMutableArray alloc] initWithObjects:[paramArray objectAtIndex:4],nil];
  
  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: nil
                                                      message: msg
                                                     delegate: self
                                            cancelButtonTitle: @"确定"
                                            otherButtonTitles: @"取消", nil];
  [alertView setTag: NEED_LOGOUT];
  [alertView show];
  [alertView release];
}

@end