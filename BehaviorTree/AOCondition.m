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

#import "AOCondition.h"

@implementation AOCondition

-(id) initWithTask:(id<AOTask>)task
{
    self = [super init];
    if (self) {
        _task = task;
    }
    return self;
}

-(void) stop:(NSMutableDictionary*)blackboard {
    [super stop:blackboard];
    if (_task.status == Running)
        [_task stop:blackboard];
}

-(RunResult) run:(NSMutableDictionary *)blackboard {
    [super run:blackboard];
    
    if (![self evaluate:blackboard])
        return Failure;
    
    DLog(@"Condition met for %@", self);
    
    if (_task.status == Ready)
        [_task start:blackboard];
    
    RunResult result = [_task run:blackboard];
    
    if (result == Success || result == Failure) {
        [_task stop:blackboard];
        _task.status = Ready;
    } else if (result == Pending) {
        _task.status = Running;
    }
    
    return result;
}

-(BOOL) evaluate:(NSMutableDictionary*)blackboard {
    return YES;
}

@end