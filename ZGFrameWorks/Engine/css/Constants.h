//
//  Constants.h
//  mar_client_iphone
//
//  Created by zhangjunjie on 12-2-14.
//  Copyright 2012 Mar114. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 常量类，定义了一系列常量
 *
 */

/**
 * 资源文件访问权限.
 */
//public final static Resources RES = ConstantsForXml.getResources();// 资源文件访问权限

/**
 * 控件起始位置.
 */
#define WIDGET_START_X          0

/**
 * 默认名称.
 */
#define DEFAULT_NAME            @"default"

/**
 * Bundle中Key默认名称.
 */
#define DEF_PAGE                @"page"// Bundle中Key默认名称

/**
 * Bundle中Key默认名称.
 */
#define DEF_PAGE_NAME           @"page_name"// Bundle中Key默认名称



/**
 * Bundle中key默认名称,script中使用.
 */
#define DEF_PAGE_SCRIPT         @"script_page"// Bundle中key默认名称,script中使用

/**
 * Service默认名称.
 */
#define DEF_SERVICE_NAME        @"service"

/**
 * 默认字体颜色、白色.
 */
#define Constants_FONTCOLOR     @"white"

/**
 * 默认背景颜色、黑色.
 */
#define Constants_BGCOLOR       @"black"

/**
 * 默认字体大小(Constants.XML中定义).
 */
#define Constants_FONTSIZE      @"15"

/**
 * *input,link,text,textarea的最小宽度.
 */
#define MIN_WIDTH               80

/**
 * 默认选中颜色.
 */
//#define SELECTEDCOLOR           ConstantsForXml.getColorWithDefault("focusColor", Color.argb(0xff, 255, 140, 0))

/**
 * Action常量,打开网页链接. WAP://wap.zzss.com – 打开http://wap.zzss.com的wap网页
 */
#define WAP                     @"wap://"
/**
 * Action常量,打开菜单. MENU://Menu菜单名称 – 打开该名称的菜单
 */
#define MENU                    @"menu://"
/**
 * Action常量,电话功能. CALL://13********* – 拨打13*********的电话.
 */
#define CALL                    @"call://"

/**
 * Action常量,地图功能
 */
#define MAP                     @"map://"

/**
 * Action常量,页面跳转. PAGE://pageid –
 * 打开pageid为cardinfo的页面，如果pageid为-1表示返回上一页，pageid为0代表退出系统.
 */
#define PAGE                    @"page://"

/**
 * Action常量,调用FCScript函数. fcscript::func(), 调用FCScript的func函数.
 */
#define SCRIPT                  @"fcscript::"

/**
 * Action常量,调用系统发送短信. sms://13765576557+短信内容
 */
#define SMS                     @"sms://"

/**
 * 输出script中的变量值.
 */
#define SCRIPT_OUT              @"fcscript::$"
// SQLitXML中常量定义
/**
 * 数据库名称.
 */
#define DATABASE_NAME           Constants_DATABASE_NAME
/**
 * 数据库版本号.
 */
#define DATABASE_VERSION        Constants_DATABASE_VERSION

/**
 *本地文件表名称.
 */
#define TABLE_NAME_LOCAL        Constants_TABLE_NAME_LOCALY

/**
 * 服务表名.
 */
#define TABLE_NAME_SERVICE      Constants_TABLE_NAME_SERVICE

/**
 *用户字典表名.
 */
#define TABLE_NAME_USERDICTIONARY   Constants_TABLE_NAME_USERDICTIONARY

// SQLit常量定义
#define dbName                  @"pluginDB"// 本地用户表存储;
#define DEFAULT_SORT_ORDER      @"servicename DESC"

/**
 * 文件类型,本地RES文件.
 */
#define RES_TYPE                @"0"
/**
 * 文件类型,网路下载文件
 */
#define NET_TYPE                @"1"

/**
 * 数据库索引路径.
 */
#define AUTHORITY               @"com.mar114.frame.provider.db"
//public static final Uri CONTENT_URI_FILE = Uri.parse("content://"
//                                                     + AUTHORITY + "/Local/file");
//public static final Uri CONTENT_URI_SERVICE = Uri.parse("content://"
//                                                        + AUTHORITY + "/Local/service");
//public static final Uri CONTENT_URI_USERDIC = Uri.parse("content://"
//                                                        + AUTHORITY + "/Local/userDic");

/**
 * 手机白名单地址.
 */
