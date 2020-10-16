//
//  File.swift
//  
//
//  Created by Gonzalo Raul Zattara on 16/10/2020.
//

@testable import App
import XCTVapor

final class BlockchainTests: XCTestCase {

    func testBlockchain() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let blockchain = Blockchain()
        XCTAssertNotNil(blockchain)
        XCTAssertEqual(blockchain.chain[0].hash, "----")
    }

    func testAddBlock() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var blockchain = Blockchain()

        let newData = "second block".data(using: .utf8)
        blockchain.addBlock(data: newData ?? Data())
        XCTAssertEqual(blockchain.chain[blockchain.chain.count - 1].data, newData)
    }

    func testValidChainWithNoGenesisBlock() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let block = Block(timestamp: "test", hash: "test", lastHash: "test", data: Data())
        let blockchain = Blockchain(chain: [block])
        XCTAssertFalse(blockchain.validateChain())
    }

    func testLastHashReferenceChanged() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var blockchain = Blockchain()
        let newData = "second block".data(using: .utf8)
        blockchain.addBlock(data: newData ?? Data())
        let newData2 = "third block".data(using: .utf8)
        blockchain.addBlock(data: newData2 ?? Data())

        // Lets create a new block
        guard let lastBlock = blockchain.chain.last else {
            assertionFailure()
            return
        }
        let changedBlock = Block(timestamp: lastBlock.timestamp, hash: lastBlock.hash, lastHash: "broken", data: lastBlock.data)
        // Change the block in the chain
        blockchain.chain[2] = changedBlock
        // Validate
        XCTAssertFalse(blockchain.validateChain())
    }

    func testBlockchainWithInvalidBlock() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var blockchain = Blockchain()
        let newData = "second block".data(using: .utf8)
        blockchain.addBlock(data: newData ?? Data())
        let newData2 = "third block".data(using: .utf8)
        blockchain.addBlock(data: newData2 ?? Data())
        // Lets create a new block
        guard let lastBlock = blockchain.chain.last else {
            assertionFailure()
            return
        }
        let changedBlock = Block(timestamp: lastBlock.timestamp, hash: lastBlock.hash, lastHash: lastBlock.lastHash, data: "broken".data(using: .utf8) ?? Data())
        // Change the block in the chain
        blockchain.chain[2] = changedBlock
        // Validate
        XCTAssertFalse(blockchain.validateChain())
    }

    func testValidBlockchain() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var blockchain = Blockchain()
        let newData = "second block".data(using: .utf8)
        blockchain.addBlock(data: newData ?? Data())
        let newData2 = "third block".data(using: .utf8)
        blockchain.addBlock(data: newData2 ?? Data())
        XCTAssertTrue(blockchain.validateChain())
    }
}
