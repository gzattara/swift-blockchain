//
//  File.swift
//  
//
//  Created by Gonzalo Raul Zattara on 15/10/2020.
//

@testable import App
import XCTVapor

final class BlockTests: XCTestCase {

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

    func testBlock() {
        let block = Block(timestamp: "test", hash: "hash", lastHash: "lasthash", data: Data(), nonce: "", difficulty: 1)
        
        XCTAssertEqual(block.timestamp, "test")
        XCTAssertEqual(block.hash, "hash")
    }

    func testtGenesysBlock() {
        let genesisBlock = Block.genesis()
        XCTAssertEqual(genesisBlock.hash, "----")
    }

    func testMineBlock() {
        let lastBlock = Block.genesis()
        let minedBlock = Block.mine(lastBlock: lastBlock, data: Data())
        XCTAssertEqual(minedBlock.lastHash, lastBlock.hash)
    }

    func testHashGeneration() {
        let hash = Block.generateHash(timestamp: "", lastHash: "test", data: Data(), nonce: "", difficulty: 1)
        XCTAssertEqual(hash, "9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08".lowercased())
    }

    func testMatchDifficultyCriteria() {
        let lastBlock = Block.genesis()
        let minedBlock = Block.mine(lastBlock: lastBlock, data: Data())
        let firstIndex = String.Index(utf16Offset: 0, in: minedBlock.hash)
        let lastIndex = String.Index(utf16Offset: minedBlock.difficulty - 1, in: minedBlock.hash)

        XCTAssertEqual(String(minedBlock.hash[firstIndex...lastIndex]), String.init(repeating: "0", count: minedBlock.difficulty))
    }
}
