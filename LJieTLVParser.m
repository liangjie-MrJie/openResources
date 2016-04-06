//
//  LJieTLVParser.m
//  LJieTLVParser
//
//  Created by liangjie on 14/11/19.
//  Copyright (c) 2014年 liangjie. All rights reserved.
//

#import "LJieTLVParser.h"

static const char hexdigits[] = "0123456789ABCDEF";

@implementation TLV
- (NSString *)description {
    return [NSString stringWithFormat:@"tag: %@\nlength: %@\nvalue: %@\nisNesting: %@", self.t, self.l, self.v, self.isNesting?@"YES":@"NO"];
}

@end

@implementation LJieTLVParser

- (NSData *)valueFromTLVString:(NSString *)tlvString tag:(NSString *)tag
{
    return [self valueFromTLVData:[self hexStringToData:tlvString strLen:tlvString.length] tag:tag];
}

- (NSData *)valueFromTLVData:(NSData *)tlvData tag:(NSString *)tag {

    NSArray *tlvs = [self tlvObjectsFromTLVData:tlvData];
    NSData *tagData = [self hexStringToData:tag strLen:tag.length];
    
    return [self searchValue:tlvs tag:tagData];
}

- (NSArray *)tlvObjectsFromTLVString:(NSString *)tlvString {
    return [self tlvObjectsFromTLVData:[self hexStringToData:tlvString strLen:tlvString.length]];
}
- (NSArray *)tlvObjectsFromTLVData:(NSData *)tlvData {
    
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    
    while (tlvData.length > 0) {
        
        NSData *tagData = nil;
        NSData *lengthData = nil;
        NSData *valueData = nil;
        
        int tagBytesCount = [self calcTagBytesCount:tlvData];
        if (tlvData.length >= tagBytesCount) {
            tagData = [tlvData subdataWithRange:NSMakeRange(0, tagBytesCount)];
            // progress
            tlvData = [tlvData subdataWithRange:NSMakeRange(tagBytesCount, tlvData.length - tagBytesCount)];
        }
        
        int lengthBytesCount = [self calcLengthBytesCount:tlvData];
        if (tlvData.length >= lengthBytesCount) {
            NSUInteger index = lengthBytesCount > 1 ? 1 : 0;
            NSUInteger len   = lengthBytesCount > 1 ? (lengthBytesCount-1) : lengthBytesCount;
            lengthData = [tlvData subdataWithRange:NSMakeRange(index, len)];
            // progress
            tlvData = [tlvData subdataWithRange:NSMakeRange(lengthBytesCount, tlvData.length - lengthBytesCount)];
        }
        
        NSUInteger valueLength = 0;
        [lengthData getBytes:&valueLength length:lengthData.length];
        if (tlvData.length >= valueLength) {
            valueData = [tlvData subdataWithRange:NSMakeRange(0, valueLength)];
            // progress
            tlvData = [tlvData subdataWithRange:NSMakeRange(valueLength, tlvData.length - valueLength)];
        }
        
        TLV *tlv = [[TLV alloc] init];
        tlv.t = tagData;
        tlv.l = lengthData;
        tlv.v = valueData;
        
        if ([self isNesting:tagData])
        {
            tlv.isNesting = YES;
            tlv.nestingTlvs = [self tlvObjectsFromTLVData:valueData];
        }
        
        [mArray addObject:tlv];
    }
    
    return [mArray copy];
}



#pragma mark -- private method
- (int)calcTagBytesCount:(NSData *)tlvData
{
    NSAssert(tlvData.length != 0, @"tlvData.length si error!");
    uint8_t const *bytes = tlvData.bytes;
    if((bytes[0] & 0x1F) == 0x1F)
    { // see subsequent bytes
        int len = 2;
        for(int i=1; i<10; i++)
        {
            if( (bytes[i] & 0x80) != 0x80)
            {
                break;
            }
            len++;
        }
        return len;
    }
    else
    {
        return 1;
    }
}
- (BOOL)isNesting:(NSData *)tagData
{
    NSAssert(tagData.length != 0, @"tagData.length si error!");
    uint8_t *bytes = (uint8_t *) tagData.bytes;
    // 0x20
    //return (bytes[0] & 0b00100000) != 0;
    return (bytes[0] & 0x20) != 0;
}
- (int)calcLengthBytesCount:(NSData *)tlvData
{
    NSAssert(tlvData.length != 0, @"tlvData.length si error!");
    uint8_t const *bytes = tlvData.bytes;
    int len = (int) bytes[0];
    if( (len & 0x80) == 0x80)
    {
        tlvData = [tlvData subdataWithRange:NSMakeRange(1, tlvData.length-1)];
        return (int) (1 + (len & 0x7f));
    }
    else
    {
        return 1;
    }
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

- (NSData *)searchValue:(NSArray *)tlvs tag:(NSData *)tagData {
    for (TLV *tlv in tlvs) {
        if ([tagData isEqualToData:tlv.t])
            return tlv.v;
        if (tlv.isNesting) {
            NSData *value = [self searchValue:tlv.nestingTlvs tag:tagData];
            if (value) return value;
        }
        continue;
    }
    
    return nil;
}

@end

