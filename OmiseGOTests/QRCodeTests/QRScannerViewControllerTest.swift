//
//  QRScannerViewControllerTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class QRScannerViewControllerTest: FixtureTestCase {

    var mockDelegate: MockQRVCDelegate!
    var mockViewModel: MockQRViewModel!
    var sut: QRScannerViewController!

    override func setUp() {
        self.mockDelegate = MockQRVCDelegate()
        self.mockViewModel = MockQRViewModel()
        self.sut = QRScannerViewController(delegate: self.mockDelegate,
                                            client: self.testClient,
                                            cancelButtonTitle: "",
                                            viewModel: self.mockViewModel)!
    }

    func testFailsWhenNotInitializedWithDesignedInit() {
        XCTAssertNil(QRScannerViewController(coder: NSCoder()))
    }

    func testFailsToInitIfQRCodeNotAvailable() {
        let vc = QRScannerViewController(delegate: self.mockDelegate,
                                         client: self.testClient,
                                         cancelButtonTitle: "")
        XCTAssertNil(vc)
    }

    func testShowLoadingViewWhenLoading() {
        self.mockViewModel.onLoadingStateChange?(true)
        XCTAssert(self.sut.loadingView.loadingSpinner.isAnimating)
    }

    func testHideLoadingViewWhenLoading() {
        self.mockViewModel.onLoadingStateChange?(true)
        XCTAssert(self.sut.loadingView.loadingSpinner.isAnimating)
        self.mockViewModel.onLoadingStateChange?(false)
        XCTAssert(!self.sut.loadingView.loadingSpinner.isAnimating)
    }

    func testCallsDelegateWithTransactionRequest() {
        let mockedTR = StubGenerator.transactionRequest()
        self.mockViewModel.onGetTransactionRequest?(mockedTR)
        XCTAssertEqual(self.mockDelegate.transactionRequest, mockedTR)
    }

    func testCallsDelegateWithError() {
        let error = OMGError.unexpected(message: "Test")
        self.mockViewModel.onError?(error)
        XCTAssertNotNil(self.mockDelegate.error)
    }

    func testViewWillAppear() {
        XCTAssertFalse(self.mockViewModel.didStartScanning)
        self.sut.viewWillAppear(true)
        XCTAssertTrue(self.mockViewModel.didStartScanning)
    }

    func testViewWillDisAppear() {
        XCTAssertFalse(self.mockViewModel.didStopScanning)
        self.sut.viewWillDisappear(true)
        XCTAssertTrue(self.mockViewModel.didStopScanning)
    }

    func testTapCancel() {
        self.sut.didTapCancel(UIButton())
        XCTAssertTrue(self.mockDelegate.didCancel)
    }

    func testSupportedInterfaceOrientations() {
        XCTAssertEqual(self.sut.supportedInterfaceOrientations, .portrait)
    }

    func testViewWillLayoutSubviews() {
        self.sut.viewWillLayoutSubviews()
        XCTAssertTrue(self.mockViewModel.didUpdateQRReaderPreviewLayer)
    }

}
