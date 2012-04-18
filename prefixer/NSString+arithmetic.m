//
//  NSString+isInteger.m
//  prefixer
//
//  Created by Twan Wolthof on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+arithmetic.h"

@implementation NSString (arithmetic)

- (BOOL) isInteger
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}
- (BOOL) isOperator
{
    return ([self length]==1
            && ([self isEqualToString:@"*"] 
                ||[self isEqualToString:@"/"]
                ||[self isEqualToString:@"+"]
                ||[self isEqualToString:@"-"]
                ));
}


@end