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
        appendTests()
        insertBeforeTests()
        insertAfterTests()
        
        firstNodeOfValueTests()
        lastNodeOfValueTests()
        
        removeNodeTests()
        
        listQueryTests()
        
        sequenceTypeTests()
    }
    
    //
    // MARK: emptyListTests
    //

    func emptyListTests() {
        
        describe("GKDoublyLinkedList empty tests") {
            
            context("Empty Int ist") {
                
                let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                
                expect(myList.firstValue).to(beNil())
                expect(myList.lastValue).to(beNil())
            }
        }

    }

    //
    // MARK: insertHeadTests
    //

    func insertHeadTests() {
        
        describe("GKDoublyLinkedList append tests") {
            
            context("Normal cases with Int list") {
                
                it("append from an empty list should add the first element") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let newNode = myList.insertHead(1)
                    
                    expect(myList.firstValue).to(equal(1))
                    expect(myList.lastValue).to(equal(1))
                    
                    expect(newNode.previous).to(beNil())
                    expect(newNode.next).to(beNil())
                }
                
                it("append from a list with only 1 element should update head and tail") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let tailAppend = myList.insertHead(1)
                    let headAppend = myList.insertHead(2)
                    
                    expect(myList.firstValue).to(equal(2))
                    expect(myList.lastValue).to(equal(1))
                    
                    expect(headAppend.previous).to(beNil())
                    expect(headAppend.next?.element).to(equal(1))
                    
                    expect(tailAppend.previous?.element).to(equal(2))
                    expect(tailAppend.next?.element).to(beNil())
                }
                
                it("append from a list with multiple elements should update head and tail") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let tailAppend = myList.insertHead(1)
                    myList.insertHead(2)
                    myList.insertHead(3)
                    let headAppend = myList.insertHead(4)
                    
                    
                    expect(myList.firstValue).to(equal(4))
                    expect(myList.lastValue).to(equal(1))
                    
                    expect(headAppend.previous).to(beNil())
                    expect(headAppend.next?.element).to(equal(3))
                    
                    expect(tailAppend.previous?.element).to(equal(2))
                    expect(tailAppend.next?.element).to(beNil())
                }
            }
        }
    }
    
    //
    // MARK: appendTests
    //
    
    func appendTests() {
        
        describe("GKDoublyLinkedList append tests") {
            
            context("Normal cases with Int list") {
                
                it("append from an empty list should add the first element") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let newNode = myList.append(1)
                    
                    expect(myList.firstValue).to(equal(1))
                    expect(myList.lastValue).to(equal(1))
                    
                    expect(newNode.previous).to(beNil())
                    expect(newNode.next).to(beNil())
                }
                
                it("append from a list with only 1 element should update head and tail") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let headAppend = myList.append(1)
                    let tailAppend = myList.append(2)
                    
                    expect(myList.firstValue).to(equal(1))
                    expect(myList.lastValue).to(equal(2))
                    
                    expect(headAppend.previous).to(beNil())
                    expect(headAppend.next?.element).to(equal(2))
                    
                    expect(tailAppend.previous?.element).to(equal(1))
                    expect(tailAppend.next?.element).to(beNil())
                }
                
                it("append from a list with multiple elements should update head and tail") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let headAppend = myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    let tailAppend = myList.append(4)
                    
                    
                    expect(myList.firstValue).to(equal(1))
                    expect(myList.lastValue).to(equal(4))
                    
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
                    let lastNode = myList.append(1)
                    let newNode = myList.insertBefore(lastNode, element: 2)
                    
                    expect(myList.firstValue).to(equal(2))
                    expect(myList.lastValue).to(equal(1))
                    
                    expect(lastNode.next).to(beNil())
                    expect(lastNode.previous?.element).to(equal(2))
                    
                    expect(newNode!.previous).to(beNil())
                    expect(newNode!.next?.element).to(equal(1))
                }
                
                it("Append from a list with several elements ") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let firstNode = myList.append(1)
                    let lastNode = myList.append(3)
                    let newNode = myList.insertBefore(lastNode, element: 2)
                    
                    expect(myList.firstValue).to(equal(1))
                    expect(myList.lastValue).to(equal(3))
                    
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
                    let firstNode = myList.append(1)
                    let newNode = myList.insertAfter(firstNode, element: 2)
                    
                    expect(myList.firstValue).to(equal(1))
                    expect(myList.lastValue).to(equal(2))
                    
                    expect(firstNode.previous).to(beNil())
                    expect(firstNode.next?.element).to(equal(2))
                    
                    expect(newNode!.previous?.element).to(equal(1))
                    expect(newNode!.next).to(beNil())
                }
                
                it("Insert to a list with several elements ") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let firstNode = myList.append(1)
                    let lastNode = myList.append(3)
                    let newNode = myList.insertAfter(firstNode, element: 2)
                    
                    expect(myList.firstValue).to(equal(1))
                    expect(myList.lastValue).to(equal(3))
                    
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
        
        describe("GKDoublyLinkedList firstNodeOfValue tests") {
            
            context("Normal cases with Int list") {
                
                it("Should return nil for an empty list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let firstNodeOfValue = myList.firstNodeOfValue(0)
                    
                    expect(firstNodeOfValue).to(beNil())
                }
                
                it("Should return the value for a list with a single value") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)

                    expect(myList.firstNodeOfValue(1)).toNot(beNil())
                    expect(myList.firstNodeOfValue(1)?.element).to(equal(1))
                    
                    expect(myList.firstNodeOfValue(2)).to(beNil())
                }
                
                
                it("Should return the value for a list with multiple values") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(1)
                    myList.append(5)
                    myList.append(6)

                    expect(myList.firstNodeOfValue(1)).toNot(beNil())
                    expect(myList.firstNodeOfValue(1)?.element).to(equal(1))
                    expect(myList.firstNodeOfValue(1)?.next?.element).to(equal(2))                    
                }
            }
        }
    }
    
    
    //
    // MARK: lastNodeOfValueTests
    //
    
    func lastNodeOfValueTests() {
        
        describe("GKDoublyLinkedList lastNodeOfValue tests") {
            
            context("Normal cases with Int list") {
                
                it("Should return nil for an empty list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let firstNodeOfValue = myList.lastNodeOfValue(0)
                    
                    expect(firstNodeOfValue).to(beNil())
                }
                
                it("Should return the value for a list with a single value") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    
                    expect(myList.lastNodeOfValue(1)).toNot(beNil())
                    expect(myList.lastNodeOfValue(1)?.element).to(equal(1))
                    
                    expect(myList.lastNodeOfValue(2)).to(beNil())
                }
                
                
                it("Should return the value for a list with multiple values") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(1)
                    myList.append(5)
                    myList.append(6)
                    
                    expect(myList.lastNodeOfValue(1)).toNot(beNil())
                    expect(myList.lastNodeOfValue(1)?.element).to(equal(1))
                    
                    expect(myList.lastNodeOfValue(1)?.previous?.element).to(equal(3))
                    expect(myList.lastNodeOfValue(1)?.next?.element).to(equal(5))
                }
            }
        }
    }
    
    //
    // MARK: lastNodeOfValueTests
    //
    
    func removeNodeTests() {
        
        describe("removeNodeTests") {
            
            context("removeHead") {
                
                it("Should return false when removing from an empty list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    
                    expect(myList.removeHead()).to(beFalse())
                }
                
                it("Should return true when removing from a single value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    
                    expect(myList.removeHead()).to(beTrue())
                    expect(myList.isEmpty).to(beTrue())
                }
                
                it("Should return true when removing from a multiple value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(4)

                    expect(myList.removeHead()).to(beTrue())
                    expect(myList.isEmpty).to(beFalse())
                    expect(myList.firstValue).to(equal(2))
                    expect(myList.lastValue).to(equal(4))
                }
            }
            
            context("removeTail") {
                
                it("Should return false when removing from an empty list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    
                    expect(myList.removeTail()).to(beFalse())
                }
                
                it("Should return true when removing from a single value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    
                    expect(myList.removeTail()).to(beTrue())
                    expect(myList.isEmpty).to(beTrue())
                }
                
                it("Should return true when removing from a multiple value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(4)
                    
                    expect(myList.removeTail()).to(beTrue())
                    expect(myList.isEmpty).to(beFalse())
                    expect(myList.firstValue).to(equal(1))
                    expect(myList.lastValue).to(equal(3))
                }
            }
            
            context("removeNode") {
                
                it("Should return true when removing from a single value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let headNode = myList.append(1)
                    
                    expect(myList.removeNode(headNode)).to(beTrue())
                    expect(myList.isEmpty).to(beTrue())
                }
                
                it("Should return true when removing from a multiple value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    let node = myList.append(3)
                    myList.append(4)
                    
                    expect(myList.removeNode(node)).to(beTrue())
                    expect(myList.isEmpty).to(beFalse())
                    
                    var nodeToCheck: GKDoublyLinkedList<Int>.Node? = myList.head
                    expect(nodeToCheck!.element).to(equal(1))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(2))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(4))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck).to(beNil())
                }
            }
            
            context("removeNode") {
                
                it("Should return true when removing from a single value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let headNode = myList.append(1)
                    
                    expect(myList.removeNode(headNode)).to(beTrue())
                    expect(myList.isEmpty).to(beTrue())
                }
                
                it("Should return true when removing from a multiple value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    let node = myList.append(3)
                    myList.append(4)
                    
                    expect(myList.removeNode(node)).to(beTrue())
                    expect(myList.isEmpty).to(beFalse())
                    
                    var nodeToCheck: GKDoublyLinkedList<Int>.Node? = myList.head
                    expect(nodeToCheck!.element).to(equal(1))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(2))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(4))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck).to(beNil())
                }
            }
            
            context("removeFirstNodeOfValue") {
                
                it("Should return false when removing from an empty list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    
                    expect(myList.removeFirstNodeOfValue(1)).to(beFalse())
                    expect(myList.isEmpty).to(beTrue())
                }
            
                it("Should return false when removing a non-existing value") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    
                    expect(myList.removeFirstNodeOfValue(2)).to(beFalse())
                    expect(myList.isEmpty).to(beFalse())
                }
                
                it("Should return true when removing from a single value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    
                    expect(myList.removeFirstNodeOfValue(1)).to(beTrue())
                    expect(myList.isEmpty).to(beTrue())
                }
                
                it("Should return true when removing from a multiple value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(1)
                    myList.append(2)
                    myList.append(5)

                    expect(myList.removeFirstNodeOfValue(2)).to(beTrue())
                    expect(myList.isEmpty).to(beFalse())
                    
                    var nodeToCheck: GKDoublyLinkedList<Int>.Node? = myList.head
                    expect(nodeToCheck!.element).to(equal(1))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(3))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(1))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(2))

                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(5))

                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck).to(beNil())
                }
            }
            
            context("removeLastNodeOfValue") {
                
                it("Should return false when removing from an empty list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    
                    expect(myList.removeLastNodeOfValue(1)).to(beFalse())
                    expect(myList.isEmpty).to(beTrue())
                }
                
                it("Should return false when removing a non-existing value") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    
                    expect(myList.removeLastNodeOfValue(2)).to(beFalse())
                    expect(myList.isEmpty).to(beFalse())
                }
                
                it("Should return true when removing from a single value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    
                    expect(myList.removeLastNodeOfValue(1)).to(beTrue())
                    expect(myList.isEmpty).to(beTrue())
                }
                
                it("Should return true when removing from a multiple value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(1)
                    myList.append(2)
                    myList.append(5)
                                        
                    expect(myList.removeLastNodeOfValue(2)).to(beTrue())
                    expect(myList.isEmpty).to(beFalse())
                    
                    var nodeToCheck: GKDoublyLinkedList<Int>.Node? = myList.head
                    expect(nodeToCheck!.element).to(equal(1))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(2))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(3))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(1))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck!.element).to(equal(5))
                    
                    nodeToCheck = nodeToCheck!.next
                    expect(nodeToCheck).to(beNil())
                }
            }
        }
    }
    
    //
    // MARK: listQueryTests
    //

    func listQueryTests() {
        
        describe("GKDoublyLinkedList lastNodeOfValue tests") {
            
            context("count tests") {
                
                it("Should return 0 for an empty list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    
                    expect(myList.count).to(equal(0))
                }
                
                it("Should return 1 for a list with a single value") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    
                    expect(myList.count).to(equal(1))
                }
                
                it("Should return proper count for a list with multiple values") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(4)

                    expect(myList.count).to(equal(4))
                }
                
                it("Should return proper count for a list with multiple values after removal") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(4)
                    
                    myList.removeFirstNodeOfValue(3)
                    
                    expect(myList.count).to(equal(3))
                }
                
                it("Should return 0 for a cleared list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(4)
                    
                    myList.clear()
                                        
                    expect(myList.count).to(equal(0))
                }
            }
            
            context("contains tests") {
            
                it("Should return false for an empty list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    
                    expect(myList.contains(0)).to(beFalse())
                }
                
                it("Should return true for a single value list containing the value") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    
                    expect(myList.contains(1)).to(beTrue())
                }
                
                it("Should return false for a single value list containing the value") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    
                    expect(myList.contains(2)).to(beFalse())
                }
                
                it("Should return true for a multiple value list containing the value") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(4)

                    expect(myList.contains(4)).to(beTrue())
                }

                it("Should return false for a multiple value list not containing the value") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(4)

                    expect(myList.contains(5)).to(beFalse())
                }
            }
        }
    }
    
    
    //
    // MARK: sequenceTypeTests
    //
    
    func sequenceTypeTests() {
        
        describe("SequenceType tests") {
            
            context("Array from list") {
                
                it("Should create an empty array from an empty list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    let myArray = Array(myList)
                    
                    expect(myArray).to(beEmpty())
                }
                
                it("Should create an array from a single value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    let myArray = Array(myList)
                    
                    expect(myArray).to(equal([1]))
                }
                
                it("Should create an array from a multiple value list") {
                    
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>()
                    myList.append(1)
                    myList.append(2)
                    myList.append(3)
                    myList.append(4)

                    let myArray = Array(myList)
                    
                    expect(myArray).to(equal([1, 2, 3, 4]))
                }                
            }
            
            context("List from array") {
                
                it("Should create an empty list from an empty array") {
                    
                    let myArray: [Int] = []
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>(myArray)
                    
                    expect(myList.isEmpty).to(beTrue())
                }
                
                it("Should create a single value list from a single value array") {
                    
                    let myArray: [Int] = [1]
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>(myArray)
                    
                    expect(myList.count).to(equal(1))
                    expect(myList.firstValue).to(equal(1))
                }
                
                it("Should create a proper list from a multiple value array") {
                    
                    let myArray: [Int] = [1, 2, 3, 4]
                    let myList: GKDoublyLinkedList<Int> = GKDoublyLinkedList<Int>(myArray)
                    
                    expect(myList.count).to(equal(4))
                    expect(myList.firstValue).to(equal(1))
                    expect(myList.lastValue).to(equal(4))
                }
            }
        }
    }
}
