//
//  Node.h
//  prefixer
//
//  Created by Twan Wolthof on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Node : NSObject

@property (nonatomic,strong) Node* left;
@property (nonatomic,strong) Node* right;
@property (nonatomic,strong) Node* parent;
+(Node*) makeTreeFromInfixString:(NSString*)infix;
+(NSString*)prefixFromTree:(Node*)root;
@end

/********************************************
 *    The final Tree for an expression      *
 *                                          *
 *   Infix :-> 4 * 3 - 3 + 8 / 4 / (1 + 1)  *
 *                                          *
 ********************************************
 *                                          *
 *                  +                       *
 *                /   \                     *
 *               /     \                    *
 *             -       (/)                  *
 *            / \      /  \                 *
 *           /   \    /    \                *
 *          *     3  (/)    +               *
 *         / \       /\     /\              *
 *        /   \     /  \   /  \             *
 *       4     3   8   4   1   1            *
 *                                          *
 *******************************************/