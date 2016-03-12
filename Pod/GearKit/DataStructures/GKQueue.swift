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

/// Node for the queue (private)
private final class GKQueueNode<Element> {
    
    /// Shortcut for the node type
    typealias NodeType = GKQueueNode<Element>
   
    /// Element
    var element: Element
    
    /// Next node in the queue.  Nil if tail.
    var next: NodeType? = nil
    
    /// Initialize with a value.
    ///
    /// - parameter value: The value of the element to add.
    init(element: Element) {
        self.element = element
    }    
}

/// Implementation for the queue.  This offers more flexibility since we can keep 
/// a reference on each implementations and we can also access deinit functions from the
/// queue struct.
private class GKQueueImplementation<Element> {
    
    ///
    /// MARK: Nested types
    ///
    
    /// Shortcut for the node type (same as the queue).
    typealias NodeType = GKQueueNode<Element>
    
    /// Shortcut for our own type.
    typealias ImplementationType = GKQueueImplementation<Element>

    ///
    /// MARK: Stored properties
    ///
    
    /// Reference on the head helement.
    var head: NodeType? = nil
    
    /// Reference on the tail element.
    var tail: NodeType? = nil

    ///
    /// MARK: Initializers
    ///
    
    /// Empty parameterless constructor.
    init() {
        
    }
    
    /// Essentially a copy constructor.  Use the head of another implementation
    /// and generate a new implementation with copies of all the nodes.
    init(head: NodeType?) {
        
        guard let headInstance = head else {
            
            return
        }
        
        self.tail = GKQueueNode(element: headInstance.element)
        self.head = self.tail
        
        var sequencer = headInstance.next
        
        while let sequencerInstance = sequencer {
            
            let oldTail = tail
            self.tail = NodeType(element: sequencerInstance.element)
            oldTail?.next = self.tail

            sequencer = sequencer?.next
        }
    }
    
}

extension GKQueueImplementation {
    
    ///
    /// MARK: Computed properties
    ///
    
    /// Count of the elements in the queue.
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
}

extension GKQueueImplementation {
    
    ///
    /// MARK: Methods
    ///
    
    /// Append a node to the queue.
    func append(newElement: Element) {
        
        let oldTail = tail
        tail = GKQueueNode(element: newElement)
        
        if head == nil {
            head = tail
        }
        else {
            oldTail?.next = self.tail
        }
        
    }
    
    /// Remove an element from the queue and return its value.
    func dequeue() -> Element? {
        
        guard let headInstance = self.head else {
            
            return nil
        }
        
        self.head = headInstance.next
        
        if headInstance.next == nil {
            tail = nil
        }
        
        return headInstance.element
    }
    
    /// Return the value of the last element in the queue without removing it.
    func peek() -> Element? {
        
        return head?.element
    }
    
    /// Return a new copy of the implementation with copies of the nodes for a struct-like behavior.
    func copy() -> ImplementationType {
        return ImplementationType(head: self.head)
    }
    
    /// Clear the queue.
    func clear() {
        
        // ARC ensures that setting the head and tail to nil will free
        // all nodes.
        head = nil
        tail = nil
    }
}

extension GKQueueImplementation {
    
    ///
    /// MARK: SequenceType implementation
    ///

    /// Generate the sequence from the queue.
    ///
    /// - returns: The generator that builds the sequence.
    func generate() -> AnyGenerator<Element> {
        
        var current : NodeType? = self.head
        
        return anyGenerator {
            
            while (current != nil) {
                
                if let currentInstance = current {
                    
                    current = current?.next
                    return currentInstance.element
                }
            }
            
            return nil
        }
    }
}

/// Implementation of a generic FIFO queue.  It has copy-on-write semantics.
/// Note: We do not implement the MutableCollectionType or CollectionType for this class.
/// The reason is that subscript should intuitively be a O(1) operation, and in the case
/// of a queue, it would require traversal and therefore be O(n).  Therefore, we prefer using
/// the SequenceType protocol.
public struct GKQueue<Element> {

    ///
    /// MARK: Nested types
    ///
    
    /// Shortcut for the type of the associated implementation.
    private typealias ImplementationType = GKQueueImplementation<Element>
    
    ///
    /// MARK: Initializers
    ///
    
    /// Empty parameterless constructor.
    public init() {
        
    }
    
    /// Initialize from another sequence.
    ///
    /// - parameter s: Other sequence from which to initialize (typically an Array).
    public init<S : SequenceType where S.Generator.Element: Comparable>(_ s: S) {
        
        var generator = s.generate()
        
        while let nextElement = generator.next() {
            
            append(nextElement as! Element)
        }
    }

    ///
    /// MARK: Stored properties
    ///
    
    /// Reference on the implementation.  This allows us to combine the safeness and elegance
    /// of a struct with the functionalities of a class (reference, deinit functionalities, etc.).
    private var implementation: ImplementationType = ImplementationType()
}

extension GKQueue {

    ///
    /// MARK: Private methods
    ///
    
    /// Ensure that we have a unique reference on our struct.
    /// Otherwise, we create a copy.
    private mutating func ensureUnique() {
        if !isUniquelyReferencedNonObjC(&implementation) {
            implementation = implementation.copy()
        }
    }
}

extension GKQueue {
    
    /// Append at the end of the queue.
    ///
    /// - parameter newElement: Value of the new element to append at the end of the queue.
    public mutating func append(newElement: Element) {
        ensureUnique()
        implementation.append(newElement)
    }
    
    /// Remove the first element from the queue and returns its value.
    ///
    /// - returns: Value of the first element in the queue, nil if the queue is empty.
    public mutating func dequeue() -> Element? {
        ensureUnique()
        return implementation.dequeue()
    }
    
    /// Returns the value of the first element in the queue without removing it.
    ///
    /// - returns: Value of the first element in the queue, nil if the queue is empty.
    public func peek() -> Element? {
        
        return implementation.peek()
    }
    
    /// Delete all the nodes in the queue.  Note if you have references on the elements
    /// inside the queue itself, they will not be deleted.
    public mutating func clear() {
        
        ensureUnique()
        return implementation.clear()
    }
}

extension GKQueue {
    
    ///
    /// MARK: Computed properties
    ///
    
    /// Returns the number of elements in the queue.
    public var count: Int {
        
        return implementation.count
    }
    
    /// Returns true for an empty queue (count == 0) and false otherwise.
    public var isEmpty: Bool {
        
        return count == 0
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

