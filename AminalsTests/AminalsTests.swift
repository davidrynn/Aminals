//
//  AminalsTests.swift
//  AminalsTests
//
//  Created by David Rynn on 9/8/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import XCTest
@testable import Aminals

class AminalsTests: XCTestCase {
  var sut: AnimalResponseData!

    override func setUpWithError() throws {
      super.setUp()
      let data = try getDataFromJSON("TestJson")
      let decoder = JSONDecoder()
      sut = try decoder.decode(AnimalResponseData.self, from: data)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
      print( sut.data.first!)
      print()
    }

}

extension XCTestCase {
  enum TestError: Error {
    case fileNotFound
  }

  func getDataFromJSON(_ fileName: String) throws -> Data {
    let bundle = Bundle(for: type(of: self))
    guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
      XCTFail("Missing File: \(fileName).json")
      throw TestError.fileNotFound
    }
    do {
      let data = try Data(contentsOf: url)
      return data
    } catch {
      throw error
    }
  }
}
