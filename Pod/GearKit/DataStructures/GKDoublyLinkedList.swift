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

///
/// MARK: GKDoublyLinkedListNode
///

/// Class representing a node in the doubly linked list. 
public final class GKDoublyLinkedListNode<Element: Comparable> {
    
    ///
    /// MARK: Initializers
    ///

    /// Parameterless constructor.
    private init() {
        
    }

    /// Normal constructor.
    ///
    /// - parameter owner: The linked list owning this node.
    /// - parameter element: The value associated with the node.
    private init(owner: GKDoublyLinkedList<Element>, element: Element?) {
    
        self.owner = owner
        self.element = element
    }
    
    ///
    /// MARK: Stored properties
    ///
    
    /// Value associated with the node.
    public var element: Element?
    
    /// Reference on the next node.  Nil if this is the last (tail) node.
    private(set) public var next: GKDoublyLinkedListNode?
    
    /// Reference on the previous node.  Nil if this is the first (head) node.
    private(set) public weak var previous: GKDoublyLinkedListNode?
    
    /// Reference to the linked list owning this node.
    private weak var owner: GKDoublyLinkedList<Element>?
}

/// Doubly linked list.  Insertions are less expensive than a Swift array.
/// Swift arrays are contiguous in memory and therefore, insertion is 0(n) whereas
/// with doubly linked-list, insertion can be made in 0(1).
/// See: http://swiftdoc.org/v2.1/type/Array/
public final class GKDoublyLinkedList<Element: Comparable> {
    
    ///
    /// MARK: Nested types
    ///
    
    /// Typealias for the node.
    public typealias Node = GKDoublyLinkedListNode<Element>
    
    ///
    /// MARK: Stored properties
    ///
    
    /// Reference on the first element of the list.
    public var head: Node = Node()
    
    /// Reference on the last element of the list
    public var tail: Node? = nil
    
    ///
    /// MARK: Initializers
    ///
    
    /// Empty initializer
    public init() {
        
    }
    
    /// Initialize from another sequence.
    public init<S : SequenceType where S.Generator.Element: Comparable>(_ s: S) {
     
        var generator = s.generate()
        
        while let nextElement = generator.next() {
            
            append(nextElement as! Element)
        }
    }
}


extension GKDoublyLinkedList {
    
    ///
    /// MARK: Node insertion
    ///
    
    /// Insert an element at the beginning of the list.
    ///
    /// - parameter element: The element to insert.
    ///
    /// - returns: A Node containing the element that has just been added.
    public func insertHead(element: Element) -> Node {
        
        // If the list is empty
        guard let _ = tail else {
            
            let newNode: Node = Node(owner: self, element: element)
            tail = newNode
            head = newNode
            
            return newNode
        }
        
        let newNode: Node = Node(owner: self, element: element)
        
        newNode.previous = nil
        newNode.next = head
        head.previous = newNode
        head = newNode
        
        return newNode
    }
    
    /// Insert an element at the end of the list.
    ///
    /// - parameter element: The element to insert.
    ///
    /// - returns: A Node containing the element that has just been added.
    public func append(element: Element) -> Node {
        
        // If the list is empty
        guard let currentTail = tail else {
            
            let newNode: Node = Node(owner: self, element: element)
            tail = newNode
            head = newNode
            
            return newNode
        }
        
        let newNode: Node = Node(owner: self, element: element)
        
        newNode.previous = currentTail
        currentTail.next = newNode
        tail = newNode
        
        return newNode
    }
    
    /// Insert an element after another known node.
    ///
    /// - parameter node: The node after which to insert a new element.
    /// - parameter element: The element to insert.
    ///
    /// - returns: A Node containing the element that has just been added.
    /// Nil if the operation failed.
    public func insertAfter(node: Node, element: Element) -> Node? {
        
        // If the list is empty
        guard let _ = tail else {
            
            return nil
        }
        
        // If the node comes from a different list
        if node.owner !== self {
            
            return nil
        }
        
        // Create the node
        let newNode = Node(owner: self, element: element)
        newNode.previous = node
        
        if node === tail {
            
            newNode.next = nil
            tail = newNode
            
        } else {
            
            newNode.next = node.next
        }
        
        node.next?.previous = newNode
        node.next = newNode
        
        return newNode
    }
    
