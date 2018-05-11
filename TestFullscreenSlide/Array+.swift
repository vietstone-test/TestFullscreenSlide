//
//  Array+.swift
//  TestFullscreenSlide
//
//  Created by Viet Nguyen Tran on 5/11/18.
//  Copyright © 2018 iossimple. All rights reserved.
//

import Foundation

extension Array {
    func circularPreviousIndex(of currentIndex: Int) -> Int {
        let validRange = 0..<self.count
        assert(validRange ~= currentIndex, "wrong currentIndex \(currentIndex) for range \(validRange)")
        var previousIndex = currentIndex - 1
        if previousIndex < 0 { previousIndex = self.count - 1 }
        return previousIndex
    }
    
    func circularNextIndex(of currentIndex: Int) -> Int {
        let validRange = 0..<self.count
        assert(validRange ~= currentIndex, "wrong currentIndex \(currentIndex) for range \(validRange)")
        let nextIndex = (currentIndex + 1) % self.count
        return nextIndex
    }
}