#define PHONE_URL               @"phone_url"// 白名单URL

/**
 * 手机号码.
 */
#define PHONE_NO                @"phone_no"// 手机号码

// 网络连接地址
#define ALL_SUCCESS             @"all_success"
#define PART_SUCCESS            @"part_success"
#define NET_SU                  @"net_su"
/**
 * 使用GZIP传输
 */
#define REQUEST_BY_GZIP         @"GZIP"// 使用GZIP传输

/**
 * 不使用GZIP传输
 */
#define REQUEST_POST            @"POST"// 不使用GZIP传输

/**
 * 插件交互
 */
#define REQUEST_PLUGIN          @"PLUGIN"// 插件交互

/**
 * 下载图片请求
 */
#define REQUEST_DOWNLOAD_IMAGE  @"downloadimage"// 下载图片请求

/**
 * 服务不允许访问
 */
#define SERVICE_NOT_ACCESS      @"0"// 服务不允许访问

/**
 * 获取收白名单
 */
#define REQUEST_URL             @"URL"// 获取收白名单

/**
 * 后台servlet地址.
 */
#define HTTP_URL                Constants_HTTP_URL

/**
 *后台地址.
 */
#define BOOT_URL                Constants_BOOT_URL

/**
 *业务ID
 */
#define BUSINESSID              Constants_BUSINESSID

/**
 * 文件根路径.
 */
#define FILE_PATH               @"/data/data/com.mar114.frame/"

/**
 * 控件之间的间隙
 */
#define FCMARGIN                5

/**
 * 单位滚动距离
 */
#define SCROLL_SPACE            30

/**
 * 初始化页面路径
 */
#define FIRSTPAGE_PATH          Constants_FIRSTPAGE_PATH

/**
 * 控件XML根节点开始 ,add或者 set控件是使用.
 */
#define ROOT_STAGE              @"<root>"

/**
 * 控件XML根节点结束 ,add或者 set控件是使用.
 */
#define ROOT_ETAGE              @"</root>"

/**
 * CSS样式文件名称.
 */
#define CSS_STYLE_DEFOULT       Constants_Default_CSS

/**
 * 用户自定义CSS样式.
 */
#define CSS_STYLE_USER          @"USER_CSS"
/**
 * 默认的页面跳转动画样式名称.
 */
#define PAGE_STYLE_NAME         @"PAGE_STYLE"

/**
 * 默认的页面跳转动画样式.
 */
#define PAGE_STYLE              Constants_PAGE_STYLE

/**
 * 默认设置去服务名称.
 */
#define PAGE_SERVICE_NAME       @"PAGE_SERVICE_NAME"
/**
 * 更新时间.
 */
#define TIMESTAMP               @"TIMESTAMP"
/**
 * cardSn.
 */
#define CARDSN                  @"CARDSN"

/**
 * 客户端版本号.
 */
#define CLIENT_VERSION          Constants_ClientVersion

/**
 * 软件下载地址.
 */
#define SOFTUPPDATA_URL         @"SoftUpdata_Url"
/**
 * 初始activity名称.
 */
#define Activity_Name           @"FCMain"

/**
 * activity退出码.
 */
#define RESPONSE_EXIT_CODE      99
/**
 * activity返回码.
 */
#define RESPONSE_BACK_CODE      98
/**
 * scrupt中activity代码.
 */
#define REQUEST_DEFAULT         1

/**
 * 网络错误提示.
 */
//#define NET_ERROR               ConstantsForXml.getStringFromRes("exception_net_error")

/**
 * 超时时间,默认为60s
 */
#define OUTTIME                 Constants_TimeOut
/**
 * 超时之后跳转验证页面.
 */
#define TIMEOUT_PAGE            Constants_TimeOut_Page

/**
 * 是否超时检测标志.
 */
#define TIMEOUTCHECK            @"TIMEOUTCHECK"
/**
 * 超时验证页面.
 */
#define INTIMEOUTPAGE           @"TIMEOUTPAGE"
/**
 * 默认退出名.
 */
#define DEF_EXIT                @"exit"

/**
 *MMFS类型请求.
 */
#define REQUEST_MMFS            @"MMFS"

/**
 * 第三方请求.
 */
#define REQUEST_THIRDPARTY      @"KINGCARD"

/**
 * 加密密钥key
 */
#define MMFS_KEY                @"MMFS_FILE_KEY"

