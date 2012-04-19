//
//  main.m
//  prefixer
//
//  Created by Twan Wolthof on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        //Node* node = [Node makeTreeFromInfixString:@"( x * x + x * 2 + 1 ) / ( x + 1 )"];
        
        //NSLog(@"%@",[Node prefixFromTree:node]);
        printf("%s\n",[[Node prefixFromTree:node] cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    
    return 0;
}