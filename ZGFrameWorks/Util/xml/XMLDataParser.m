//
//  XMLDataParser.m
//  ZGFrameWorks
//
//  Created by gehaipeng on 15/11/30.
//  Copyright © 2015年 Melvins inc. All rights reserved.
//

#import "XMLDataParser.h"
#import "XMLNode.h"

@implementation XMLDataParser
@synthesize rootNode;
- (XMLNode *) doXMLParser:(NSData *)xmlData{
    rootNode = nil;
    currNode = rootNode;
    nodeContent = nil;
    NSXMLParser *parser =[[NSXMLParser alloc]initWithData:xmlData];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser setDelegate:self];
    [parser parse];
    return rootNode;
}

- (void) parser: (NSXMLParser *)parser
didstartelement: (NSString *) elementName
   namespaceURI: (NSString *) namespaceURI
  qualifiedName: (NSString *) qName
     attributes: (NSDictionary *)attributeDict
{
    XMLNode* currentTemp = [[XMLNode alloc] initWithTagName: elementName
                                              attributeDict: attributeDict
                                                 parentNode: currNode];
    if (currNode)
        [currNode addChildNode: currentTemp];
    else
    currNode = currentTemp;
    if (!rootNode)
        self.rootNode = currNode;
}

- (void) parser: (NSXMLParser*) parser
  didEndElement: (NSString*) elementName
   namespaceURI: (NSString*) namespaceURI
  qualifiedName: (NSString*) qName
{
    NSString* tempContent = nil;
    if (nodeContent)
    {
        tempContent = [NSString stringWithString: nodeContent];
        nodeContent = nil;
    }
    if (currNode)
    {
        currNode.content = tempContent;
        currNode = currNode.parentNode;
    }
}


@end
