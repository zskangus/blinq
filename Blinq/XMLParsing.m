//
//  XMLParsing.m
//  XML解析
//
//  Created by zsk on 16/4/29.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "XMLParsing.h"
#import "model.h"

@interface XMLParsing()<NSXMLParserDelegate>

@property(nonatomic,strong)model *modelInfo;

@property(nonatomic,strong)NSString *lastElement;

@property(nonatomic,strong)NSMutableArray *info;

@end

@implementation XMLParsing

- (NSMutableArray *)info{
    if (!_info) {
        _info = [NSMutableArray array];
    }
    return _info;
}

- (void)parsingXMLWith:(NSString *)fileName xmlInfo:(xmlBlock)info{
    
    //开始解析 xml
    // 传入XML数据，创建解析器
    NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:fileName]];
    //NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    // 设置代理，监听解析过程
    parser.delegate = self;
    // 开始解析
    [parser parse];
    
        NSLog(@"---解析错唔%@",[parser parserError]);
    
    [self.info enumerateObjectsUsingBlock:^(model *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        info(obj.version,obj.name,obj.url);
        
        NSLog(@"%@%@%@",obj.version,obj.name,obj.url);
    }];

}

//当扫描到文档的开始时调用（开始解析）
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"开始解析");
}

//当扫描到文档的结束时调用（解析完毕）
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
}

/* 解析xml出错的处理方法 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"解析xml出错:%@", parseError);
}

//当扫描到元素的开始时调用（attributeDict存放着元素的属性）
// 参数:1. 元素名  2. 命名空间  3. qName 4.元素的属性
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    //NSLog(@"---%@",elementName);
    
    if ([@"update"isEqualToString:elementName]) {
        self.modelInfo = [[model alloc]init];
        //self.modelInfo.version = attributeDict[@"version"];
    }else if ([@[@"version",@"name",@"url"]containsObject:elementName]){
        self.lastElement = elementName;
    }
    
}

//当扫描到元素的结束时调用
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([@"update" isEqualToString:elementName]) {
        [self.info addObject:self.modelInfo];
        self.modelInfo = nil;
    }
    self.lastElement = nil;
    
}

// 发现文本
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    if ([self.lastElement isEqualToString:@"version"]) {
        self.modelInfo.version = string;
    }else if([self.lastElement isEqualToString:@"name"]){
        self.modelInfo.name = string;
    }else if([self.lastElement isEqualToString:@"url"]){
        self.modelInfo.url = string;
    }
}


@end
