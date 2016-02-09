//
//  MutableCollectionType+Extensions.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 9/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Foundation

extension MutableCollectionType where Index == Int {
    
    mutating func shuffleInPlace() {
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + 1
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
    
}