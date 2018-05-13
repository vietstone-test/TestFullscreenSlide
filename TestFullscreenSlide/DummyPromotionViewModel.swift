//
//  DummyPromotionViewModel.swift
//  TestFullscreenSlide
//
//  Created by Viet Nguyen Tran on 5/13/18.
//  Copyright © 2018 iossimple. All rights reserved.
//

import Foundation

class DummyPromotionViewModel {
    var from: String?
    var to: String?
    var des: String?
    var imgName: String?
    
    static func instanceSydney() -> DummyPromotionViewModel {
        let mySelf = DummyPromotionViewModel()
        mySelf.from = "Hanoi"
        mySelf.to = "Sydney"
        mySelf.des = "Lorem ipsum dolor sit amet, adipiscing elit. Aliquam eget rutrum elit. Morbi convallis felis tortor…"
        mySelf.imgName = "sydney.jpg"
        return mySelf
    }
    static func instanceDiepson() -> DummyPromotionViewModel {
        let mySelf = DummyPromotionViewModel()
        mySelf.from = "Hanoi"
        mySelf.to = "Diep Son"
        mySelf.des = "Lorem ipsum dolor sit amet, adipiscing elit. Aliquam eget rutrum elit. Morbi convallis felis tortor…"
        mySelf.imgName = "diepson.jpg"
        return mySelf
    }
    static func instanceSingapore() -> DummyPromotionViewModel {
        let mySelf = DummyPromotionViewModel()
        mySelf.from = "Hanoi"
        mySelf.to = "Singapore"
        mySelf.des = "Lorem ipsum dolor sit amet, adipiscing elit. Aliquam eget rutrum elit. Morbi convallis felis tortor…"
        mySelf.imgName = "singapore.jpg"
        return mySelf
    }
}

extension DummyPromotionViewModel: PromotionViewModel {
    
    var fromLocation: String { return from ?? "" }
    var toLocation: String { return to ?? "" }
    var description: String { return des ?? "" }
    var imageName: String { return imgName ?? "" }
    var price: PromotionPrice { return PromotionPrice(199, "USD") }
    
    func doBookingAction() {
        print("Booking")
    }
    
    
}
