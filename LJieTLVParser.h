//
//  LJieTLVParser.h
//  LJieTLVParser
//
//  Created by liangjie on 14/11/19.
//  Copyright (c) 2014年 liangjie. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  TLV对象
 */
@interface TLV : NSObject
@property (nonatomic, strong) NSData *t;
@property (nonatomic, strong) NSData *l;
@property (nonatomic, strong) NSData *v;
@property (nonatomic, assign) BOOL isNesting;
@property (nonatomic, strong) NSArray *nestingTlvs;
@end


@interface LJieTLVParser : NSObject

/**
 *  得到标签中的值
 *
 *  @param tlvString TLV字符串
 *  @param tag       标签（不区分大小写）
 *
 *  @return 标签中的值
 */
- (NSData *)valueFromTLVString:(NSString *)tlvString tag:(NSString *)tag;

/**
 *  得到标签中的值
 *
 *  @param tlvData TLV数据
 *  @param tag     标签（不区分大小写）
 *
 *  @return 标签中的值
 */
- (NSData *)valueFromTLVData:(NSData *)tlvData tag:(NSString *)tag;

/**
 *  解析获取TLV对象集合
 *
 *  @param tlvData tlvData
 *
 *  @return TLV对象集合
 */
- (NSArray *)tlvObjectsFromTLVData:(NSData *)tlvData;
/**
 *  解析获取TLV对象集合
 *
 *  @param tlvString tlvString
 *
 *  @return TLV对象集合
 */
- (NSArray *)tlvObjectsFromTLVString:(NSString *)tlvString;

@end
