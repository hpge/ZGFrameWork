//
//  XMLNode.m
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/30.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import "XMLNode.h"

@implementation XMLNode
@synthesize  content, name, parentNode, rootNode, attributeMap, childNodes;


- (id) initWithTagName:(NSString *)tagName
         attributeDict:(NSDictionary *)dict
            parentNode:(XMLNode *)node{
    if (self=[self init]) {
        attributeMap = [[NSMutableDictionary alloc] initWithDictionary:dict];
        childNodes  = [[NSMutableArray alloc] initWithCapacity:4];
        parentNode  = node;
        rootNode    = node ==nil ? self :node.rootNode;
        self.name   = tagName;
    }
    return self;
}


- (void) setAttribute:(id)value name:(NSString *)attrName{

    if (attrName) {
        if (value) {
            [attributeMap setObject: value forKey: attrName];
        }else
        {
            [attributeMap removeObjectForKey: attrName];
        }
    }
}

- (id) attributeForName:(NSString *)attrName{
    if (attrName) {
        return [attributeMap objectForKey:attrName];
    }
    return nil;
}


- (void) addChildNode:(XMLNode *)node{
    if (node) {
        if (![childNodes containsObject:node]) {
            [childNodes addObject:node];
        }
    }
}

- (void)removeNode:(XMLNode *)node{
    if (node) {
        [childNodes removeObject:node];
    }
}

- (XMLNode *) getSingleNodeByName:(NSString *)nodeName{
    return [self getSingleNodeByName:nodeName recursion:YES];
}

- (XMLNode *) getSingleNodeByName:(NSString *)nodeName recursion:(BOOL)recursion
{
    if (nodeName) {
        if (childNodes.count>0) {
            for (XMLNode *node in childNodes) {
                if ([node.name isEqualToString:nodeName]) {
                    return node;
                }else if (recursion){
                
                    XMLNode *findNode =[node getSingleNodeByName:nodeName recursion:recursion ];
                    if (findNode) {
                        return  findNode;
                    }
                }
            }
        }
    }
    return nil;

}

- (NSArray*) getNodesByName: (NSString*) nodeName
{
    return [self getNodesByName: nodeName recursion: NO];
}

- (NSArray*) getNodesByName: (NSString*) nodeName
                  recursion: (BOOL) recursion
{
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity: 3];
    [self getNodesByName: nodeName recursion: recursion withResultArray: resultArray];
    return resultArray;
}

- (void) getNodesByName: (NSString*) nodeName
              recursion: (BOOL) recursion
        withResultArray: (NSMutableArray*) resultArray
{
    if (resultArray && nodeName)
    {
        if ([childNodes count] > 0)
        {
            for (XMLNode* node in childNodes)
            {
                if ([node.name isEqualToString: nodeName])
                {
                    [resultArray addObject: node];
                }
                else if (recursion)
                {
                    [node getNodesByName: nodeName recursion: recursion withResultArray: resultArray ];
                }
            }
        }
    }
}

- (NSArray*) getValuesByXPath: (NSString*) xpath
{
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity: 3];
    [self getValuesByXPath: xpath withResultArray: resultArray];
    return resultArray;
}

- (void) getValuesByXPath: (NSString*) xpath
          withResultArray: (NSMutableArray*) resultArray
{
    if (!resultArray) return;
    NSRange range = [xpath rangeOfString: @"."];
    if (range.location == NSNotFound)
    {
        if ([xpath hasPrefix: @"@"])
        {
            NSString* attrValue = [self attributeForName: [xpath substringToIndex: 1]];
            if (attrValue)
                [resultArray addObject: attrValue];
        } else {
            if ([self.name isEqualToString: xpath])
            {
                [resultArray addObject: self.content];
            }
        }
    } else if (range.location == 0)
    {
        [rootNode getValuesByXPath: [xpath substringFromIndex: range.length]];
    } else {
        NSString* nodeName = [xpath substringToIndex: range.location];
        if ([nodeName isEqualToString: self.name])
        {
            xpath = [xpath substringFromIndex: range.location + range.length];
            for (XMLNode* node in self.childNodes)
            {
                [node getValuesByXPath: xpath withResultArray: resultArray];
            }
        }
    }
}

- (id) getValueByXPath: (NSString*) xpath
{
    NSRange range = [xpath rangeOfString: @"/"];
    if (range.location == NSNotFound)
    {
        if ([xpath hasPrefix: @"@"])
        {
            return [self attributeForName: [xpath substringToIndex: 1]];
        } else {
            return [self getSingleNodeByName: xpath];
        }
    } else if (range.location == 0)
    {
        return [rootNode getValueByXPath: [xpath substringFromIndex: range.length]];
    } else {
        NSString* nodeName = [xpath substringToIndex: range.location];
        xpath = [xpath substringFromIndex: range.location + range.length];
        for (XMLNode* node in [self getNodesByName: nodeName])
        {
            id result = [node getValueByXPath: xpath];
            if (result) return result;
        }
        return nil;
    }
}



@end
