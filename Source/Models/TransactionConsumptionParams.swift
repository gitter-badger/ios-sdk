//
//  TransactionConsumptionParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to consume a transaction request
public struct TransactionConsumptionParams {

    /// The formatted id of the transaction request to be consumed
    public let formattedTransactionRequestId: String
    /// The amount of token to transfer (down to subunit to unit)
    public let amount: Double?
    /// The address to use for the consumption
    public let address: String?
    /// The id of the token to use for the request
    /// In the case of a type "send", this will be the token that the consumer will receive
    /// In the case of a type "receive" this will be the token that the consumer will send
    public let tokenId: String?
    /// The idempotency token to use for the consumption
    public let idempotencyToken: String
    /// An id that can uniquely identify a transaction. Typically an order id from a provider.
    public let correlationId: String?
    /// Additional metadata for the consumption
    public let metadata: [String: Any]
    /// Additional encrypted metadata for the consumption
    public let encryptedMetadata: [String: Any]

    /// Initialize the params used to consume a transaction request
    /// Returns nil if the amount is nil and was not specified in the transaction request
    ///
    /// - Parameters:
    ///   - transactionRequest: The transaction request to consume
    ///   - address: The address to use for the consumption
    ///   - tokenId: The id of the token to use for the request
    ///              In the case of a type "send", this will be the token that the consumer will receive
    ///              In the case of a type "receive" this will be the token that the consumer will send
    ///   - amount: The amount of token to transfer (down to subunit to unit)
    ///   - idempotencyToken: The idempotency token to use for the consumption
    ///   - correlationId: An id that can uniquely identify a transaction. Typically an order id from a provider.
    ///   - metadata: Additional metadata for the consumption
    public init?(transactionRequest: TransactionRequest,
                 address: String? = nil,
                 tokenId: String? = nil,
                 amount: Double?,
                 idempotencyToken: String,
                 correlationId: String? = nil,
                 metadata: [String: Any] = [:],
                 encryptedMetadata: [String: Any] = [:]) {
        guard transactionRequest.amount != nil || amount != nil else { return nil }
        self.formattedTransactionRequestId = transactionRequest.formattedId
        self.amount = amount == transactionRequest.amount ? nil : amount
        self.address = address
        self.tokenId = tokenId
        self.idempotencyToken = idempotencyToken
        self.correlationId = correlationId
        self.metadata = metadata
        self.encryptedMetadata = encryptedMetadata
    }

}

extension TransactionConsumptionParams: APIParameters {
    public func getIdempotencyToken() -> String? {
        return self.idempotencyToken
    }
}

extension TransactionConsumptionParams {

    private enum CodingKeys: String, CodingKey {
        case formattedTransactionRequestId = "formatted_transaction_request_id"
        case amount
        case address
        case tokenId = "token_id"
        case metadata
        case encryptedMetadata = "encrypted_metadata"
        case correlationId = "correlation_id"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(formattedTransactionRequestId, forKey: .formattedTransactionRequestId)
        try container.encode(amount, forKey: .amount)
        try container.encode(address, forKey: .address)
        try container.encode(tokenId, forKey: .tokenId)
        try container.encode(metadata, forKey: .metadata)
        try container.encode(encryptedMetadata, forKey: .encryptedMetadata)
        try container.encode(correlationId, forKey: .correlationId)
    }

}

/// Represents a structure used to confirm a transaction consumption from its id
struct TransactionConsumptionConfirmationParams: APIParameters {

    let id: String

}
