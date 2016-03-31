//
//  LJieTLVParser.m
//  LJieTLVParser
//
//  Created by liangjie on 14/11/19.
//  Copyright (c) 2014年 liangjie. All rights reserved.
//

#import "LJieTLVParser.h"

static const char hexdigits[] = "0123456789ABCDEF";

@implementation LJieTLVParser

- (NSData *)valueFromTLVString:(NSString *)tlvString tag:(NSString *)tag
{
    return [self valueFromTLVData:[self hexStringToData:tlvString strLen:tlvString.length] tag:tag];
}

- (NSData *)valueFromTLVData:(NSData *)tlvData tag:(NSString *)tag {
    const Byte *tlvByte = [tlvData bytes];
    NSData *tagData = [self hexStringToData:tag strLen:tag.length];
    NSRange range = [tlvData rangeOfData:tagData options:NSDataSearchBackwards range:NSMakeRange(0, tlvData.length)];
    if (range.location != NSNotFound) {
        NSUInteger lenIndex = range.location +range.length;
        Byte len = tlvByte[lenIndex];
        if (len & 128) {
            // len is many byte
            NSUInteger addLen = len & 127;
            NSData *lenData = [tlvData subdataWithRange:NSMakeRange(lenIndex +1, addLen)];
            NSUInteger lenResult = 0;
            [lenData getBytes:&lenResult length:addLen];
            NSUInteger valueIndex = lenIndex + addLen + 1;
            if (tlvData.length -valueIndex >= lenResult) {
                NSData *value = [tlvData subdataWithRange:NSMakeRange(valueIndex, lenResult)];
                return value;
            }
        }
        else {
            // len is one byte
            NSUInteger valueIndex = lenIndex + 1;
            if (tlvData.length -valueIndex >= len) {
                NSData *value = [tlvData subdataWithRange:NSMakeRange(valueIndex, len)];
                return value;
            }
        }
    }
    
    return nil;
}

- (NSString*)hexStringFromData:(NSData*)data{
    
    NSUInteger numBytes = [data length];
    const unsigned char* bytes = [data bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    
    for (int i = 0; i<numBytes; ++i){
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    *hex = 0;
    NSString * hexBytes = [NSString stringWithUTF8String:strbuf];
    free(strbuf);
    
    return hexBytes;
}

- (NSData *)hexStringToData:(NSString *)hexStr strLen:(NSUInteger)strLen
{
    NSUInteger asciiLen = strLen/2;
    const char * hex = (char *)[hexStr UTF8String];
    char ascii[asciiLen];

    for (int i = 0; i < strLen; i += 2)
    {
        if (hex[i] >= '0' && hex[i] <= '9')
            ascii[i / 2] = (hex[i] - '0') << 4;
        else if (hex[i] >= 'a' && hex[i] <= 'z')
            ascii[i / 2] = (hex[i] - 'a' + 10) << 4;
        else if (hex[i] >= 'A' && hex[i] <= 'Z')
            ascii[i / 2] = (hex[i] - 'A' + 10) << 4;
        
        if (hex[i + 1] >= '0' && hex[i + 1] <= '9')
            ascii[i / 2] += hex[i + 1] - '0';
        else if (hex[i + 1] >= 'a' && hex[i + 1] <= 'z')
            ascii[i / 2] += hex[i + 1] - 'a' + 10;
        else if (hex[i + 1] >= 'A' && hex[i + 1] <= 'Z')
            ascii[i / 2] += hex[i + 1] - 'A' + 10;
    }
    NSData * data = [NSData dataWithBytes:ascii length:asciiLen];

    return data;
}


@end

