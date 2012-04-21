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
        
        
        if ([tok isOpenParentheses])
        {
            brackets++;
        }
        else if ([tok isCloseParentheses])
        {
            brackets--;
        }
        else if ([tok isOperand])
        {
            cur = [[Node alloc] initWithIntegerString:(NSString*)tok];
            
            if (node.isOperator) { // this operand must be a terminator so don't do node=cur;
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
                
                
                // if the new node has a higher precedence, use right as our left and replace the current right with ourselfs
                if (r>l)
                {
                    cur.left=node.right;
                    node.right=cur;
                    node=cur;
                }
                else {
                    //retrieve the parents of node that has higher precedence untill it is lower than ours
                    Node*parent=node;
                    int lprec=[parent.element getPrecedenceFor:parent.brackets];
                    while(lprec>=r)
                    {
                        node=parent;
                        parent=parent.parent;
                        lprec=[parent.element getPrecedenceFor:parent.brackets];
                    }
                    
                    if (parent){
                        //cur.left=parent;
                        
                        Node*buf=parent.right;
                        parent.right=cur;
                        cur.left=buf;
                    }
                    else {//edge case: we've reached to top of the tree
                        cur.left=node;
                    }
                    
                    node=cur;
                }
            }
        }
        else {
            [NSException raise:@"Invalid token" format:@"Token '%@' is invald!",tok];
        }
        
        
        Node* root=node;
        while(root.parent) root=root.parent;
        NSLog(@"t%@ | n%@%ld | %@",tok,node.element,node.brackets,[Node prefixFromTree:root]);
        
        
        
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

-(NSString*)prefixTree{
    
    NSString* element=@"";
    NSString* left=@"";
    NSString* right=@"";
    
    element=self.element;
    if (self.left)
        left=[self.left prefixTree];
    if (self.right)
        right=[self.right prefixTree];
    
    NSString* result;
    if (!self.isOperator)
        result = [NSString stringWithFormat:@"%@",element];
    else 
        result = [NSString stringWithFormat:@"(%@ %@ %@)",element,left,right];
    return result;
}

@end
