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

import Foundation

// Note: We do not implement the MutableCollectionType or CollectionType for this class.
// The reason is that subscript should intuitively be a O(1) operation, and in the case 
// of a queue, it would require traversal and therefore be O(n).  Therefore, we prefer using
// the SequenceType protocol.

private final class GKQueueNode<Element> {
    
    typealias NodeType = GKQueueNode<Element>
    
    var value: Element
    
    var next: NodeType? = nil
    
    init(value: Element) {
        self.value = value
    }    
}

private class GKQueueImplementation<Element> {
    
    typealias NodeType = GKQueueNode<Element>
    typealias QueueType = GKQueueImplementation<Element>

    var head: NodeType? = nil
    var tail: NodeType? = nil

    init() {
        
    }
    
    init(head: NodeType?) {
        
        guard let headInstance = head else {
            
            return
        }
        
        self.tail = GKQueueNode(value: headInstance.value)
        self.head = self.tail
        
        var sequencer = headInstance.next
        
        while let sequencerInstance = sequencer {
            
            let oldTail = tail
            self.tail = NodeType(value: sequencerInstance.value)
            oldTail?.next = self.tail

            sequencer = sequencer?.next
        }
    }
    
    func append(newElement: Element) {
        
        let oldTail = tail
        tail = GKQueueNode(value: newElement)
        
        if head == nil {
            head = tail
        }
        else {
            oldTail?.next = self.tail
        }

    }
    
    func dequeue() -> Element? {
        
        guard let headInstance = self.head else {
            
            return nil
        }
        
        self.head = headInstance.next
        
        if headInstance.next == nil {
            tail = nil
        }
        
        return headInstance.value
    }
    
    func peek() -> Element? {
        
        return head?.value
    }
    
    func copy() -> QueueType {
        return QueueType(head: self.head)
    }
    
    func clear() {
        
        // ARC ensures that setting the head and tail to nil will free
        // all nodes.
        head = nil
        tail = nil
    }
    
    var count: Int {
        
        var sequencer = head
        
        if sequencer == nil {
            
            return 0
        }
        
        var returnCount: Int = 0
        
        while sequencer != nil {
            
            returnCount += 1
            sequencer = sequencer!.next
        }
        
        return returnCount
    }
    
    /// Generate the sequence from the queue.
    ///
    /// - returns: The generator that builds the sequence.
    func generate() -> AnyGenerator<Element> {
        
        var current : NodeType? = self.head
        
        return anyGenerator {
            
            while (current != nil) {
                
                if let currentInstance = current {
                    
                    current = current?.next
                    return currentInstance.value
                }
            }
            
            return nil
        }
    }
}



public struct GKQueue<Element> {

    private typealias ImplementationType = GKQueueImplementation<Element>
    
    public init() {
        
    }
    
    /// Initialize from another sequence.
    public init<S : SequenceType where S.Generator.Element: Comparable>(_ s: S) {
        
        var generator = s.generate()
        
        while let nextElement = generator.next() {
            
            append(nextElement as! Element)
        }
    }

    private var implementation: ImplementationType = ImplementationType()
}

extension GKQueue {

    private mutating func ensureUnique() {
        if !isUniquelyReferencedNonObjC(&implementation) {
            implementation = implementation.copy()
        }
    }

}


extension GKQueue {
    
    public mutating func append(newElement: Element) {
        ensureUnique()
        implementation.append(newElement)
    }
    
    public mutating func dequeue() -> Element? {
        ensureUnique()
        return implementation.dequeue()
    }
    
    // peek
    public func peek() -> Element? {
        
        return implementation.peek()
    }
    
    // Count
    public var count: Int {

        return implementation.count
    }
    
    // isEmpty
    public var isEmpty: Bool {
        
        return count == 0
    }
    
    // Clear
    public mutating func clear() {
        
        ensureUnique()
        return implementation.clear()
    }
}

extension GKQueue : SequenceType {
    
    ///
    /// MARK: SequenceType implementation
    ///
    
    /// Generate the sequence from the queue.
    ///
    /// - returns: The generator that builds the sequence.
    public func generate() -> AnyGenerator<Element> {
        
        return implementation.generate()
    }
}

