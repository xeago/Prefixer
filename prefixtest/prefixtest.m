//
//  prefixtest.m
//  prefixtest
//
//  Created by Twan Wolthof on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "prefixtest.h"

@implementation prefixtest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testPrefixTreeSingleOperand0
{
    Node* node = [Node makeTreeFromInfixString:@"14"];
    NSString* actual = [node prefixTree];
    NSString* expected=@"14";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testPrefixTreeSingleOperand1
{
    Node* node = [Node makeTreeFromInfixString:@"x"];
    NSString* actual = [node prefixTree];
    NSString* expected=@"x";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testPrefixTreMultiOperand0
{
    Node* node = [Node makeTreeFromInfixString:@"1 + 3 + 4"];
    NSString* actual = [node prefixTree];
    NSString* expected=@"(+ (+ 1 3) 4)";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testPrefixTreMultiOperand1
{
    Node* node = [Node makeTreeFromInfixString:@"1 * 3 + 4"];
    NSString* actual = [node prefixTree];
    NSString* expected=@"(+ (* 1 3) 4)";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testPrefixTreeComplexOperand0
{
    Node* node = [Node makeTreeFromInfixString:@"2 * ( 5 + 1 )"];
    NSString* actual = [node prefixTree];
    NSString* expected=@"(* 2 (+ 5 1))";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testPrefixTreeComplexOperand1
{
    Node* node = [Node makeTreeFromInfixString:@"3 * x + ( 9 + y ) / 4"];
    NSString* actual = [node prefixTree];
    NSString* expected=@"(+ (* 3 x) (/ (+ 9 y) 4))";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testPrefixTreeComplexOperand2
{
    Node* node = [Node makeTreeFromInfixString:@"( x * x + x * 2 + 1 ) / ( x + 1 )"];
    NSString* actual = [node prefixTree];
    NSString* expected=@"(/ (+ (+ (* x x) (* x 2)) 1) (+ x 1))";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testPrefixTreeComplexOperand3
{
    Node* node = [Node makeTreeFromInfixString:@"( 1 + 2 ) - 1 + ( 1 - ( 3 * 8 ) )"];
    NSString* actual = [node prefixTree];
    NSString* expected=@"(+ (- (+ 1 2) 1) (- 1 (* 3 8)))";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceSingleOperand0
{
    Node* node = [Node makeTreeFromInfixString:@"x"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"x";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceSingleOperand1
{
    Node* node = [Node makeTreeFromInfixString:@"42"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"42";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduce0
{
    Node* node = [Node makeTreeFromInfixString:@"1 + 2"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"3";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduce1
{
    Node* node = [Node makeTreeFromInfixString:@"5 + 3 + 2"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"10";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduce2
{
    Node* node = [Node makeTreeFromInfixString:@"5 + 3 * 2"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"11";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduce3
{
    Node* node = [Node makeTreeFromInfixString:@"( 5 + 3 ) * 2"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"16";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduce4
{
    Node* node = [Node makeTreeFromInfixString:@"6 / ( 3 * 2 )"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"1";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduce5
{
    Node* node = [Node makeTreeFromInfixString:@"12 / 5"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"2";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduce6
{
    Node* node = [Node makeTreeFromInfixString:@"13 / ( 2 * 2 )"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"3";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceComplex0
{
    Node* node = [Node makeTreeFromInfixString:@"( 1 + 2 ) - 1 + ( 1 - ( 3 * 8 ) )"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"-21";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceVariable0
{
    Node* node = [Node makeTreeFromInfixString:@"x - x"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"0";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceVariable1
{
    Node* node = [Node makeTreeFromInfixString:@"x - 1"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"(- x 1)";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}
- (void)testReduceVariable2
{
    Node* node = [Node makeTreeFromInfixString:@"x - y"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"(- x y)";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}
- (void)testReduceVariable3
{
    Node* node = [Node makeTreeFromInfixString:@"x - ( x - x )"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"x";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceVariable4
{
    Node* node = [Node makeTreeFromInfixString:@"( x - x ) - ( x - x )"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"0";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceVariable5
{
    Node* node = [Node makeTreeFromInfixString:@"( x - y ) - ( x - y )"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"0";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceVariable6
{
    Node* node = [Node makeTreeFromInfixString:@"( x - y ) / ( x - y )"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"1";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceVariable7
{
    Node* node = [Node makeTreeFromInfixString:@"( x * y ) / ( x * y )"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"1";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceVariable8
{
    Node* node = [Node makeTreeFromInfixString:@"( x * y ) - ( x * y )"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"0";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceVariable9
{
    Node* node = [Node makeTreeFromInfixString:@"( y * x ) / ( x * y )"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"1";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceCommutative1
{
    Node* node = [Node makeTreeFromInfixString:@"1 + 1 + 3"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"5";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceCommutative2
{
    Node* node = [Node makeTreeFromInfixString:@"1 * 1"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"1";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceCommutative3
{
    Node* node = [Node makeTreeFromInfixString:@"1 * 0"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"0";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceCommutative4
{
    Node* node = [Node makeTreeFromInfixString:@"1 + 1 * 3 + 5"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"9";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceCommutativeVariable0
{
    Node* node = [Node makeTreeFromInfixString:@"x + 1 - x"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"1";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceCommutativeVariable1
{
    Node* node = [Node makeTreeFromInfixString:@"x * 1 - x"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"0";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceCommutativeVariable2
{
    Node* node = [Node makeTreeFromInfixString:@"x * ( 1 - x )"];
    NSString* actual = [[node reduce] prefixTree];
    NSString* expected=@"(* x (- 1 x))";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

- (void)testReduceCommutativeVariableComplex0
{
    Node* node = [Node makeTreeFromInfixString:@"5 * ( 3 + x )"];
    NSString* actual = [[node reduce] prefixTree];
    // one can argue what is further reduced
    // 5 * ( 3 + x ), or 15 + 5 * x,
    // I choose for 5 * ( 3 + x ) because the common factor is placed aside, resulting in only 1 multiplication
    NSString* expected=@"(* 5 (+ 3 x))";
    STAssertEqualObjects(actual, expected,@"Expected: %@ | Actual: %@",expected,actual);
}

@end
