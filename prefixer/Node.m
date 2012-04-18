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
@property (nonatomic) NSInteger brackets;
@property (nonatomic,strong) NSString* element; //operand or operator
@end

@implementation Node
@synthesize left=_left;
@synthesize right=_right;
@synthesize isOperator=_isOperator;
@synthesize element=_element;
@synthesize parent=_parent;
@synthesize brackets=_brackets;

-(id)initWithIntegerString:(NSString*)tok
{
    if ((self=[super init]) && tok)
    {
        _element=tok;
        _isOperator=NO;
    }
    return self;
}

-(id)initWithOperatorString:(NSString*)tok withBracket:(NSInteger)brackets
{
    if ((self=[super init]) && tok)
    {
        _element=tok;
        _isOperator=YES;
        _brackets=brackets;
    }
    return self;
}

+(Node*) makeTreeFromInfixString:(NSString*)infix
{
    NSArray* tokens=[infix componentsSeparatedByString:@" "];
    int i=0;
    Node* node;
    Node* cur;
    int brackets=0;
    
    while (i<[tokens count]) {
        
        NSString *tok=[tokens objectAtIndex:i];
        
        
        
        if ([tok isOpenBracket])
        {
            brackets++;
        }
        else if ([tok isCloseBracket])
        {
            brackets--;
        }
        else if ([tok isInteger])
        {
            cur = [[Node alloc] initWithIntegerString:(NSString*)tok];
            
            if (node.isOperator) {
                node.right=cur;
            } else {
                node.left=cur;
                node=cur;
            }
        }
        
        else if ([tok isOperator]) {
            cur = [[Node alloc] initWithOperatorString:(NSString*)tok withBracket:brackets];
            
            if (![node isOperator])
            {
                cur.left=node;
                node=cur;
            }
            else {
                //handle priority
                
                int l=[node.element getPrecedenceFor:node.brackets], r=[tok getPrecedenceFor:brackets];
                
                //if the new element on the right has a higher or equal priority (equal=>right to left)
                //add it lower on the tree
                if (r>=l)
                {
                    
                    
                    Node* lowestorequalprioritynode=node;
                    
                    while ([lowestorequalprioritynode.element getPrecedenceFor:node.brackets] <= r && lowestorequalprioritynode.parent)
                        lowestorequalprioritynode=lowestorequalprioritynode.parent;
                    
                    cur.left=lowestorequalprioritynode.right;
                    lowestorequalprioritynode.right=cur;
                    node=cur; 
                }
                else {
                    cur.left=node.right;
                    node.right=cur;
                    node=cur;
                }
            }
        }
        
        i++;
    }
    
    
    //traverse to root    
    while(node.parent) node=node.parent;
    
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

+(NSString*)prefixFromTree:(Node*)root{
    
    NSString* element=@"";
    NSString* left=@"";
    NSString* right=@"";
    
    element=root.element;
    if (root.left)
        left=[Node prefixFromTree:root.left];
    if (root.right)
        right=[Node prefixFromTree:root.right];
    NSString* result=[NSString stringWithFormat:@"%@ %@%@",element,left,right];
    
    return result;
    
}

@end
