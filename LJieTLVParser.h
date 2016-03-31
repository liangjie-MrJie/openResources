//
//  LJieTLVParser.h
//  LJieTLVParser
//
//  Created by liangjie on 14/11/19.
//  Copyright (c) 2014年 liangjie. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end
