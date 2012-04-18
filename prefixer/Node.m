//
//  Node.m
//  prefixer
//
//  Created by Twan Wolthof on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Node.h"
#import "NSString+arithmetic.h"

@interface Node()
@property (nonatomic) BOOL isOperator;
@property (nonatomic,strong) NSString* element; //operand or operator
@end

@implementation Node
@synthesize left=_left;
@synthesize right=_right;
@synthesize isOperator=_isOperator;
@synthesize element=_element;
@synthesize parent=_parent;

-(id)initWithIntegerString:(NSString*)tok
{
    if ((self=[super init]) && tok)
    {
        _element=tok;
        _isOperator=NO;
    }
    return self;
}

-(id)initWithOperatorString:(NSString*)tok
{
    if ((self=[super init]) && tok)
    {
        _element=tok;
        _isOperator=YES;
    }
    return self;
}

+(Node*) makeTreeFromInfixString:(NSString*)infix
{
    NSArray* tokens=[infix componentsSeparatedByString:@" "];
    int i=0;
    Node* node;
    
    while (i<[tokens count]) {
        NSString *tok=[tokens objectAtIndex:i];
        Node* cur;
        
        
        if ([tok isInteger])
        {
            cur = [[Node alloc] initWithIntegerString:(NSString*)tok];
            if (!node) {
                node=cur;
            }
            else {
                if (node.isOperator) {
                    node.right=cur;
                } else {
                    node.left=cur;
                }
            }
        }
        
        else if ([tok isOperator]) {
            if (![node isOperator])
            {
                cur = [[Node alloc] initWithOperatorString:(NSString*)tok];
                cur.left=node;
                node=cur;
            }
            else {
                //handle priority
                //instead of just assuming it has lower priority
                cur = [[Node alloc] initWithOperatorString:(NSString*)tok];
                cur.left=node;
                node=cur;
            }
        }
        
        i++;
    }
    
    return node;
}

-(void)setLeft:(Node *)left
{
    _left=left;
    _left.parent=self;
}

-(void)setRight:(Node *)right
{
    _right=right;
    _right.parent=self;
}

@end
