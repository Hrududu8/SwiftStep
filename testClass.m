//
//  testClass.m
//  SwiftStep
//
//  Created by rukesh on 7/29/14.
//  Copyright (c) 2014 Rukesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "testClass.h"

@implementation testClass
-(testClass *)init{
    self = [super init];
    self.aProperty = @"hi";
    return self;
}
-(void)aMethod {
    NSLog(@"aMethod Ran");
}


@end
