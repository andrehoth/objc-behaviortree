/*
 * objc-behaviortree: http://github.com/andoco/objc-behaviortree
 *
 * Copyright (c) 2012 Andrew O'Connor
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "Kiwi.h"

#import "AODecorator.h"
#import "AOTask.h"

SPEC_BEGIN(DecoratorSpec)

describe(@"Decorator", ^{
    __block AODecorator *decorator;
    __block id task;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        task = [KWMock nullMockForProtocol:@protocol(AOTask)];
        decorator = [[AODecorator alloc] initWithTask:task];
    });
    
    context(@"when started", ^{
        
        it(@"should call willStart template method", ^{
            [[decorator should] receive:@selector(willStart:)];
            [decorator start:blackboard];
        });
        
        it(@"should start decorated task if willStart returns YES", ^{
            [[decorator stubAndReturn:theValue(YES)] willStart:blackboard];
            [[task should] receive:@selector(start:) withArguments:blackboard];
            [decorator start:blackboard];
        });
        
        it(@"should not start decorated task if willStart returns NO", ^{
            [[decorator stubAndReturn:theValue(NO)] willStart:blackboard];
            [[task shouldNot] receive:@selector(start:)];
            [decorator start:blackboard];
        });
        
    });
    
    context(@"when stopped", ^{

        it(@"should call willStop template method", ^{
            [[decorator should] receive:@selector(willStop:)];
            [decorator stop:blackboard];
        });

        it(@"should stop decorated task if willStop returns YES", ^{
            [[decorator stubAndReturn:theValue(YES)] willStop:blackboard];
            [[task should] receive:@selector(stop:) withArguments:blackboard];
            [decorator stop:blackboard];
        });
        
        it(@"should not stop decorated task if willStop returns NO", ^{
            [[decorator stubAndReturn:theValue(NO)] willStop:blackboard];
            [[task shouldNot] receive:@selector(stop:)];
            [decorator stop:blackboard];
        });
        
    });
    
    context(@"when run", ^{
        
        it(@"should call willRun template method", ^{
            [[decorator should] receive:@selector(willRun:) withArguments:blackboard];
            [decorator run:blackboard];
        });
        
        it(@"should run decorated task if willRun returns YES", ^{
            [[decorator stubAndReturn:theValue(YES)] willRun:blackboard];
            [[task should] receive:@selector(run:) withArguments:blackboard];
            [decorator run:blackboard];
        });
        
        it(@"should not run decorated task if willRun returns NO", ^{
            [[decorator stubAndReturn:theValue(NO)] willRun:blackboard];
            [[task shouldNot] receive:@selector(run:)];
            [decorator run:blackboard];
        });
        
        context(@"and decorated task run", ^{
            
            it(@"should call evaluateResult template method with result of decorated task", ^{
                [[decorator stubAndReturn:theValue(YES)] willRun:blackboard];
                [[task stubAndReturn:theValue(AOResultSuccess)] run:blackboard];
                [[decorator should] receive:@selector(evaluateResult:withBlackboard:) withArguments:theValue(AOResultSuccess),blackboard];
                [decorator run:blackboard];
            });
            
            it(@"should return evaluated result of decorated task", ^{
                [[decorator stubAndReturn:theValue(YES)] willRun:blackboard];
                [[task stubAndReturn:theValue(AOResultFailure)] run:blackboard];
                [[decorator stubAndReturn:theValue(AOResultSuccess)] evaluateResult:AOResultFailure withBlackboard:blackboard];
                
                [[theValue([decorator run:blackboard]) should] equal:theValue(AOResultSuccess)];
            });

        });
        
    });

});

SPEC_END