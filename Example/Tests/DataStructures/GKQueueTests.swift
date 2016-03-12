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
        peekTests()
        structTests()
        
        clearTests()
        sequenceTypeTests()
    }
    
    //
    // MARK: emptyQueueTests
    //
    
    func emptyQueueTests() {
        
        describe("GKQueue empty tests") {
            
            context("GKQueue empty int ist") {
                
                it("should return nil for peek/dequeue") {
                    
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    
                    expect(myQueue.count).to(equal(0))

                    expect(myQueue.dequeue()).to(beNil())
                    expect(myQueue.peek()).to(beNil())
                    
                    expect(myQueue.count).to(equal(0))
                }
            }
        }
    }
    
    //
    // MARK: dequeueTests
    //
    
    func dequeueTests() {
        
        describe("GKQueue dequeue tests") {
            
            context("GKQueue dequeue Int one value") {
                
                it("should dequeue the first element and return a nil list") {
                    
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    myQueue.append(1)
                    
                    expect(myQueue.count).to(equal(1))
                    
                    expect(myQueue.dequeue()).to(equal(1))
                    
                    expect(myQueue.count).to(equal(0))
                    
                    expect(myQueue.dequeue()).to(beNil())
                    
                    expect(myQueue.count).to(equal(0))
                }
            }
            
            context("GKQueue dequeue Int multiple values") {
                
                it("should dequeue values in a FIFO order") {
                   
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    myQueue.append(1)
                    myQueue.append(2)
                    myQueue.append(3)
                    myQueue.append(4)
                    
                    expect(myQueue.count).to(equal(4))
                    
                    expect(myQueue.dequeue()).to(equal(1))
                    expect(myQueue.count).to(equal(3))

                    expect(myQueue.dequeue()).to(equal(2))
                    expect(myQueue.count).to(equal(2))

                    expect(myQueue.dequeue()).to(equal(3))
                    expect(myQueue.count).to(equal(1))

                    expect(myQueue.dequeue()).to(equal(4))
                    expect(myQueue.count).to(equal(0))
                }
            }
        }
    }
    
    //
    // MARK: peekTests
    //
    
    func peekTests() {
        
        describe("GKQueue peekTests") {
            
            context("GKQueue peek Int one value") {
                
                it("should peek the first element and not dequeue it") {
                    
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    myQueue.append(1)

                    expect(myQueue.count).to(equal(1))
                    
                    expect(myQueue.peek()).to(equal(1))
                    expect(myQueue.peek()).to(equal(1))
                    
                    expect(myQueue.count).to(equal(1))
                }
            }
            
            context("GKQueue peek Int multiple values") {
                
                it("should peek and dequeue values in the proper order") {
                    
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    myQueue.append(1)
                    myQueue.append(2)
                    myQueue.append(3)
                    myQueue.append(4)
                    
                    expect(myQueue.peek()).to(equal(1))
                    expect(myQueue.dequeue()).to(equal(1))
                    
                    expect(myQueue.peek()).to(equal(2))
                    expect(myQueue.dequeue()).to(equal(2))
                    
                    expect(myQueue.peek()).to(equal(3))
                    expect(myQueue.dequeue()).to(equal(3))
                    
                    expect(myQueue.peek()).to(equal(4))
                    expect(myQueue.dequeue()).to(equal(4))
                    
                    expect(myQueue.peek()).to(beNil())
                }
            }
        }
    }
    
    //
    // MARK: struct tests
    //
    func structTests() {
        
        describe("GKQueue structTests") {
            
            context("GKQueue struct Int one value") {
                
                it("should reflect the value in both copies") {
                    
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    myQueue.append(1)
                    
                    var myOtherQueue = myQueue
                    
                    expect(myQueue.peek()).to(equal(1))
                    expect(myOtherQueue.peek()).to(equal(1))
                    
                    expect(myQueue.dequeue()).to(equal(1))
                    expect(myQueue.dequeue()).to(beNil())

                    expect(myOtherQueue.dequeue()).to(equal(1))
                    expect(myOtherQueue.dequeue()).to(beNil())
                }
            }
            
            context("GKQueue struct Int multiple values") {
                
                it("should reflect the value in both copies") {
                    
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    myQueue.append(1)
                    myQueue.append(2)
                    myQueue.append(3)
                    myQueue.append(4)
                    
                    var myOtherQueue = myQueue
                    
                    expect(myQueue.peek()).to(equal(1))
                    expect(myQueue.dequeue()).to(equal(1))
                    
                    expect(myQueue.peek()).to(equal(2))
                    expect(myQueue.dequeue()).to(equal(2))
                    
                    expect(myQueue.peek()).to(equal(3))
                    expect(myQueue.dequeue()).to(equal(3))
                    
                    expect(myQueue.peek()).to(equal(4))
                    expect(myQueue.dequeue()).to(equal(4))
                    
                    expect(myQueue.peek()).to(beNil())
                    
                    expect(myOtherQueue.peek()).to(equal(1))
                    expect(myOtherQueue.dequeue()).to(equal(1))
                    
                    expect(myOtherQueue.peek()).to(equal(2))
                    expect(myOtherQueue.dequeue()).to(equal(2))
                    
                    expect(myOtherQueue.peek()).to(equal(3))
                    expect(myOtherQueue.dequeue()).to(equal(3))
                    
                    expect(myOtherQueue.peek()).to(equal(4))
                    expect(myOtherQueue.dequeue()).to(equal(4))
                    
                    expect(myOtherQueue.peek()).to(beNil())
                }
            }
        }
    }
    
    func clearTests() {
        
        describe("GKQueue clear tests") {
            
            context("Empty int ist") {
                
                it("should keep a count of 0") {
                    
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    
                    expect(myQueue.count).to(equal(0))
                    
                    myQueue.clear()
                    
                    expect(myQueue.count).to(equal(0))
                }
            }
            
            context("Single int ist") {
                
                it("should keep a count of 0") {
                    
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    
                    myQueue.append(1)
                    
                    expect(myQueue.count).to(equal(1))
                    
                    myQueue.clear()
                    
                    expect(myQueue.count).to(equal(0))
                }
            }
            
            context("Multiple int ist") {
                
                it("should keep a count of 0") {
                    
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    
                    myQueue.append(1)
                    myQueue.append(2)
                    myQueue.append(3)
                    myQueue.append(4)
                    
                    expect(myQueue.count).to(equal(4))
                    
                    myQueue.clear()
                    
                    expect(myQueue.count).to(equal(0))
                }
            }

        }
    }
    
    //
    // MARK: sequenceTypeTests
    //
    
    func sequenceTypeTests() {
        
        describe("SequenceType tests") {
            
            context("Array from queue") {
                
                it("Should create an empty array from an empty queue") {
                    
                    let myQueue: GKQueue<Int> = GKQueue<Int>()
                    let myArray = Array(myQueue)
                    
                    expect(myArray).to(beEmpty())
                }
                
                it("Should create an array from a single value queue") {
                    
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    myQueue.append(1)
                    let myArray = Array(myQueue)
                    
                    expect(myArray).to(equal([1]))
                }
                
                it("Should create an array from a multiple value queue") {
                    
                    var myQueue: GKQueue<Int> = GKQueue<Int>()
                    myQueue.append(1)
                    myQueue.append(2)
                    myQueue.append(3)
                    myQueue.append(4)
                    
                    let myArray = Array(myQueue)
                    
                    expect(myArray).to(equal([1, 2, 3, 4]))
                }
            }
            
            context("Queue from array") {
                
                it("Should create an empty queue from an empty array") {
                    
                    let myArray: [Int] = []
                    let myQueue: GKQueue<Int> = GKQueue<Int>(myArray)
                    
                    expect(myQueue.isEmpty).to(beTrue())
                }
                
                it("Should create a single value queue from a single value array") {
                    
                    let myArray: [Int] = [1]
                    let myQueue: GKQueue<Int> = GKQueue<Int>(myArray)
                    
                    expect(myQueue.count).to(equal(1))
                    expect(myQueue.peek()).to(equal(1))
                }
                
                it("Should create a proper queue from a multiple value array") {
                    
                    let myArray: [Int] = [1, 2, 3, 4]
                    var myQueue: GKQueue<Int> = GKQueue<Int>(myArray)
                    
                    expect(myQueue.count).to(equal(4))
                    expect(myQueue.dequeue()).to(equal(1))
                    expect(myQueue.dequeue()).to(equal(2))
                    expect(myQueue.dequeue()).to(equal(3))
                    expect(myQueue.dequeue()).to(equal(4))
                }
            }
        }
    }
}
