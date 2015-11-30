//
//  CssParse.m
//  mar_client_iphone
//
//  Created by zhangjunjie on 12-2-9.
//  Copyright 2012 Mar114. All rights reserved.
//

#import "CssParse.h"

@implementation CssParse

@synthesize m_source;

- (NSString*) getM_source {
    return m_source;
}

/**
 * 设置当前解析代码.
 * @param m_source css代码
 */
- (void) setM_source: (NSString*) _m_source {
    self->m_source = _m_source;
}

/**
 * 是否是空白处.
 * @param ch
 * @return boolean
 */
- (BOOL) isWhiteSpace: (unichar) ch {
    NSCharacterSet* temp = [NSCharacterSet characterSetWithCharactersInString: @"\t\n\r "];
    return [temp characterIsMember: ch];
}

/**
 * 去掉空白地方.
 */
- (void) filterWhiteSpace {
    while (![self eof]) {
        c = [self getCurrentChar];
        if (![self isWhiteSpace:c]) {
            return;
        }
        m_idx++;
    }
}

/**
 * 是否是行结束.
 * @return boolean 结束则true,否则false
 */
- (BOOL) eof {
    return (m_idx >= [m_source length]);
}

/**
 * 得到根元素名称.
 * @return String 跟元素名称
 */
- (NSString*) parseElementName {
    NSMutableString* element = [NSMutableString string];
    [self filterWhiteSpace];
    while (![self eof]) {
        c = [self getCurrentChar];
        if (c == '{') 
        {
            m_idx++;
            break;
        }
        [element appendFormat:@"%c",c];
        m_idx++;
    }
    [self filterWhiteSpace];
    NSString* str = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str;
}

/**
 * 解析属性名称.
 * @return String 属性名称
 */
- (NSString*) parseAttributeName {
    NSMutableString* attribute = [NSMutableString string];
    [self filterWhiteSpace];
    while (![self eof]) {
        c = [self getCurrentChar];
        if (c == ':')
        {
            m_idx++;
            break;
        }
        [attribute appendFormat:@"%c",c];
        m_idx++;
    }
    [self filterWhiteSpace];
    NSString* str = [attribute stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str;
}

/**
 * 解析属性值.
 * @return String 属性值
 */
- (NSString*) parseAttributeValue {
    NSMutableString* attribute = [NSMutableString string];
    [self filterWhiteSpace];
    while (![self eof]) {
        c = [self getCurrentChar];
        if (c != '}' && c == ',') {
            m_idx++;
            break;
        }
        
        if(c == '}') {
            break;
        }
        
        [attribute appendFormat:@"%c",c];
        m_idx++;
    }
    [self filterWhiteSpace];
    NSString* str = [attribute stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str;
}

/**
 * 得到字符.
 * @return char 字符
 */
- (unichar) getCurrentChar {
    return [self getCurrentChar:0];
}

/**
 * 返回一个字符
 * @param peek 字符位置
 * @return char 返回当前字符
 */
- (unichar) getCurrentChar: (int) peek {
    if ((m_idx + peek) < [m_source length]) {
        return [m_source characterAtIndex:(m_idx + peek)];
    } 
    else {
        return (unichar)0;
    }
}


/**
 * 解析Css样式.
 * @return ArrayList<CssElement>
 */
- (NSMutableArray*) parse {
    NSMutableArray* elements = [NSMutableArray array];
    while (![self eof]) {
        NSString* elementName = [self parseElementName];
        if (elementName == nil) {
            break;
        }
        
        CssElement* element = [[CssElement alloc] initWithName:elementName];
        NSString* name = [self parseAttributeName];
        NSString* value = [self parseAttributeValue];
        while (name != nil && value != nil && ![@"" isEqualToString:name] && ![@"" isEqualToString:value])
        {
            [element add_AttributeKey:name Value:value];
            [self filterWhiteSpace];
            c = [self getCurrentChar];
            if (c == '}')
            {
                m_idx++;
                break;
            }
            
            name = [self parseAttributeName];
            value = [self parseAttributeValue];
        }
        
        [elements addObject:element];
        
    }
    
    return elements;
}

@end
