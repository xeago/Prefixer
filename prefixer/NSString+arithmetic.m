//
//  NSString+isInteger.m
//  prefixer
//
//  Created by Twan Wolthof on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+arithmetic.h"

@implementation NSString (arithmetic)

- (BOOL) isOperand
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
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

- (BOOL) isOpenParentheses
{
    return [self isEqualToString:@"("];
}

- (BOOL) isCloseParentheses
{
    return [self isEqualToString:@")"];
}

- (NSInteger) getPrecedence
{
    switch ([self characterAtIndex:0]) {
            //return ordered numbers arbitrarily chosen
            //leaving room for any additional operators
        case '*':
            return 4;
            break;
        case '/':
            return 4;
            break;
        case '+':
            return 1;
            break;
        case '-':
            return 1;
            break;
    }
    return 0;
}

- (NSInteger) getPrecedenceFor:(NSInteger)brackets
{
    //10 because it is bigger than 4
    //allows combinations of brackets and the priority of an operator
    //to be easily read by humans
    return brackets * 10 + [self getPrecedence];
}


@end