/**
 * 定义在Activity中的Handle常量
 */
/**
 * 关闭Gauge显示
 */
#define MESSAGE_CLOSE_GAUGE     1
/**
 * 弹出Dialog
 */
#define MESSAGE_SHOW_DIALOG     0
/**
 * 关闭Dialog
 */
#define MESSAGE_CLOSE_DIALOG    2
/**
 * 弹出Gague
 */
#define MESSAGE_SHOW_GAUGE      3
/**
 * 控件变化
 */
#define MESSAGE_CHANGEUI        4
/**
 * 点击gauge取消
 */
#define MESSAGE_CANCEL_GAUGE    5
/**
 * 点击gauge取消
 */
#define MESSAGE_STARTACTIVITY   6
/**
 * 控件变化之后整个布局重新绘制
 */
#define MESSAGE_ADJUST          7
/**
 * 操作超时
 */
#define MESSAGE_TIMEOUT         8
/**
 * 操作超时消息
 */
#define MESSAGE_TIMEOUT_MSG     @"MESSAGE_TIMEOUT"
/**
 * 网络连接
 */
#define MESSAGE_NETTYPE         9

/**
 * 动画效果移入移出
 */
#define TRANSLATE               0
/**
 * 动画效果渐变
 */
#define ALPHA                   1
/**
 * 动画效果转入转出
 */
#define ROTATE                  2

/**
 * 动画速度匀速
 */
#define LINE                    0
/**
 * 动画速度加速
 */
#define ACCE                    1
/**
 * 动画速度减速
 */
#define DECE                    2

/**
 * 网络连接常量
 */
/**
 * 中国移动CMWAP_APN
 */
#define CMWAP_APN               @"cmwap"
/**
 * 中国移动和中国联通CM_UNIWAP_PROXY
 */
//#define CM_UNIWAP_PROXY         ConstantsForXml.getStringFromRes("CM_UNIWAP_PROXY")
/**
 * 中国联通UNIWAP_APN
 */
#define UNIWAP_APN              @"uniwap"
/**
 * 中国电信CDMA_CTWAP_APN
 */
#define CTWAP_APN               @"ctwap"
/**
 * 中国电信CDMA_CTWAP_PROXY
 */
//#define CDMA_CTWAP_PROXY        ConstantsForXml.getStringFromRes("CDMA_CTWAP_PROXY")

/**
 * 中国移动和联通WAP连接
 */
#define NET_CM_UNIWAP           0
/**
 * 电信wap连接
 */
#define NET_CT_WAP              1
/**
 * 不通过wap连接
 */
#define NET_UNWAP               2

/**
 * XML中for标签起始定义
 */
#define FOR_START               @"start"

/**
 * XML中for标签结束定义
 */
#define FOR_END                 @"end"
/**
 * XML中for标签text定义
 */
#define FOR_TEXT                @"text"

/**
 * 客户端XML中描述的客户端版本号
 */
#define LOCAL_CLIENT_VER        @"local_client_ver"

/**
 * 公共的私有key,用于加密随机密码
 */
#define CONSTANTS_SEED_KEY      @"moto_MMFS@mOtO!"

/**
 * MMFS测试类型
 */
#define TEST_CASE_TYPE          1

/**
 *FCScript定义的跳转页面方法.
 */
#define FCSCRIPT_FUNC_OPENPAGE  @"openPage"

/**
 * 默认的屏幕高度
 */
#define SCREENHEIGHT            Constants_ScreenHeight
/**
 * 默认的屏幕宽度
 */
#define SCREENWIDTH             Constants_ScreenWidth

/**
 * 用户定义的Gauge文字.
 */
#define GAUGE_MESSAGE           @"USER_GAUGE_MESSAGE"

/**
 * Gauge默认显示的文字.
 */
#define GAUGE_TEXT              DEFAULT_GAUGE_TEXT

/**
 * Gauge正在连接显示的文字.
 */
//#define CONNECT_GAUGE_TEXT      ConstantsForXml.getStringFromRes("CONNECT_GAUGE_TEXT")

/**
 * Gauge取消按钮的默认文字.
 */
//#define GAUGE_BUTTON_DEFAULT_TEXT   ConstantsForXml.getStringFromRes("GAUGE_BUTTON_DEFAULT_TEXT")

/**
 * 用户操作日志的前缀.
 */
#define USERLOGS                @"USERLOGS"

/**
 * 在grid页面引入菜单项
 */
