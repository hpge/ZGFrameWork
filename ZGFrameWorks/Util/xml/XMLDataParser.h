//
//  XMLDataParser.h
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/30.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLNode.h"
@interface XMLDataParser : NSObject <NSXMLParserDelegate>
{
    XMLNode* rootNode;
    XMLNode* currParentNode;
    XMLNode* currNode;
    NSMutableString* nodeContent;
}

@property (nonatomic, retain) XMLNode* rootNode;

- (XMLNode*) doXMLParser: (NSData*) xmlData;
- (void) outPutNode;
- (void) outPutNode: (XMLNode*) node
          recursion: (int) recursion;

@end
