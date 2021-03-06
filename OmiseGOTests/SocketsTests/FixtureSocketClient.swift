//
//  FixtureSocketClient.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 23/3/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import Starscream

class FixtureWebsocketClient: WebSocketClient {

    var delegate: WebSocketDelegate?
    var disableSSLCertValidation: Bool = true
    var overrideTrustHostname: Bool = false
    var desiredTrustHostname: String?
    var security: SSLTrustValidator?
    var enabledSSLCipherSuites: [SSLCipherSuite]?
    var isConnected: Bool = false

    var didWriteString: String?
    var didWriteData: Data?

    var shouldAutoConnect = true

    func connect() {
        self.isConnected = self.shouldAutoConnect
    }

    func disconnect(forceTimeout: TimeInterval?, closeCode: UInt16) {
        self.isConnected = false
    }

    func write(string: String, completion: (() -> Void)?) {
        self.didWriteString = string
        completion?()
    }

    func write(data: Data, completion: (() -> Void)?) {
        self.didWriteData = data
        completion?()
        (self.delegate as? DummyWebSocketDelegate)?.websocketDidSendData(socket: self, data: data)
    }

    func write(ping: Data, completion: (() -> Void)?) {
        completion?()
    }

    func write(pong: Data, completion: (() -> Void)?) {
        completion?()
    }

    func simulateReply() {
        let data = StubGenerator.fileContent(forResource: "socket_response_reply")
        self.delegate?.websocketDidReceiveMessage(socket: self, text: String(data: data, encoding: .utf8)!)
    }

}
