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

/**
 *  解析获取TL对象集合, 9F38标签的值是TL格式
 *
 *  @param tlString tlString
 *
 *  @return TL对象集合
 */
- (NSArray *)tlObjectsFromTLString:(NSString *)tlString;
/**
 *  解析获取TL对象集合, 9F38标签的值是TL格式
 *
 *  @param tlData tlData
 *
 *  @return TL对象集合
 */
- (NSArray *)tlObjectsFromTLData:(NSData *)tlData;

@end


@interface LJieTLVParser (BlackMagic)

/**
 *  得到标签中的值
 *
 *  @param tlvString 不是纯的TLV字符串, 如包涵报文头
 *  @param tag       标签（不区分大小写）
 *
 *  @return 标签中的值
 */
- (NSData *)valueFromImpureTLVString:(NSString *)tlvString tag:(NSString *)tag;

/**
 *  得到标签中的值
 *
 *  @param tlvData 不是纯的TLV数据, 如包涵报文头
 *  @param tag     标签（不区分大小写）
 *
 *  @return 标签中的值
 */
- (NSData *)valueFromImpureTLVData:(NSData *)tlvData tag:(NSString *)tag;

@end
