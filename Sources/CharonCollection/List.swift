// CharonCollections - A Collection Library for Swift
//
// Copyright 2019 Charon Technology G.K.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

/// A functional-programming style list.
public indirect enum List<Element> {
	case empty
	case contains(head: Element, tail: List<Element>)

	// Complexity: O(n) where n = self.count
	public var count: Int {
		switch self {
		case .empty:
			return 0
		case .contains(_, let tail):
			return 1 + tail.count
		}
	}

	public init() {
		self = .empty
	}

	public init(_ head: Element, _ tail: List<Element>) {
		self = .contains(head: head, tail: tail)
	}

	public init<S: Sequence>(_ sequence: S) where S.Element == Element {
		self.init(iterator: sequence.makeIterator())
	}

	private init<I: IteratorProtocol>(iterator: I) where I.Element == Element {
		var iterator = iterator
		if let next = iterator.next() {
			self = .contains(head: next, tail: List(iterator: iterator))
		} else {
			self = .empty
		}
	}

	/// Complexity: O(n) where n = self.count
	public mutating func append(_ element: Element) {
		append(List<Element>(element, nil))
	}

	/// Complexity: O(n) where n = self.count
	public mutating func append(_ list: List<Element>) {
		self = self + list
	}

	/// Complexity: O(n) where n = self.count + sequence.count
	public mutating func append<S: Sequence>(_ sequence: S)
			where S.Element == Element {
		append(List(sequence))
	}

	/// Complexity: O(n) where n = lhs.count
	public static func +(lhs: List<Element>, rhs: List<Element>) -> List<Element> {
		switch lhs {
		case .empty:
			return rhs
		case .contains(let head, let tail):
			return .contains(head: head, tail: tail + rhs)
		}
	}

	/// Complexity: O(1)
	@discardableResult
	public mutating func removeFirst() -> Element {
		switch self {
		case .empty:
			fatalError("Can't remove first element from an empty list")
		case .contains(let head, let tail):
			self = tail
			return head
		}
	}

	/// Complexity: O(n) where n = self.count
	@discardableResult
	public mutating func removeLast() -> Element {
		switch self {
		case .empty:
			fatalError("Can't remove last element from an empty list")
		case .contains(let head, var tail):
			switch tail {
			case .empty:
				self = .empty
				return head
			case .contains:
				let value = tail.removeLast()
				self = .contains(head: head, tail: tail)
				return value
			}
		}
	}

	/// Complexity: O(n) where n = self.count
	public mutating func removeAll(where: (Element) -> Bool) {
		if case .contains(let head, var tail) = self {
			let remove = `where`(head)
			tail.removeAll(where: `where`)
			if remove {
				self = tail
			} else {
				self = .contains(head: head, tail: tail)
			}
		}
	}

	/// Complexity: O(n) where n = self.count
	public mutating func removeAll() {
		self = .empty
	}

	/// Complexity: O(1)
	public mutating func popFirst() -> Element? {
		switch self {
		case .empty:
			return nil
		case .contains:
			return removeFirst()
		}
	}

	/// Complexity: O(n) where n = self.count
	public mutating func popLast() -> Element? {
		switch self {
		case .empty:
			return nil
		case .contains:
			return removeLast()
		}
	}

	public func reversed() -> ReverseList<Element> {
		return ReverseList(list: self)
	}
}

extension List: Sequence, IteratorProtocol {
	public mutating func next() -> Element? {
		switch self {
		case .empty:
			return nil
		case .contains(let head, let tail):
			self = tail
			return head
		}
	}
}

extension List: ExpressibleByNilLiteral {
	public init(nilLiteral: Void) {
		self = .empty
	}
}

extension List: ExpressibleByArrayLiteral {
	public init(arrayLiteral: Element...) {
		self.init(arrayLiteral)
	}
}

extension List {
	fileprivate func join(buffer: inout String, separator: String) {
		if case .contains(let head, let tail) = self {
			buffer += String(reflecting: head)
			if case .contains = tail {
				buffer += separator
				tail.join(buffer: &buffer, separator: separator)
			}
		}
	}
}

extension List: CustomDebugStringConvertible {
	public var debugDescription: String {
		var desc = "List(["
		join(buffer: &desc, separator: ", ")
		desc += "])"
		return desc
	}
}

extension List: CustomStringConvertible {
	public var description: String {
		var desc = "["
		join(buffer: &desc, separator: ", ")
		desc += "]"
		return desc
	}
}

extension List: Decodable where Element: Decodable {
	private init(container: inout UnkeyedDecodingContainer) throws {
		if container.isAtEnd {
			self = .empty
		} else {
			let value = try container.decode(Element.self)
			self = List(value, try List(container: &container))
		}
	}
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		try self.init(container: &container)
	}
}

extension List: Encodable where Element: Encodable {
	private func encode(container: inout UnkeyedEncodingContainer) throws {
		switch self {
		case .empty:
			break
		case .contains(let head, let tail):
			try container.encode(head)
			try tail.encode(container: &container)
		}
	}
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try encode(container: &container)
	}
}

extension List: Equatable where List.Element: Equatable {
}

extension List: Hashable where List.Element: Hashable {
}
