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
public final class GKDoublyLinkedListNode<Element> {
    
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
    private init(owner: GKDoublyLinkedListImplementation<Element>, element: Element?) {
    
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
    private weak var owner: GKDoublyLinkedListImplementation<Element>?
}

private class GKDoublyLinkedListImplementation<Element> {
    
    ///
    /// MARK: Nested types
    ///
    
    typealias NodeType = GKDoublyLinkedList<Element>.NodeType
    typealias ImplementationType = GKDoublyLinkedListImplementation<Element>

    ///
    /// MARK: Stored properties
    ///
    
    /// Reference on the first element of the list.
    var head: NodeType = NodeType()
    
    /// Reference on the last element of the list
    var tail: NodeType? = nil

    
    ///
    /// MARK: Initializers
    ///
    
    /// Empty parameterless constructor.
    init() {
        
    }
    
    /// Initialize from the head of another of another implementation.
    /// This is basically a copy constructor.
    init(head: NodeType) {
        
        var current: NodeType? = head
        
        while (current != nil) {
            
            if let elementInstance = current!.element {
                
                append(elementInstance)
            }
            
            current = current!.next
        }
    }
    
    /// Returns a copy of the implementation (with new re-generated nodes).
    func copy() -> ImplementationType {
        
        return ImplementationType(head: self.head)
    }

}

extension GKDoublyLinkedListImplementation {
    
    ///
    /// MARK: Computed properties
    ///
    
    /// Number of elements in the list.
    var count: Int {
        
        guard let _ = tail else {
            
            return 0
        }
        
        var count: Int = 0
        var currentNode: NodeType? = head
        
        while(currentNode != nil) {
            
            count += 1
            currentNode = currentNode!.next
        }
        
        return count
    }
}

extension GKDoublyLinkedListImplementation {
    
    ///
    /// MARK: Node insertion
    ///
    
    /// Insert an element at the end of the list.
    func append(element: Element) -> NodeType {
        
        // If the list is empty
        guard let currentTail = tail else {
            
            let newNode: NodeType = NodeType(owner: self, element: element)
            tail = newNode
            head = newNode
            
            return newNode
        }
        
        let newNode: NodeType = NodeType(owner: self, element: element)
        
        newNode.previous = currentTail
        currentTail.next = newNode
        tail = newNode
        
        return newNode
    }
    
    /// Insert an element at the beginning of the list.
    func insertHead(element: Element) -> NodeType {
        
        // If the list is empty
        guard let _ = tail else {
            
            let newNode: NodeType = NodeType(owner: self, element: element)
            tail = newNode
            head = newNode
            
            return newNode
        }
        
        let newNode: NodeType = NodeType(owner: self, element: element)
        
        newNode.previous = nil
        newNode.next = head
        head.previous = newNode
        head = newNode
        
        return newNode
    }
    