    /// Insert an element before another known node.
    ///
    /// - parameter node: The node before which to insert a new element.
    /// - parameter element: The element to insert.
    ///
    /// - returns: A Node containing the element that has just been added.
    /// Nil if the operation failed.
    public func insertBefore(node: Node, element: Element) -> Node? {
        
        // If the list is empty.
        guard let _ = tail else {
            
            return nil
        }
        
        // If the node comes from another list.
        if node.owner !== self {
            
            return nil
        }
        
        let newNode = Node(owner: self, element: element)
        newNode.next = node
        
        if node === head {
            
            newNode.previous = nil
            head = newNode
            
        } else {
            
            newNode.previous = node.previous
        }
        
        node.previous?.next = newNode
        node.previous = newNode
        
        return newNode
    }
}

extension GKDoublyLinkedList {
    
    ///
    /// MARK: Node find
    ///
    
    /// Get the first node in the list that has an element equal to the provided parameter.
    ///
    /// - parameter element: The element against which to compare.  The first (closest to the head)
    /// node which satisfies the node.element == element condition will be returned.
    ///
    /// - returns: A Node containing the element that has just been added.
    /// Nil if the list contains no such node.
    public func firstNodeOfValue(element: Element) -> Node? {
        
        var currentNode: Node? = head
        
        while currentNode != nil {
            
            if currentNode?.element == element {
                
                return currentNode
            }
            
            currentNode = currentNode?.next
        }
        
        return nil
    }
    
    /// Get the last node in the list that has an element equal to the provided parameter.
    ///
    /// - parameter element: The element against which to compare.  The last (closest to the tail)
    /// node which satisfies the node.element == element condition will be returned.
    ///
    /// - returns: A Node containing the element that has just been added.
    /// Nil if the list contains no such node.
    public func lastNodeOfValue(element: Element) -> Node? {
        
        var currentNode: Node? = tail
        
        while currentNode != nil {
            
            if currentNode?.element == element {
                
                return currentNode
            }
            
            currentNode = currentNode?.previous
        }
        
        return nil
    }
}

extension GKDoublyLinkedList {
    
    ///
    /// MARK: Node removal
    ///
    
    /// Remove a node from the list.
    ///
    /// - parameter node: The node to remove.
    ///
    /// - returns: True if the node could be removed, false otherwise.
    public func removeNode(node: Node) -> Bool {
        
        if node.owner !== self {
            
            return false
        }
        
        if node === head {
            
            return removeHead()
        }
        
        if node === tail {
            
            return removeTail()
        }
        
        guard let previousNode = node.previous, nextNode = node.next else {
            
            return false
        }
        
        previousNode.next = nextNode
        nextNode.previous = previousNode
        
        node.previous = nil
        node.next = nil
        
        return true
    }
    
    /// Remove the first (head) node in the list.
    ///
    /// - returns: True if the operation succeeds, false otherwise.
    public func removeHead() -> Bool {
        
        // if the list is empty
        if isEmpty {
            
            return false
        }
        
        // If the list contains only one element.
        if head === tail {
            
            head = Node()
            tail = nil
            return true
        }
        
        // If the list contains multiple elements.
        guard let newHead = head.next else {
            
            return false
        }
        
        newHead.previous = nil
        head = newHead
        
        return true
    }
    
