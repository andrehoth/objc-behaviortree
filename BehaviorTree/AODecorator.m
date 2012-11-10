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

#import "AODecorator.h"

@implementation AODecorator

-(id) initWithTask:(id<AOTask>)task {
    if ((self = [super init])) {
        _task = task;
    }
    return self;
}

-(void) start:(NSMutableDictionary *)blackboard {
    if ([self willStart:blackboard])
        [_task start:blackboard];
}

-(AOResult) run:(NSMutableDictionary *)blackboard {
    AOResult result = AOResultSuccess;
    
    if ([self willRun:blackboard])
        result = [self evaluateResult:[_task run:blackboard] withBlackboard:blackboard];
    
    return result;
}

-(void) stop:(NSMutableDictionary *)blackboard {
    if ([self willStop:blackboard])
        [_task stop:blackboard];
}

#pragma mark Template methods

-(BOOL) willStart:(NSMutableDictionary*)blackboard {
    return YES;
}

-(BOOL) willRun:(NSMutableDictionary*)blackboard {
    return YES;
}

-(BOOL) willStop:(NSMutableDictionary*)blackboard {
    return YES;
}

-(AOResult) evaluateResult:(AOResult)result withBlackboard:(NSMutableDictionary*)blackboard {
    return result;
}

@end
