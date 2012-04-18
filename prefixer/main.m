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
        Node* node= [Node makeTreeFromInfixString:@"1 + 2 / 3 * 4"];
        
        NSLog(@"%@",node);
    }
    return 0;
}