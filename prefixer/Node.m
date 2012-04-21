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





-(Node*) reducePlus{
    self.left=[self.left reduce];
    self.right=[self.right reduce];
    Node *left=self.left,*right=self.right;
    
    if (!left.isOperator && !right.isOperator) // do we have numbers?
    {
        //Yay we have atleast 1 number
        if ([left.element isNumber] && [right.element isNumber]) // do we have 2?
        { // return the sum;
            return [[Node alloc] initWithIntegerString:[NSString stringWithFormat:@"%i",[left.element intValue]+[right.element intValue]]];
        }
        else if ([left.element isNumber] && [left.element intValue]==0)
            return right;
        else if ([right.element isNumber] && [right.element intValue]==0)
            return left;
        
        //just variables
        return self;
    }
    // BUHU! no numbers, cannot reduce :'(
    return self;
}

-(Node*) reduceMinus{
    self.left=[self.left reduce];
    self.right=[self.right reduce];
    Node *left=self.left,*right=self.right;
    
    if (!left.isOperator && !right.isOperator) // do we have numbers?
    {
        //Yay we have atleast 1 number
        if ([left.element isNumber] && [right.element isNumber]) // do we have 2?
        { // return the substraction;
            return [[Node alloc] initWithIntegerString:[NSString stringWithFormat:@"%i",[left.element intValue]-[right.element intValue]]];
        }
        else if ([left.element isNumber] && [left.element intValue]==0)
            return right;
        else if ([right.element isNumber] && [right.element intValue]==0)
            return left;
        
        //just variables
        return self;
    }
    // BUHU! no numbers, cannot reduce :'(
    return self;
}

-(Node*) reduceTimes{
    self.left=[self.left reduce];
    self.right=[self.right reduce];
    Node *left=self.left,*right=self.right;
    
    if (!left.isOperator && !right.isOperator) // do we have numbers?
    {
        //Yay we have atleast 1 number
        if ([left.element isNumber] && [right.element isNumber]) // do we have 2?
        { // return the multiplication;
            return [[Node alloc] initWithIntegerString:[NSString stringWithFormat:@"%i",[left.element intValue]*[right.element intValue]]];
        }
        else if (([left.element isNumber] && [left.element intValue]==0 ) || ([right.element isNumber] && [right.element intValue]==0))
            return [[Node alloc] initWithIntegerString:@"0"];
        else if ([left.element isNumber] && [left.element intValue]==1)
            return right;
        else if ([right.element isNumber] && [right.element intValue]==1)
            return left;
        
        //just variables
        return self;
    }
    
    // 5 * (3 + x) can be reduced to 15 + 5 * x
    // I am leaving these out due to complexity
    
    // BUHU! no numbers, cannot reduce :'(
    return self;
}


-(Node*) reduceDivision{
    self.left=[self.left reduce];
    self.right=[self.right reduce];
    Node *left=self.left,*right=self.right;
    
    if (!left.isOperator && !right.isOperator) // do we have numbers?
    {
        //Yay we have atleast 1 number
        if ([left.element isNumber] && [right.element isNumber]) // do we have 2?
        { // return the multiplication;
            return [[Node alloc] initWithIntegerString:[NSString stringWithFormat:@"%i",[left.element intValue]/[right.element intValue]]];
        }
        else if ([right.element isNumber] && [right.element intValue]==1)
            return left;
        //in computing, infinity does not really exist
        
        return self;
    }
    
    // BUHU! no numbers, cannot reduce :'(
    return self;
}



#define REDUCE_DIVIDE_INT
-(Node*) reduce
{
    //if we are an operand, we are a terminator, simply return self;
    if (!self.isOperator)
        return self;
    else
    {
        Node * result;
        unichar operator= [self.element characterAtIndex:0];
        
        switch (operator) {
            case '-':
                result = [self reduceMinus];
                break;
            case '+':
                result = [self reducePlus];
                break;
            case '/':
                result = [self reduceDivision];
                break;
            case '*':
                result = [self reduceTimes];
                break;
            default:
                result=self;
                break;
        }
        
        if (result.isOperator) {
        
            //if left and right are resolved to equal strings we can do some computations
            if ([[result.left prefixTree] isEqualToString:[result.right prefixTree]])
            {
                switch ([self.element characterAtIndex:0]) {
                    case '-':
                        return [[Node alloc] initWithIntegerString:@"0"];
                        break;
                    case '/':
                        return [[Node alloc] initWithIntegerString:@"1"];
                        break;
                }
            }
        }
        
        
        return result;
        
    }
    
    return self;
}            
@end
