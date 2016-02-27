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

/// Tests for Swift Array extension methods
class GKDoublyLinkedListTests: QuickSpec {
    
    override func spec() {
        
        emptyListTests()
        insertHeadTests()
        insertTailTests()
        insertBeforeTests()
        insertAfterTests()
        
    }
    
    //
    // MARK: emptyListTests
    //

    func emptyListTests() {
        
        describe("GKDoublyLinkedList empty tests") {
            
            context("Empty Int ist") {
                
                let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                
                expect(myList.first).to(beNil())
                expect(myList.last).to(beNil())
            }
        }

    }

    //
    // MARK: insertHeadTests
    //

    func insertHeadTests() {
        
        describe("GKDoublyLinkedList insertTail tests") {
            
            context("Normal cases with Int list") {
                
                it("insertTail from an empty list should add the first element") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let newNode = myList.insertHead(1)
                    
                    expect(myList.first).to(equal(1))
                    expect(myList.last).to(equal(1))
                    
                    expect(newNode.previous).to(beNil())
                    expect(newNode.next).to(beNil())
                }
                
                it("insertTail from a list with only 1 element should update head and tail") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let tailAppend = myList.insertHead(1)
                    let headAppend = myList.insertHead(2)
                    
                    expect(myList.first).to(equal(2))
                    expect(myList.last).to(equal(1))
                    
                    expect(headAppend.previous).to(beNil())
                    expect(headAppend.next?.element).to(equal(1))
                    
                    expect(tailAppend.previous?.element).to(equal(2))
                    expect(tailAppend.next?.element).to(beNil())
                }
                
                it("insertTail from a list with multiple elements should update head and tail") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let tailAppend = myList.insertHead(1)
                    myList.insertHead(2)
                    myList.insertHead(3)
                    let headAppend = myList.insertHead(4)
                    
                    
                    expect(myList.first).to(equal(4))
                    expect(myList.last).to(equal(1))
                    
                    expect(headAppend.previous).to(beNil())
                    expect(headAppend.next?.element).to(equal(3))
                    
                    expect(tailAppend.previous?.element).to(equal(2))
                    expect(tailAppend.next?.element).to(beNil())
                }
            }
        }
    }
    
    //
    // MARK: insertTailTests
    //
    
    func insertTailTests() {
        
        describe("GKDoublyLinkedList insertTail tests") {
            
            context("Normal cases with Int list") {
                
                it("insertTail from an empty list should add the first element") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let newNode = myList.insertTail(1)
                    
                    expect(myList.first).to(equal(1))
                    expect(myList.last).to(equal(1))
                    
                    expect(newNode.previous).to(beNil())
                    expect(newNode.next).to(beNil())
                }
                
                it("insertTail from a list with only 1 element should update head and tail") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let headAppend = myList.insertTail(1)
                    let tailAppend = myList.insertTail(2)
                    
                    expect(myList.first).to(equal(1))
                    expect(myList.last).to(equal(2))
                    
                    expect(headAppend.previous).to(beNil())
                    expect(headAppend.next?.element).to(equal(2))
                    
                    expect(tailAppend.previous?.element).to(equal(1))
                    expect(tailAppend.next?.element).to(beNil())
                }
                
                it("insertTail from a list with multiple elements should update head and tail") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let headAppend = myList.insertTail(1)
                    myList.insertTail(2)
                    myList.insertTail(3)
                    let tailAppend = myList.insertTail(4)
                    
                    
                    expect(myList.first).to(equal(1))
                    expect(myList.last).to(equal(4))
                    
                    expect(headAppend.previous).to(beNil())
                    expect(headAppend.next?.element).to(equal(2))
                    
                    expect(tailAppend.previous?.element).to(equal(3))
                    expect(tailAppend.next?.element).to(beNil())
                }
            }
        }
    }
    
    //
    // MARK: insertBeforeTests
    //
    
    func insertBeforeTests() {
        
        
        describe("GKDoublyLinkedList insertBefore tests") {
            
            context("Normal cases with Int list") {
                
                it("Insert to a list with only 1 element should update the head") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let lastNode = myList.insertTail(1)
                    let newNode = myList.insertBefore(lastNode, element: 2)
                    
                    expect(myList.first).to(equal(2))
                    expect(myList.last).to(equal(1))
                    
                    expect(lastNode.next).to(beNil())
                    expect(lastNode.previous?.element).to(equal(2))
                    
                    expect(newNode!.previous).to(beNil())
                    expect(newNode!.next?.element).to(equal(1))
                }
                
                it("Append from a list with several elements ") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let firstNode = myList.insertTail(1)
                    let lastNode = myList.insertTail(3)
                    let newNode = myList.insertBefore(lastNode, element: 2)
                    
                    expect(myList.first).to(equal(1))
                    expect(myList.last).to(equal(3))
                    
                    expect(firstNode.previous).to(beNil())
                    expect(firstNode.next?.element).to(equal(2))
                    
                    expect(newNode!.previous?.element).to(equal(1))
                    expect(newNode!.next?.element).to(equal(3))
                    
                    expect(lastNode.previous?.element).to(equal(2))
                    expect(lastNode.next?.element).to(beNil())
                }
            }
        }
 
    }
    
    //
    // MARK: insertAfterTests
    //
    
    func insertAfterTests() {
        
        describe("GKDoublyLinkedList insertAfter tests") {
            
            context("Normal cases with Int list") {
                
                it("Insert to a list with only 1 element should update the tail") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let firstNode = myList.insertTail(1)
                    let newNode = myList.insertAfter(firstNode, element: 2)
                    
                    expect(myList.first).to(equal(1))
                    expect(myList.last).to(equal(2))
                    
                    expect(firstNode.previous).to(beNil())
                    expect(firstNode.next?.element).to(equal(2))
                    
                    expect(newNode!.previous?.element).to(equal(1))
                    expect(newNode!.next).to(beNil())
                }
                
                it("Insert to a list with several elements ") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let firstNode = myList.insertTail(1)
                    let lastNode = myList.insertTail(3)
                    let newNode = myList.insertAfter(firstNode, element: 2)
                    
                    expect(myList.first).to(equal(1))
                    expect(myList.last).to(equal(3))
                    
                    expect(firstNode.previous).to(beNil())
                    expect(firstNode.next?.element).to(equal(2))
                    
                    expect(newNode!.previous?.element).to(equal(1))
                    expect(newNode!.next?.element).to(equal(3))
                    
                    expect(lastNode.previous?.element).to(equal(2))
                    expect(lastNode.next?.element).to(beNil())
                }
            }
        }
    }
    
    
    //
    // MARK: firstNodeOfValueTests
    //
    func firstNodeOfValueTests() {
        
        describe("GKDoublyLinkedList insertAfter tests") {
            
            context("Normal cases with Int list") {
                
                it("Should return nil for an empty list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let firstNodeOfValue = myList.firstNodeOfValue(0)
                    
                    expect(firstNodeOfValue).to(beNil())
                }
                
                it("Insert to a list with several elements ") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let firstNode = myList.insertTail(1)
                    let lastNode = myList.insertTail(3)
                    let newNode = myList.insertAfter(firstNode, element: 2)
                    
                    expect(myList.first).to(equal(1))
                    expect(myList.last).to(equal(3))
                    
                    expect(firstNode.previous).to(beNil())
                    expect(firstNode.next?.element).to(equal(2))
                    
                    expect(newNode!.previous?.element).to(equal(1))
                    expect(newNode!.next?.element).to(equal(3))
                    
                    expect(lastNode.previous?.element).to(equal(2))
                    expect(lastNode.next?.element).to(beNil())
                }
            }
        }

    }

}