#define MAINPAGE_MENU           Constants_MainPage_Menu

/**
 * Log登录检测.
 */
#define LO_CHECK                @"LO_CHECK"

/**
 * Log登录认证失败
 */
#define LO_CHECK_FAIL           @"LO_CHECK_FAIL"

/**
 * LO登录认证失败后跳转页面
 */
#define LO_FAIL_PAGE            Constants_LO_FAIL

/**
 * 已經online
 */
#define ONLINE_MSG              @"OFFLINE_MSG"

/**
 * 调试开关
 */
#define DEBUG                   FALSE
/**
 * 模拟器调试
 */
#define DEBUG_MODE_SIMULATOR    1
/**
 * 真机调试
 */
#define DEBUG_MODE_PHONE        2
/**
 * 调试方式配置
 */
#define DEBUG_MODE              DEBUG_MODE_SIMULATOR
/**
 * 测试手机号码
 */
#define DEBUG_PHONE             @"13699246688"
/**
 * 是否使用代理
 */
#define DEBUG_PROXY             FALSE;
/**
 * 模拟器测试代理地址
 */
#define DEBUG_PROXY_ADDR        @"199.5.211.253"
/**
 * 模拟器测试代理端口
 */
#define DEBUG_PROXY_PORT        3128
/**
 * 记录日志时的标签名称
 */
#define LOG_FRAME_TAG           @"framework"

/**
 * 生成的R文件类名
 */
#define rClassName              @"com.mar114.frame.R"


//constant.xml

//<!-- 自定义屏幕的高宽 -->
#define Constants_ScreenWidth               320
#define Constants_ScreenHeight              480
//<!-- Main_page_menu-->
#define Constants_MainPage_Menu             @"ecard_menu/main.xml"

#define Constants_Default_CSS               @"mar_default_style.css"

//<!-- LO_FAIL-->
#define Constants_LO_FAIL                   @"register.xml"

//<!-- SQLit常量定义 -->
#define Constants_DATABASE_NAME             @"mmfs.db"
#define Constants_DATABASE_VERSION          2
#define Constants_TABLE_NAME_LOCALY         @"LocalFile"
#define Constants_TABLE_NAME_SERVICE        @"LocalService"
#define Constants_TABLE_NAME_USERDICTIONARY @"UserDictionary"
//<!-- net -->
//<!--tomcat 5.5	 -->
//<!---->
#define Constants_HTTP_URL                  @"http://dev.mar114.com/site/service/cmd"
#define Constants_BOOT_URL                  @"http://dev.mar114.com/site/service/cmd"
//<!--
//#define Constants_HTTP_URL                @"http://192.168.1.100:9090/mars/service/cmd"
//#define Constants_BOOT_URL                @"http://192.168.1.100:9090/mars/service/cmd"
//-->
#define Constants_BUSINESSID                @"Mar114"
//<!-- font -->
#define Constants_TEXTSIZE                  20

//<!-- FirstPage_Path -->
#define Constants_FIRSTPAGE_PATH            @"ecard_login/forward"

//<!--  动画效果默认值 -->
#define Constants_PAGE_STYLE                1

//<!-- 客户端版本号 -->
#define Constants_ClientVersion             @"2.0"

//<!-- 移动联通代理 -->
#define CM_UNIWAP_PROXY                     @"10.0.0.172"
//<!-- 电信代理 -->
#define CDMA_CTWAP_PROXY                    @"10.0.0.200"

//<!-- 超时时间设置,单位为秒 -->
#define Constants_TimeOut                   1800
#define Constants_TimeOut_Page              @"mar_classify.xml"

//<!-- TemplateActivity -->
#define TA_Dialog_Title                     @"标题栏"
#define TA_Dialog_Button                    @"确定"
#define TA_Quit                             @"是否退出？"

//<!-- Dialog -->
#define Dialog_Button_Ok                    @"确 定"
#define Dialog_Button_Cancel                @"取 消"

//<!-- Gauge -->
#define DEFAULT_GAUGE_TEXT                  @"正在连接，请稍候..."
#define CONNECT_GAUGE_TEXT                  @"正在连接，请稍候..."
#define GAUGE_BUTTON_DEFAULT_TEXT           @"取消"

//<!-- 默认选中框的颜色 -->
#define focusColor                          @"#CE0000"

//<!-- 公共脚本常量 -->
#define PUBLIC_FSCRIPT                      @"common.fs"

