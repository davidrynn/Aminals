//
//  DataSourceTest.swift
//  AminalsTests
//
//  Created by David Rynn on 11/2/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import XCTest
@testable import Aminals

class DataSourceTest: XCTestCase {
    var sut: DataSource!
    override func setUpWithError() throws {
        sut = DataSource()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testTypeDidChange_toCat() throws {
        // given
        let newType = AnimalType.cats

        // when
        sut.typeDidChange(selection: newType)

        // then

    }

}
