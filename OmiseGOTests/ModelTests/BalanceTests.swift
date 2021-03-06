//
//  BalanceTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
import OmiseGO

class BalanceTests: XCTestCase {

    let decimalSeparator = NSLocale.current.decimalSeparator ?? "."
    let groupingSeparator = NSLocale.current.groupingSeparator ?? ","

    func testStandardDisplayAmount() {
        let token = StubGenerator.token(subUnitToUnit: 1000)
        let balance = StubGenerator.balance(token: token, amount: 13)
        XCTAssertEqual(balance.displayAmount(), "0\(decimalSeparator)013")
    }

    func testZeroDisplayAmount() {
        let token = StubGenerator.token(subUnitToUnit: 1000)
        let balance = StubGenerator.balance(token: token, amount: 0)
        XCTAssertEqual(balance.displayAmount(), "0")
    }

    func testBigDisplayAmount() {
        let token = StubGenerator.token(subUnitToUnit: 1000)
        let balance = StubGenerator.balance(token: token, amount: 999999999999999)
        XCTAssertEqual(balance.displayAmount(),
                       "999\(groupingSeparator)999\(groupingSeparator)999\(groupingSeparator)999\(decimalSeparator)999")
    }

    func testBigDisplayAmountPrecision() {
        let token = StubGenerator.token(subUnitToUnit: 1000)
        let balance = StubGenerator.balance(token: token, amount: 999999999999999)
        XCTAssertEqual(balance.displayAmount(withPrecision: 1),
                       "1\(groupingSeparator)000\(groupingSeparator)000\(groupingSeparator)000\(groupingSeparator)000")
    }

    func testBigDisplayAmountWithBigSubUnitToUnity() {
        let token = StubGenerator.token(subUnitToUnit: 1000000000000000000)
        let balance = StubGenerator.balance(token: token, amount: 130000000000000000000)
        XCTAssertEqual(balance.displayAmount(), "130")
    }

    func testSmallestDisplayAmount() {
        let token = StubGenerator.token(subUnitToUnit: 1000000000000000000)
        let balance = StubGenerator.balance(token: token, amount: 1)
        XCTAssertEqual(balance.displayAmount(), "0\(decimalSeparator)000000000000000001")
    }

    func testSmallNumberPrecision() {
        let token = StubGenerator.token(subUnitToUnit: 1000000000000000000)
        let balance = StubGenerator.balance(token: token, amount: 1)
        XCTAssertEqual(balance.displayAmount(withPrecision: 2), "0")
    }

    func testEquatable() {
        let token1 = StubGenerator.token(id: "OMG:123", subUnitToUnit: 1)
        let token2 = StubGenerator.token(id: "BTC:123", subUnitToUnit: 1)
        let balance1 = StubGenerator.balance(token: token1, amount: 1)
        let balance2 = StubGenerator.balance(token: token1, amount: 1)
        let balance3 = StubGenerator.balance(token: token1, amount: 10)
        let balance4 = StubGenerator.balance(token: token2, amount: 10)
        XCTAssertEqual(balance1, balance2)
        XCTAssertNotEqual(balance1, balance3)
        XCTAssertNotEqual(balance1, balance4)
        XCTAssertNotEqual(balance3, balance4)
    }

    func testHashable() {
        let token1 = StubGenerator.token(id: "OMG", subUnitToUnit: 1)
        let token2 = StubGenerator.token(id: "BTC", subUnitToUnit: 1)
        let balance1 = StubGenerator.balance(token: token1, amount: 1)
        let balance2 = StubGenerator.balance(token: token1, amount: 1)
        let balance3 = StubGenerator.balance(token: token1, amount: 10)
        let balance4 = StubGenerator.balance(token: token2, amount: 10)
        let set: Set<Balance> = [balance1, balance2, balance3, balance4]
        XCTAssertEqual(balance1.hashValue, token1.hashValue ^ 1.0.hashValue)
        XCTAssertEqual(set.count, 3)
    }

}
