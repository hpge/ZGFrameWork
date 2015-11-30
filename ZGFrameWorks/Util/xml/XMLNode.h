//
//  XMLNode.h
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/30.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLNode : NSObject
{
    NSString * content;
    NSString * name;
    XMLNode  *parentNode;
    XMLNode  *rootNode;
    NSMutableDictionary *attributeMap;
    NSMutableArray      *childNodes;
}

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) XMLNode *parentNode;
@property (nonatomic, readonly) XMLNode *rootNode;
@property (nonatomic, readonly) NSMutableDictionary *attributeMap;
@property (nonatomic, readonly) NSMutableArray      *childNodes;


- (id)initWithTagName: (NSString *)tagName
       attributeDict: (NSDictionary *)dict
          parentNode: (XMLNode *)node;


- (void)addChildNode: (XMLNode *)node;
- (void)removeNode: (XMLNode *)node;

- (id)attributeForName: (NSString *)attrName;
- (void) setAttribute: (id) value name: (NSString *)attrName;

- (XMLNode *) getSingleNodeByName: (NSString *)nodeName;
- (XMLNode *) getSingleNodeByName: (NSString *)nodeName
                        recursion: (BOOL) recursion;


- (NSArray*) getNodesByName: (NSString*) nodeName;
- (NSArray*) getNodesByName: (NSString*) nodeName
                  recursion: (BOOL) recursion;
- (void) getNodesByName: (NSString*) nodeName
              recursion: (BOOL) recursion
        withResultArray: (NSMutableArray*) resultArray;

- (id) getValueByXPath: (NSString*) xpath;
- (NSArray*) getValuesByXPath: (NSString*) xpath;
- (void) getValuesByXPath: (NSString*) xpath
          withResultArray: (NSMutableArray*) resultArray;





@end
