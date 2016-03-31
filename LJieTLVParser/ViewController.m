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
    NSString * str = @"00659F360200E0910A6A62305BC18C048A3030711B86198424000114F08967D53F3A7EE980013802BB2B6140EFA7033A7211860F04DA9F790A000000088800002FD39B83020000AAAA";
    _textView.text = str;
    
    LJieTLVParser * tlv = [[LJieTLVParser alloc] init];
    NSData *result = [tlv valueFromTLVString:str tag:@"9F36"];
    NSLog(@"result: %@", result);
    
    result = [tlv valueFromTLVString:str tag:@"91"];
    NSLog(@"result: %@", result);
    
    result = [tlv valueFromTLVString:str tag:@"71"];
    NSLog(@"result: %@", result);
    
    result = [tlv valueFromTLVString:str tag:@"72"];
    NSLog(@"result: %@", result);
    
    result = [tlv valueFromTLVString:str tag:@"9b"];
    NSLog(@"result: %@", result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
