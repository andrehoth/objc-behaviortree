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

#import "Seek.h"

#import "Food.h"

@implementation Seek

- (id)init
{
    self = [super init];
    if (self) {
        _rate = 0.1;
    }
    return self;
}

-(AOResult) run:(id)blackboard {
    Actor *actor = [blackboard actor];
    Actor *target = [blackboard objectForKey:@"target"];
    
    if (!target)
        return AOResultFailure;
        
    CGPoint offset = CGPointSubtract(target.position, actor.position);
    
    if (CGPointMagnitude(offset) < 10)
        return AOResultSuccess;
    
    CGPoint v = CGPointScale(CGPointNormalize(offset), actor.speed);
    
    actor.position = CGPointAdd(actor.position, v);
    
    return AOResultPending;
}

@end
