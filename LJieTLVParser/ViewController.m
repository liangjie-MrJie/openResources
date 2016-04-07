//
//  ViewController.m
//  LJieTLVParser
//
//  Created by liangjie on 14/11/19.
//  Copyright (c) 2014年 liangjie. All rights reserved.
//

#import "ViewController.h"
#import "LJieTLVParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    const unsigned char bytes[] =
    {
        0xe1,0x35,0x9f,0x1e,0x08,0x31,0x36,0x30,0x32,0x31,0x34,0x33,0x37,0xef,0x12,0xdf,
        0x0d,0x08,0x4d,0x30,0x30,0x30,0x2d,0x4d,0x50,0x49,0xdf,0x7f,0x04,0x31,0x2d,0x32,
        0x32,0xef,0x14,0xdf,0x0d,0x0b,0x4d,0x30,0x30,0x30,0x2d,0x54,0x45,0x53,0x54,0x4f,
        0x53,0xdf,0x7f,0x03,0x36,0x2d,0x35,   0x9B, 0x83, 0x02, 0x00, 0x00, 0xAA, 0xAA };
    
    NSData *dataTextField = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    
    LJieTLVParser *tlv = [[LJieTLVParser alloc] init];
    
    NSArray *a = [tlv tlObjectsFromTLString:@"9F7A019F02065F2A02"];
    
    NSData *result = [tlv valueFromTLVData:dataTextField tag:@"df0d"];
    NSLog(@"result: %@", result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
