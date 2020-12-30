//
//  File.swift
//  
//
//  Created by Gonzalo Raul Zattara on 25/10/2020.
//

import Foundation
@testable import App
import XCTVapor

class BlockchainReplacementTests: XCTestCase {
    
    var blockchain: Blockchain!
    var originalChain: [Block]!
    var newChain: Blockchain!

    override func setUp() {
        do {
            try setupTests()
        } catch {
            assertionFailure()
            return
        }
        blockchain = Blockchain()
        originalChain = blockchain.chain
        newChain = Blockchain()
    }

    func setupTests() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
    }

    func testDoNotReplaceChainWhenNewChainIsNotLonger() {
        blockchain.replaceChain(chain: newChain.chain)
        XCTAssertEqual(blockchain.chain, originalChain)
    }

    func testLongerAndInvalidChain() {
        let newData = "second block".data(using: .utf8)
        newChain.addBlock(data: newData ?? Data())
        guard let lastBlock = newChain.chain.last else {
            assertionFailure()
            return
        }
        let changedBlock = Block(timestamp: lastBlock.timestamp, hash: lastBlock.hash, lastHash: "broken", data: lastBlock.data, nonce: 0, difficulty: 1)
        // Change the block in the chain
        newChain.chain[1] = changedBlock

        //Call the replace function
        blockchain.replaceChain(chain: newChain.chain)
        XCTAssertEqual(blockchain.chain, originalChain)
    }

    func testLongerAndValidChain() {
        let newData = "second block".data(using: .utf8)
        newChain.addBlock(data: newData ?? Data())

        //Call the replace function
        blockchain.replaceChain(chain: newChain.chain)
        XCTAssertEqual(blockchain.chain, newChain.chain)
    }
}
