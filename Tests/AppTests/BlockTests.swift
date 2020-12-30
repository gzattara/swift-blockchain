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
        let block = Block(timestamp: "test", hash: "hash", lastHash: "lasthash", data: Data(), nonce: 0, difficulty: 1)
        
        XCTAssertEqual(block.timestamp, "test")
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
        let hash = Block.generateHash(timestamp: "", lastHash: "test", data: Data(), nonce: 0, difficulty: 3)
        XCTAssertEqual(hash, "87386d7d648dfbad544f3066446a091098d61d12760ef7787f41328abdc10709".lowercased())
    }

    func testMatchDifficultyCriteria() {
        let lastBlock = Block.genesis()
        let minedBlock = Block.mine(lastBlock: lastBlock, data: Data())
        let firstIndex = String.Index(utf16Offset: 0, in: minedBlock.hash)
        let lastIndex = String.Index(utf16Offset: minedBlock.difficulty - 1, in: minedBlock.hash)

        XCTAssertEqual(String(minedBlock.hash[firstIndex...lastIndex]), String.init(repeating: "0", count: minedBlock.difficulty))
    }
}