    /// Remove the last (tail) node in the list.
    ///
    /// - returns: True if the operation succeeds, false otherwise.
    public func removeTail() -> Bool {
        
        
        // if the list is empty
        if isEmpty {
            
            return false
        }
        
        // If the list contains only one element
        if head === tail {
            
            head = Node()
            tail = nil
            return true
        }
        
        // If the list contains multiple elements
        guard let newTail = tail?.previous else {
            
            return false
        }
        
        newTail.next = nil
        tail = newTail
        
        return true
    }
    
    
    /// Remove the first (closest to the head) node in the list that
    /// has an element equal to the provided parameter.
    ///
    /// - parameter element: The element against which to compare.  The first (closest to the head)
    /// node which satisfies the node.element == element condition will be removed.
    ///
    /// - returns: True if the operation succeeds, false otherwise.
    public func removeFirstNodeOfValue(element: Element) -> Bool {
        
        guard let node = firstNodeOfValue(element) else {
            
            return false
        }
        
        return removeNode(node)
    }
    
    /// Remove the last (closest to the tail) node in the list that
    /// has an element equal to the provided parameter.
    ///
    /// - parameter element: The element against which to compare.  The first (closest to the head)
    /// node which satisfies the node.element == element condition will be removed.
    ///
    /// - returns: True if the operation succeeds, false otherwise.
    public func removeLastNodeOfValue(element: Element) -> Bool {
        
        guard let node = lastNodeOfValue(element) else {
            
            return false
        }
        
        return removeNode(node)
    }
    
    /// Clear the list by removing all nodes.
    /// We must remove all references here to make sure memory is properly de-allocated.
    public func clear() {
        
        guard let _ = tail else {
            
            return
        }
        
        var currentNode: Node? = head
        
        while(currentNode != nil) {
            
            var nodeToDelete = currentNode
            
            nodeToDelete!.previous = nil
            nodeToDelete!.next = nil
            nodeToDelete = nil
            
            currentNode = currentNode!.next
        }
        
        head = Node()
        tail = nil
    }
}

extension GKDoublyLinkedList {
    
    ///
    /// MARK: List queries
    ///
    
    /// Value contained in the first (head) node.  Nil for an empty list.
    public var firstValue: Element? {
        
        return head.element
    }
    
    /// Value contained in the last (tail) node.  Nil for an empty list.
    public var lastValue: Element? {
        
        return tail?.element
    }
    
    /// Whether the list is empty.  Returns false if the list contains at least 1 value.
    public var isEmpty: Bool {
        
        return count == 0
    }
    
    /// Number of elements in the list.
    public var count: Int {
        
        guard let _ = tail else {
            
            return 0
        }
        
        var count: Int = 0
        var currentNode: Node? = head
        
        while(currentNode != nil) {
            
            count += 1
            currentNode = currentNode!.next
        }
        
        return count
    }
        
    /// Check whether the list contains the provided element.
    ///
    /// - parameter element: Comparable element against which to check for equality (==)
    ///
    /// - returns: True if the list contains the element, false otherwise.
    public func contains(element: Element) -> Bool {
        
        return firstNodeOfValue(element) != nil
    }
}

extension GKDoublyLinkedList : SequenceType {
    
    ///
    /// MARK: SequenceType implementation
    ///
    
    /// Generate the sequence from the list.
    ///
    /// - returns: The generator that builds the sequence.
    public func generate() -> AnyGenerator<Element> {
        
        var current : GKDoublyLinkedList.Node? = head
        
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

extension GKDoublyLinkedList: CustomStringConvertible {
    
    ///
    /// MARK: Functions for CustomStringConvertible elements
    ///
    
    /// Description of the list based on all contained elements.
    public var description: String {
        
        let currentNode: Node? = head
        var fullDescription: String = ""
        
        while currentNode != nil {

            if currentNode !== head {
                
                fullDescription += ", "
            }
            
            fullDescription += "[\((currentNode as? CustomStringConvertible)?.description)]"
        }

        return fullDescription
    }
}

extension GKDoublyLinkedList: CustomDebugStringConvertible {
    
    ///
    /// MARK: Functions for CustomDebugStringConvertible elements
    ///
    
    /// Description of the list based on all contained elements.
    public var debugDescription: String {
        
        let currentNode: Node? = head
        var fullDescription: String = ""
        
        while currentNode != nil {
            
            if currentNode !== head {
                
                fullDescription += ", "
            }
            
            fullDescription += "[\(currentNode.debugDescription)]"
        }
        
        return fullDescription
    }
}