    /// Insert an element after another known node.
    func insertAfter(node: NodeType, element: Element) throws -> NodeType? {
        
        // If the list is empty
        guard let _ = tail else {
            
            return nil
        }
        
        // If the node comes from a different list
        if node.owner !== self {
            
            throw GKDoublyLinkedListException.NodeNotOwnedByThisList
        }
        
        // Create the node
        let newNode = NodeType(owner: self, element: element)
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
    func insertBefore(node: NodeType, element: Element) throws -> NodeType? {
        
        // If the list is empty.
        guard let _ = tail else {
            
            return nil
        }
        
        // If the node comes from another list.
        if node.owner !== self {
            
            throw GKDoublyLinkedListException.NodeNotOwnedByThisList
        }
        
        let newNode = NodeType(owner: self, element: element)
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

extension GKDoublyLinkedListImplementation where Element: Comparable {
    
    ///
    /// MARK: Node find
    ///
    
    /// Get the first node in the list that has an element equal to the provided parameter.
    func firstNodeOfValue(element: Element) -> NodeType? {
        
        var currentNode: NodeType? = head
        
        while currentNode != nil {
            
            if currentNode?.element == element {
                
                return currentNode
            }
            
            currentNode = currentNode?.next
        }
        
        return nil
    }
    
    /// Get the last node in the list that has an element equal to the provided parameter.
    func lastNodeOfValue(element: Element) -> NodeType? {
        
        var currentNode: NodeType? = tail
        
        while currentNode != nil {
            
            if currentNode?.element == element {
                
                return currentNode
            }
            
            currentNode = currentNode?.previous
        }
        
        return nil
    }
}


extension GKDoublyLinkedListImplementation {
    
    ///
    /// MARK: Node removal
    ///
    
    /// Remove a node from the list.
    func removeNode(node: NodeType) throws -> Bool {
        
        if node.owner !== self {
            
            throw GKDoublyLinkedListException.NodeNotOwnedByThisList
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
    func removeHead() -> Bool {
        
        // if the list is empty
        guard let _ = tail else {
            
            return false
        }
        
        // If the list contains only one element.
        if head === tail {
            
            head = NodeType()
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
    func removeTail() -> Bool {
        
        
        // if the list is empty
        guard let _ = tail else {
            
            return false
        }
        
        // If the list contains only one element
        if head === tail {
            
            head = NodeType()
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
    
    /// Clear the list by removing all nodes.
    /// We must remove all references here to make sure memory is properly de-allocated.
    func clear() {
        
        guard let _ = tail else {
            
            return
        }
        
        var currentNode: NodeType? = head
        
        while(currentNode != nil) {
            
            var nodeToDelete = currentNode
            
            nodeToDelete!.previous = nil
            nodeToDelete!.next = nil
            nodeToDelete = nil
            
            currentNode = currentNode!.next
        }
        
        head = NodeType()
        tail = nil
    }
}

extension GKDoublyLinkedListImplementation : SequenceType {
    
    ///
    /// MARK: SequenceType implementation
    ///
    
    /// Generate the sequence from the list.
    func generate() -> AnyGenerator<Element> {
        
        var current : GKDoublyLinkedList.NodeType? = head
        
        return AnyGenerator {
            
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

/// Doubly linked list.  Insertions are less expensive than a Swift array.
/// Swift arrays are contiguous in memory and therefore, insertion is 0(n) whereas
/// with doubly linked-list, insertion can be made in 0(1).
/// See: http://swiftdoc.org/v2.1/type/Array/
/// Also important to note that this list implementation is a struct and therefore, be careful
/// when keeping nodes in memory when altering the list since a new copy is made from each mutating
/// function call.  The list is copy-on-write.
public struct GKDoublyLinkedList<Element> {
    
    ///
    /// MARK: Nested types
    ///
    
    /// Typealias for the node.
    public typealias NodeType = GKDoublyLinkedListNode<Element>
    
    /// Typealias for the implementation
    private typealias ImplementationType = GKDoublyLinkedListImplementation<Element>
    
    ///
    /// MARK: Stored properties
    ///
    
    /// Reference on the class implementation for this struct
    private var implementation: ImplementationType = ImplementationType()
    
    ///
    /// MARK: Initializers
    ///
    
    /// Empty initializer
    public init() {
        
    }
    
    /// Initialize from another sequence.
    ///
    /// - parameter s: Other sequence from which to initialize (typically an Array).
    public init<S : SequenceType>(_ s: S) {
     
        var generator = s.generate()
        
        while let nextElement = generator.next() {
            
            append(nextElement as! Element)
        }
    }
}

extension GKDoublyLinkedList {
    
    ///
    /// MARK: Computed properties
    ///
    
    /// Reference on the first element of the list.
    public private(set) var head: NodeType {
        
        get {
            return implementation.head
        }
        
        set {
            
            implementation.head = newValue
        }
    }
    
    /// Reference on the last element of the list
    public private(set) var tail: NodeType? {
        get {
            return implementation.tail
        }
        
        set {
            
            implementation.tail = newValue
        }
    }
    
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
        
        return implementation.count
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
    public mutating func insertHead(element: Element) -> NodeType {

        ensureUnique()
        return implementation.insertHead(element)
    }
    
    /// Insert an element at the end of the list.
    ///
    /// - parameter element: The element to insert.
    ///
    /// - returns: A Node containing the element that has just been added.
    public mutating func append(element: Element) -> NodeType {
        
        ensureUnique()
        return implementation.append(element)
    }
    
    /// Insert an element after another known node.
    ///
    /// - parameter node: The node after which to insert a new element.
    /// - parameter element: The element to insert.
    ///
    /// - returns: A Node containing the element that has just been added.
    /// Nil if the operation failed.
    public mutating func insertAfter(node: NodeType, element: Element) throws -> NodeType? {
        
        ensureUnique()
        return try implementation.insertAfter(node, element: element)
    
    }
    
    /// Insert an element before another known node.
    ///
    /// - parameter node: The node before which to insert a new element.
    /// - parameter element: The element to insert.
    ///
    /// - returns: A Node containing the element that has just been added.
    /// Nil if the operation failed.
    public mutating func insertBefore(node: NodeType, element: Element) throws -> NodeType? {
        
        ensureUnique()
        return try implementation.insertBefore(node, element: element)
    }
}

extension GKDoublyLinkedList where Element: Comparable {
    
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
    public func firstNodeOfValue(element: Element) -> NodeType? {
        
        return implementation.firstNodeOfValue(element)
    }
    
    /// Get the last node in the list that has an element equal to the provided parameter.
    ///
    /// - parameter element: The element against which to compare.  The last (closest to the tail)
    /// node which satisfies the node.element == element condition will be returned.
    ///
    /// - returns: A Node containing the element that has just been added.
    /// Nil if the list contains no such node.
    public func lastNodeOfValue(element: Element) -> NodeType? {
        
        return implementation.lastNodeOfValue(element)
    }
    
    
    /// Remove the first (closest to the head) node in the list that
    /// has an element equal to the provided parameter.
    ///
    /// - parameter element: The element against which to compare.  The first (closest to the head)
    /// node which satisfies the node.element == element condition will be removed.
    ///
    /// - returns: True if the operation succeeds, false otherwise.
    public mutating func removeFirstNodeOfValue(element: Element) -> Bool {
        
        guard let node = firstNodeOfValue(element) else {
            
            return false
        }
        
        return try! removeNode(node)
    }
    
    /// Remove the last (closest to the tail) node in the list that
    /// has an element equal to the provided parameter.
    ///
    /// - parameter element: The element against which to compare.  The first (closest to the head)
    /// node which satisfies the node.element == element condition will be removed.
    ///
    /// - returns: True if the operation succeeds, false otherwise.
    public mutating func removeLastNodeOfValue(element: Element) -> Bool {
        
        guard let node = lastNodeOfValue(element) else {
            
            return false
        }
        
        return try! removeNode(node)
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

extension GKDoublyLinkedList {
    
    ///
    /// MARK: Node removal
    ///
    
    /// Remove a node from the list.
    ///
    /// - parameter node: The node to remove.
    ///
    /// - returns: True if the node could be removed, false otherwise.
    public mutating func removeNode(node: NodeType) throws -> Bool {
        
        ensureUnique()
        return try implementation.removeNode(node)
    }
    
    /// Remove the first (head) node in the list.
    ///
    /// - returns: True if the operation succeeds, false otherwise.
    public mutating func removeHead() -> Bool {
        
        ensureUnique()
        return implementation.removeHead()
        
    }
    
    /// Remove the last (tail) node in the list.
    ///
    /// - returns: True if the operation succeeds, false otherwise.
    public mutating func removeTail() -> Bool {
        
        ensureUnique()
        return implementation.removeTail()
    }
    
    
    /// Clear the list by removing all nodes.
    /// We must remove all references here to make sure memory is properly de-allocated.
    public mutating func clear() {
        
        ensureUnique()
        implementation.clear()
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

        return implementation.generate()
    }
}


extension GKDoublyLinkedList {
    
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

extension GKDoublyLinkedList: CustomStringConvertible {
    
    ///
    /// MARK: Functions for CustomStringConvertible elements
    ///
    
    /// Description of the list based on all contained elements.
    public var description: String {
        
        let currentNode: NodeType? = head
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
        
        let currentNode: NodeType? = head
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

/// Exception thrown when trying to generate the cell from the cell configuration instances.
public enum GKDoublyLinkedListException : ErrorType {
    
    /// The node used for insertion is not a member of this list.
    case NodeNotOwnedByThisList
}
