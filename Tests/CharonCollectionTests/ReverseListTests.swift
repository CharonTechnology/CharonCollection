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

final class ReverseListTests: XCTestCase {
	func testInternalRepresentation() {
		let a: ReverseList<String> = ["foo", "bar", "baz"]
		let b: List<String> = ["baz", "bar", "foo"]
		XCTAssertEqual(a.list, b)
	}

	func testAppend() {
		var l: ReverseList<Int> = [2, 3]
		l.append(5)
		XCTAssertEqual(Array(l), [2, 3, 5])
	}

	func testEquality() {
		let a: ReverseList<String> = ["foo", "bar", "baz"]
		let b: ReverseList<String> = ["foo", "bar", "baz"]
		XCTAssertEqual(a, b)
	}

	func testHashing() {
		let a: ReverseList<String> = ["foo", "bar", "baz"]
		let b: ReverseList<String> = ["foo", "bar", "baz"]
		XCTAssertEqual(a.hashValue, b.hashValue)

		XCTAssertNotEqual("foo".hashValue, ReverseList(["foo"]).hashValue)
		XCTAssertNotEqual(List("foo", nil).hashValue, ReverseList(["foo"]).hashValue)
	}

	func testIterating() {
		let a = [2, 3, 5]
		let l = ReverseList<Int>(a)
		for (i, element) in l.enumerated() {
			XCTAssertEqual(element, a[i])
		}
	}

	func testDescribing() {
		let a: ReverseList<Int> = [2, 3, 5]

		XCTAssertEqual(String(describing: a), "[2, 3, 5]")
		XCTAssertEqual(String(reflecting: a), "ReverseList([2, 3, 5])")
	}

	func testNilExpression() {
		let a: ReverseList<Int> = nil
		XCTAssertEqual(a, ReverseList<Int>())
	}

	func testEncoding() {
		let encoder = JSONEncoder()
		let a: ReverseList<Int> = [2, 3, 5]
		let json = try! encoder.encode(a)
		XCTAssertEqual(String(bytes: json, encoding: .utf8)!, "[2,3,5]")
	}

	func testDecoding() {
		let decoder = JSONDecoder()
		let json = "[2, 3, 5]".data(using: .utf8)!
		let a = try! decoder.decode(ReverseList<Int>.self, from: json)
		XCTAssertEqual(a, ReverseList([2, 3, 5]))
	}

	static var allTests = [
		("testInternalRepresentation", testInternalRepresentation),
		("testAppend", testAppend),
		("testEquality", testEquality),
		("testHashing", testHashing),
		("testIterating", testIterating),
		("testDescribing", testDescribing),
		("testNilExpression", testNilExpression),
		("testEncoding", testEncoding),
		("testDecoding", testDecoding)
	]
}
