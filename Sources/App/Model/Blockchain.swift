//
//  File.swift
//  
//
//  Created by Gonzalo Raul Zattara on 16/10/2020.
//

import Foundation

struct Blockchain {
    var chain: [Block]

    init() {
        self.chain = [Block.genesis()]
    }

    init(chain: [Block]) {
        self.chain = chain
    }

    mutating func addBlock(data: Data) {
        let newBlock = Block.mine(lastBlock: chain[chain.count - 1], data: data)
        self.chain.append(newBlock)
    }

    func validateChain() -> Bool {
        validateChain(chain: self.chain)
    }

    private func validateChain(chain: [Block]) -> Bool {
        if chain[0] != Block.genesis() {
            return false
        }

        var index = 0
        for block in chain.dropFirst() {
            let previousHash = chain[index].hash
            // Check lastHash is correct
            if block.lastHash != previousHash { return false }
            // Check the block hash
            if Block.generateHash(timestamp: block.timestamp, lastHash: block.lastHash, data: block.data, nonce: block.nonce, difficulty: block.difficulty) != block.hash { return false }
            index += 1
        }
        return true
    }

    mutating func replaceChain(chain: [Block]) {
        guard self.chain.count < chain.count, validateChain(chain: chain) else {
            return
        }
        self.chain = chain
    }
}
