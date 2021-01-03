//
//  File.swift
//  
//
//  Created by Gonzalo Raul Zattara on 16/10/2020.
//

@testable import App
import XCTVapor

final class BlockchainTests: XCTestCase {

    override func setUp() {
        do {
            try setupTests()
        } catch {
            assertionFailure()
            return
        }
    }

    func setupTests() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
    }

    func testBlockchain() {
        let blockchain = Blockchain()
        XCTAssertNotNil(blockchain)
        XCTAssertEqual(blockchain.chain[0].hash, "----")
    }

    func testAddBlock() {
        var blockchain = Blockchain()

        let newData = "second block".data(using: .utf8)
        blockchain.addBlock(data: newData ?? Data())
        XCTAssertEqual(blockchain.chain[blockchain.chain.count - 1].data, newData)
    }

    func testValidChainWithNoGenesisBlock() throws {
        let block = Block(timestamp: Date().timeIntervalSince1970, hash: "test", lastHash: "test", data: Data(), nonce: 0, difficulty: 1)
        let blockchain = Blockchain(chain: [block])
        XCTAssertFalse(blockchain.validateChain())
    }

    func testLastHashReferenceChanged() {
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
        let changedBlock = Block(timestamp: lastBlock.timestamp, hash: lastBlock.hash, lastHash: "broken", data: lastBlock.data, nonce: 0, difficulty: 1)
        // Change the block in the chain
        blockchain.chain[2] = changedBlock
        // Validate
        XCTAssertFalse(blockchain.validateChain())
    }

    func testBlockchainWithInvalidBlock() {
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
        let changedBlock = Block(timestamp: lastBlock.timestamp, hash: lastBlock.hash, lastHash: lastBlock.lastHash, data: "broken".data(using: .utf8) ?? Data(), nonce: 0, difficulty: 1)
        // Change the block in the chain
        blockchain.chain[2] = changedBlock
        // Validate
        XCTAssertFalse(blockchain.validateChain())
    }

    func testValidBlockchain() {
        var blockchain = Blockchain()
        let newData = "second block".data(using: .utf8)
        blockchain.addBlock(data: newData ?? Data())
        let newData2 = "third block".data(using: .utf8)
        blockchain.addBlock(data: newData2 ?? Data())
        XCTAssertTrue(blockchain.validateChain())
    }

}
