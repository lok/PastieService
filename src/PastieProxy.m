//
// PastieProxy.m
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

#import "PastieProxy.h"
#import "NSString+TotalPercentEscape.h"

@interface PastieProxy (Private)
- (NSData*)pastePostDataWithString:(NSString*)string 
                        ofLanguage:(NSString*)language 
                      setResticted:(BOOL)restricted;
- (void)makePastieFromTextService:(NSPasteboard *)pboard 
                         userData:(NSString *)userData 
                            error:(NSString **)error;
@end


@implementation PastieProxy

@synthesize URL;
@synthesize pasteContent;
@synthesize languages;
@synthesize pasteLanguage;
@synthesize pasteRestricted;

- (id)init {
    self = [super init];
    
    if (self) {
        URL = [[NSURL alloc] initWithString:@"http://pastie.org"];
        pasteRestricted = YES;
        
        NSString *languagesPath = [[NSBundle mainBundle] pathForResource:@"Languages" ofType:@"plist"];
        NSDictionary *languagesDict = [NSDictionary dictionaryWithContentsOfFile:languagesPath];
        NSArray *languagesSortedKeys = [languagesDict keysSortedByValueUsingSelector:@selector(compare:)];
        
        languages = [[NSMutableArray alloc] initWithCapacity:[languagesDict count]];
        for (NSString *key in languagesSortedKeys) {
            NSString *value = [languagesDict objectForKey:key];
            PastieLanguage *language = [PastieLanguage languageNamed:value withCode:key];
            [languages addObject:language];
            // TODO: offers a better way to set the default language
            if ([key isEqual:@"objective-c++"]) {
                [self setPasteLanguage:language];
            }
        }
    }
    
    return self;
}

- (void)dealloc {
    [languages removeAllObjects];
    [languages release];
    [URL release];
    [super dealloc];
}

+ (PastieProxy*)defaultProxy {
    return [[[PastieProxy alloc] init] autorelease];
}

#pragma mark -
#pragma mark Create a new paste
- (NSURL*)sendPasteWithString:(NSString*)string 
                   ofLanguage:(NSString*)language 
                 setResticted:(BOOL)restricted 
{
    NSData *postData = [self pastePostDataWithString:string ofLanguage:language setResticted:restricted];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
 
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://pastie.org/pastes"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        [[NSAlert alertWithError:error] runModal];
        return nil;
    }
    
    return [response URL];
}

#pragma mark -
#pragma mark Actions
- (IBAction)sendPasteContent:(id)sender 
{
    [NSApp hide:self];
    
    NSURL *pastieURL = [self sendPasteWithString:[pasteContent string] 
                                      ofLanguage:[pasteLanguage code] 
                                    setResticted:pasteRestricted];

    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard setString:[pastieURL description] forType:(NSString*)kUTTypeURL];
    [pasteboard setString:[pastieURL description] forType:(NSString*)kUTTypeUTF8PlainText];
    
    [NSApp terminate:self];
}

#pragma mark -
#pragma mark Private Methods
- (NSData*)pastePostDataWithString:(NSString*)string 
                        ofLanguage:(NSString*)language 
                      setResticted:(BOOL)restricted 
{
    NSString *escapedString = [string stringByAddingTotalPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *postString = [NSString stringWithFormat:@"paste[authorization]=%@&paste[body]=%@&paste[parser]=%@&paste[restricted]=%d", 
                             @"burger", escapedString, language, restricted];

    return [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}

#pragma mark -
#pragma mark Service Methods
- (void)makePastieFromTextService:(NSPasteboard *)pboard 
                         userData:(NSString *)userData 
                            error:(NSString **)error 
{
    NSData *data = [pboard dataForType:(NSString*)kUTTypeRTF];
    NSAttributedString *att = [[NSAttributedString alloc] initWithData:data 
                                                               options:nil 
                                                    documentAttributes:nil 
                                                                 error:nil];
    [self setPasteContent:att];
    [att release];
}

@end
