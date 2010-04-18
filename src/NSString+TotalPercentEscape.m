//
// NSString+TotalPercentEscape.m
// Licensed under the terms of the BSD License, as specified below.
//

/*
 Copyright (c) 2010, Samuel Mendes
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of ᐱ nor the names of its
 contributors may be used to endorse or promote products derived
 from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "NSString+TotalPercentEscape.h"


@implementation NSString (TotalPercentEscape)

- (NSString*)stringByAddingTotalPercentEscapesUsingEncoding:(NSStringEncoding)encoding {

    //This one will take care of most escapes and is probably optimized
    //We use it as the source string to escape
    NSString *source = [self stringByAddingPercentEscapesUsingEncoding:encoding];
    
    //Now escaping the remaining trouble makers
    NSMutableString *result = [NSMutableString stringWithCapacity:([source length] * 1.5)];
    
    NSScanner *scanner = [NSScanner scannerWithString:source];
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *charsToEscape = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?"];
    
    do {
        NSString *nonEscapedString;
        if ([scanner scanUpToCharactersFromSet:charsToEscape intoString:&nonEscapedString]) {
            [result appendString:nonEscapedString];
        }
        if ([scanner isAtEnd]) {
            break;
        }
        
        if ([scanner scanString:@"!" intoString:nil]) {
            [result appendString:@"%21"];
        } else if ([scanner scanString:@"*" intoString:nil]) {
            [result appendString:@"%2A"];
        } else if ([scanner scanString:@"'" intoString:nil]) {
            [result appendString:@"%27"];
        } else if ([scanner scanString:@"(" intoString:nil]) {
            [result appendString:@"%28"];
        } else if ([scanner scanString:@")" intoString:nil]) {
            [result appendString:@"%29"];
        } else if ([scanner scanString:@";" intoString:nil]) {
            [result appendString:@"%3B"];
        } else if ([scanner scanString:@":" intoString:nil]) {
            [result appendString:@"%3A"];
        } else if ([scanner scanString:@"@" intoString:nil]) {
            [result appendString:@"%40"];
        } else if ([scanner scanString:@"&" intoString:nil]) {
            [result appendString:@"%26"];
        } else if ([scanner scanString:@"=" intoString:nil]) {
            [result appendString:@"%3D"];
        } else if ([scanner scanString:@"+" intoString:nil]) {
            [result appendString:@"%2B"];
        } else if ([scanner scanString:@"$" intoString:nil]) {
            [result appendString:@"%24"];
        } else if ([scanner scanString:@"," intoString:nil]) {
            [result appendString:@"%2C"];
        } else if ([scanner scanString:@"/" intoString:nil]) {
            [result appendString:@"%2F"];
        } else if ([scanner scanString:@"?" intoString:nil]) {
            [result appendString:@"%3F"];
        }
    } while (![scanner isAtEnd]);
    
    return result;
}

@end
