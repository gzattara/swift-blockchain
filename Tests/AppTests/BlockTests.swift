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
        let timestamp = Date().timeIntervalSince1970
        let block = Block(timestamp: timestamp, hash: "hash", lastHash: "lasthash", data: Data(), nonce: 0, difficulty: 1)
        
        XCTAssertEqual(block.timestamp, timestamp)
        XCTAssertEqual(block.hash, "hash")
        XCTAssertEqual(block.difficulty, 1)
        XCTAssertEqual(block.nonce, 0)
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
        let hash = Block.generateHash(timestamp: 100000.0, lastHash: "test", data: Data(), nonce: 0, difficulty: 3)
        XCTAssertEqual(hash, "708cc61cbd5a8d2b05b69ce66a2379b26df2f5e4d367916f28b87a9e1ebfc0ee".lowercased())
    }

    func testMatchDifficultyCriteria() {
        let lastBlock = Block.genesis()
        let minedBlock = Block.mine(lastBlock: lastBlock, data: Data())
        let firstIndex = String.Index(utf16Offset: 0, in: minedBlock.hash)
        let lastIndex = String.Index(utf16Offset: minedBlock.difficulty - 1, in: minedBlock.hash)

        XCTAssertEqual(String(minedBlock.hash[firstIndex...lastIndex]), String.init(repeating: "0", count: minedBlock.difficulty))
    }

    func testRaiseDifficultyForQuicklyMinedBlock() {
        let lastBlock = Block.genesis()
        let minedBlock = Block.mine(lastBlock: lastBlock, data: Data())
        

        XCTAssertEqual(minedBlock.adjustDifficulty(block: minedBlock, timestamp: minedBlock.timestamp + Constants.instance.mineRate - 100), minedBlock.difficulty + 1)
    }

    func testlowerDifficultyForSlowlyMinedBlock() {
        let lastBlock = Block.genesis()
        let minedBlock = Block.mine(lastBlock: lastBlock, data: Data())

        XCTAssertEqual(minedBlock.adjustDifficulty(block: minedBlock, timestamp: minedBlock.timestamp + Constants.instance.mineRate + 100), minedBlock.difficulty - 1)
    }
}
