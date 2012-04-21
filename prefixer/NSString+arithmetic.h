//
//  NSString+isInteger.h
//  prefixer
//
//  Created by Twan Wolthof on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (arithmetic)
- (BOOL) isOperand;
- (BOOL) isOperator;
- (BOOL) isNumber;
- (BOOL) isOpenParentheses;
- (BOOL) isCloseParentheses;
- (NSInteger) getPrecedence;
- (NSInteger) getPrecedenceFor:(NSInteger)brackets;

@end
