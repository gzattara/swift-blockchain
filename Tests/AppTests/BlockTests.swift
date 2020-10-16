//
//  File.swift
//  
//
//  Created by Gonzalo Raul Zattara on 15/10/2020.
//

@testable import App
import XCTVapor

final class BlockTests: XCTestCase {

    func testBlock() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let block = Block(timestamp: "test", hash: "hash", lastHash: "lasthash", data: Data())
        
        XCTAssertEqual(block.timestamp, "test")
        XCTAssertEqual(block.hash, "hash")
    }

    func testtGenesysBlock() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let genesisBlock = Block.genesis()
        XCTAssertEqual(genesisBlock.hash, "----")
    }

    func testMineBlock() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let lastBlock = Block.genesis()
        let minedBlock = Block.mine(lastBlock: lastBlock, data: Data())
        XCTAssertEqual(minedBlock.lastHash, lastBlock.hash)
    }

    func testHashGeneration() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let hash = Block.generateHash(timestamp: "", lastHash: "test", data: Data())
        XCTAssertEqual(hash, "9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08".lowercased())
    }
}
