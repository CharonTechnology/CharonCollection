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

/// A functional-programming style list which has reversed innter representation.
/// That means ReverseList(2:3:5:[]).head == 5 and ReverseList(2:3:5:[]).last == 2
public struct ReverseList<Element> {
	var list: List<Element>

	// Complexity: O(n) where n = self.count
	public var count: Int {
		return list.count
	}

	init(list: List<Element>) {
		self.list = list
	}

	public init() {
		list = nil
	}

	public init(_ head: ReverseList<Element>, _ tail: Element) {
		self.init(list: List<Element>(tail, head.list))
	}

	public init<S: Sequence>(_ elements: S)
			where S.Element == Element {
		self.init()
		for element in elements {
			list = List(element, list)
		}
	}

	/// Adds a new element at the end of the list.
	/// Complexity: O(1) even if there are copies of the list
	public mutating func append(_ element: Element) {
		list = List(element, list)
	}

	/// Complexity: O(n) where n = list.count
	public mutating func append(_ other: ReverseList<Element>) {
		self.list = other.list + self.list
	}

	/// Complexity: O(n) where n = sequence.count
	public mutating func append<S: Sequence>(_ sequence: S)
			where S.Element == Element {
		append(ReverseList(sequence))
	}

	/// Complexity: O(n) where n = rhs.count
	public static func +(lhs: ReverseList<Element>, rhs: ReverseList<Element>)
			-> ReverseList<Element> {
		return ReverseList(list: rhs.list + lhs.list)
	}

	/// Complexity: O(n) where n = self.count
	@discardableResult
	public mutating func removeFirst() -> Element {
		return list.removeLast()
	}

	/// Complexity: O(1)
	@discardableResult
	public mutating func removeLast() -> Element {
		return list.removeFirst()
	}

	/// Complexity: O(n) where n = self.count
	public mutating func removeAll(where:(Element) -> Bool) {
		if case .contains(let head, var tail) = list {
			tail.removeAll(where: `where`)
			if `where`(head) {
				list = tail
			} else {
				list = .contains(head: head, tail: tail)
			}
		}
	}

	/// Complexity: O(n) where n = self.count
	public mutating func removeAll() {
		list = .empty
	}

	/// Complexity: O(1)
	public mutating func popLast() -> Element? {
		return list.popFirst()
	}

	public mutating func reversed() -> List<Element> {
		return list
	}
}

extension ReverseList: Sequence {
	public typealias Iterator = IndexingIterator<Array<Element>>

	public func makeIterator() -> Iterator {
		return Array(list).reversed().makeIterator()
	}
}

extension ReverseList: ExpressibleByNilLiteral {
	public init(nilLiteral: Void) {
		list = .empty
	}
}

extension ReverseList: ExpressibleByArrayLiteral {
	public init(arrayLiteral: Element...) {
		self.init(arrayLiteral)
	}
}

extension ReverseList {
	fileprivate func join(buffer: inout String, separator: String) {
		if case .contains(let head, let tail) = list {
			if case .contains = tail {
				ReverseList(list: tail).join(buffer: &buffer, separator: separator)
				buffer += separator
			}
			buffer += String(reflecting: head)
		}
	}
}

extension ReverseList: CustomDebugStringConvertible {
	public var debugDescription: String {
		var desc = "ReverseList(["
		join(buffer: &desc, separator: ", ")
		desc += "])"
		return desc
	}
}

extension ReverseList: CustomStringConvertible {
	public var description: String {
		var desc = "["
		join(buffer: &desc, separator: ", ")
		desc += "]"
		return desc
	}
}

extension ReverseList: Decodable where Element: Decodable {
	private mutating func decode(container: inout UnkeyedDecodingContainer) throws {
		if !container.isAtEnd {
			let value = try container.decode(Element.self)
			list = List(value, list)
			try decode(container: &container)
		}
	}
	public init(from decoder: Decoder) throws {
		self.init()
		var container = try decoder.unkeyedContainer()
		try decode(container: &container)
	}
}

extension ReverseList: Encodable where Element: Encodable {
	private func encode(container: inout UnkeyedEncodingContainer) throws {
		switch list {
		case .empty:
			break
		case .contains(let head, let tail):
			try ReverseList(list: tail).encode(container: &container)
			try container.encode(head)
		}
	}
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try encode(container: &container)
	}
}

extension ReverseList: Equatable where Element: Equatable {
	public static func ==(lhs: ReverseList, rhs: ReverseList) -> Bool {
		return lhs.list == rhs.list
	}
}

extension ReverseList: Hashable where Element: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(ReverseList<Element>.self))
		hasher.combine(list)
	}
}
