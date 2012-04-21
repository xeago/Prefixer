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
        
        //check for correct input
        if (argc==1 || argc>3)
        {
            printf("Incorrect number of arguments!\n");
            return 0;
        }
        
        int argp=0;
        BOOL shouldReduce;
        
        // EXTREMELY BASIC OPTION PARSING >.<
        if (argc>2 && argv[1][0] == '-')
        {
            argp++;
            if (argv[1][1]=='r')
                shouldReduce=YES;
        }
        
        NSString* filepath= [NSString stringWithCString:argv[1+argp] encoding:NSUTF8StringEncoding];
                
        NSError* err;
        
        NSString* read = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&err];
        
        if (err)
        {
            printf("Error reading file: %s.\n",argv[1+argp]);
            return 0;
        }
        
        
        Node* node = [Node makeTreeFromInfixString:read];
        
        if (shouldReduce)
            node=[node reduce];
        
        printf("%s\n",[[node prefixTree] cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    
    return 0;
}