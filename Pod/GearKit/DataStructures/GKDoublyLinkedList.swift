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

public class GKDoublyLinkedListNode<Element: Comparable> {
    
    private init() {
        
    }
    
    private init(owner: GKDoublyLinkedList<Element>, element: Element?) {
    
        self.owner = owner
        self.element = element
    }
    
    public var element: Element?
    private(set) public var next: GKDoublyLinkedListNode?
    private(set) public var previous: GKDoublyLinkedListNode?
    
    private var owner: GKDoublyLinkedList<Element>?
}

/// Doubly linked list.  Insertions are less expensive than a Swift array.
/// Swift arrays are contiguous in memory and therefore, insertion is 0(n) whereas
/// with doubly linked-list, insertion can be made in 0(1)
public class GKDoublyLinkedList<Element: Comparable> {
    
    /// Typealias for the node.
    public typealias Node = GKDoublyLinkedListNode<Element>
    
    /// Refrence on the first element of the list.
    public var head: Node = Node()
    
    /// Reference on the last element of the list
    public var tail: Node? = nil
    
    /// Empty initializer
    public init() {
        
    }
    
    /// Append an element at the end of the list.
    ///
    /// - parameter element: The element to append.
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
    
    /// Append an element at the end of the list.
    ///
    /// - parameter element: The element to append.
    public func insertTail(element: Element) -> Node {

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
    
    // insertAfter
    public func insertAfter(node: Node, element: Element) -> Node? {
        
        // If the list is empty
        guard let _ = tail else {
            
            return nil
        }
        
        if node.owner !== self {
            
            return nil
        }
        
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
    
    // insertBefore
    public func insertBefore(node: Node, element: Element) -> Node? {
        
        // If the list is empty
        guard let _ = tail else {
            
            return nil
        }
        
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

    
    // firstNodeOfValue
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
    
    // lastNodeOfValue
    
    // removeFirst
    
    // removeLast
    
    // first (TODO rename)
    public var first: Element? {
        
        return head.element
    }
    
    // last (TODO rename)
    public var last: Element? {
        
        return tail?.element
    }
    
    // count
    
}

extension GKDoublyLinkedList where Element: CustomDebugStringConvertible {
    
    public func debugPrintAllElements() {
        
        var currentNode: Node? = head
        
        while currentNode != nil {
            
            debugPrint(currentNode)
            currentNode = currentNode?.next
        }
    }
}
