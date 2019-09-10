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

import XCTest
@testable import CharonCollection

final class ListTests: XCTestCase {
	func testAppendElement() {
		var a: List<Int> = [2, 3]
		let b: List<Int> = [2, 3, 5]
		a.append(5)
		XCTAssertEqual(a, b)
	}

	func testAppendList() {
		var a: List<Int> = [2]
		let b: List<Int> = [2, 3, 5]
		a.append(List([3, 5]))
		XCTAssertEqual(a, b)
	}

	func testAppendSequence() {
		var a: List<Int> = [2]
		let b: List<Int> = [2, 3, 5]
		a.append([3, 5])
		XCTAssertEqual(a, b)
	}

	func testPlus() {
		let a: List<Int> = [2, 3]
		let b: List<Int> = [2, 3, 5]
		XCTAssertEqual(a + List(5, nil), b)
	}

	func testRemove() {
		var a: List<Int> = [2, 3, 5, 7, 11]
		a.removeFirst()
		XCTAssertEqual(a, [3, 5, 7, 11])
		a.removeLast()
		XCTAssertEqual(a, [3, 5, 7])
		a.removeAll { $0 == 5 }
		XCTAssertEqual(a, [3, 7])
		a.removeAll()
		XCTAssertEqual(a, [])
	}

	func testCount() {
		let a: List<Int> = [2, 3, 5, 7, 11]
		XCTAssertEqual(a.count, 5)
	}

	func testContains() {
		let a: List<String> = ["foo", "bar", "baz"]
		XCTAssert(a.contains("bar"))
	}

	func testEquality() {
		let a: List<String> = ["foo", "bar", "baz"]
		let b: List<String> = List("foo", List("bar", List("baz", nil)))
		XCTAssertEqual(a, b)
	}

	func testHashing() {
		let a: List<String> = ["foo", "bar", "baz"]
		let b: List<String> = List("foo", List("bar", List("baz", nil)))
		XCTAssertEqual(a.hashValue, b.hashValue)

		XCTAssertNotEqual("foo".hashValue, List("foo", nil).hashValue)
	}

	func testIterating() {
		let a = [2, 3, 5]
		let l = List<Int>(a)
		for (i, element) in l.enumerated() {
			XCTAssertEqual(element, a[i])
		}
	}

	func testDescribing() {
		let a: List<Int> = [2, 3, 5]

		XCTAssertEqual(String(describing: a), "[2, 3, 5]")
		XCTAssertEqual(String(reflecting: a), "List([2, 3, 5])")
	}

	func testNilExpression() {
		let a: List<Int> = nil
		XCTAssertEqual(a, .empty)
	}

	func testEncoding() {
		let encoder = JSONEncoder()
		let a: List<Int> = [2, 3, 5]
		let json = try! encoder.encode(a)
		XCTAssertEqual(String(bytes: json, encoding: .utf8)!, "[2,3,5]")
	}

	func testDecoding() {
		let decoder = JSONDecoder()
		let json = "[2, 3, 5]".data(using: .utf8)!
		let a = try! decoder.decode(List<Int>.self, from: json)
		XCTAssertEqual(a, List([2, 3, 5]))
	}

	static var allTests = [
		("testAppendElement", testAppendElement),
		("testAppendList", testAppendList),
		("testAppendSequence", testAppendSequence),
		("testPlus", testPlus),
		("testRemove", testRemove),
		("testContains", testContains),
		("testEquality", testEquality),
		("testHashing", testHashing),
		("testIterating", testIterating),
		("testDescribing", testDescribing),
		("testNilExpression", testNilExpression),
		("testEncoding", testEncoding),
		("testDecoding", testDecoding)
	]
}
