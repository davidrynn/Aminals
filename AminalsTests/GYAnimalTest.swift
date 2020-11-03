//
//  GYAnimalTest.swift
//  AminalsTests
//
//  Created by David Rynn on 11/2/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import XCTest
@testable import Aminals

class GYAnimalTest: XCTestCase {
    var sut: GYAnimalResponseData!

    override func setUpWithError() throws {
        super.setUp()
        let data = try getDataFromJSON("TestJson")
        let decoder = JSONDecoder()
        sut = try decoder.decode(GYAnimalResponseData.self, from: data)
    }

    func testData_AnimalShouldExist() throws {
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

