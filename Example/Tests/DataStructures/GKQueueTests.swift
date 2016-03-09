// The MIT License (MIT)
//
// Copyright (c) 2015 pascaljette
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// https://github.com/Quick/Quick

import Quick
import Nimble
import GearKit

/// Tests for GKQueue
class GKQueueTests: QuickSpec {
    
    override func spec() {
        
        emptyQueueTests()
        dequeueTests()
    }
    
    //
    // MARK: emptyQueueTests
    //
    
    func emptyQueueTests() {
        
        describe("GKQueue empty tests") {
            
            context("GKQueue empty int ist") {
                
                var myQueue: GKQueue<Int> = GKQueue<Int>()
                
                expect(myQueue.dequeue()).to(beNil())
                expect(myQueue.peek()).to(beNil())
            }
        }
    }
    
    //
    // MARK: dequeueTests
    //
    
    func dequeueTests() {
        
        describe("GKQueue dequeue tests") {
            
            context("GKQueue dequeue Int one value") {
                
                var myQueue: GKQueue<Int> = GKQueue<Int>()
                myQueue.append(1)
                
                expect(myQueue.dequeue()).to(equal(1))
                expect(myQueue.dequeue()).to(beNil())
            }
            
            context("GKQueue dequeue Int multiple values") {
                
                var myQueue: GKQueue<Int> = GKQueue<Int>()
                myQueue.append(1)
                myQueue.append(2)
                myQueue.append(3)
                myQueue.append(4)

                expect(myQueue.dequeue()).to(equal(1))
                expect(myQueue.dequeue()).to(equal(2))
                expect(myQueue.dequeue()).to(equal(3))
                expect(myQueue.dequeue()).to(equal(4))
            }
        }
    }
}
