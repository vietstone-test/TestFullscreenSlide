//
//  PromotionView.swift
//  TestFullscreenSlide
//
//  Created by Viet Nguyen Tran on 5/13/18.
//  Copyright © 2018 iossimple. All rights reserved.
//

import UIKit

typealias PromotionPrice = (unit: Int, currency: String)

protocol PromotionViewModel {
    var fromLocation: String { get }
    var toLocation: String { get }
    var description: String { get }
    var imageName: String { get }
    var price: PromotionPrice { get }
    func doBookingAction()
}

class PromotionView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var toLocationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceUnitLabel: UILabel!
    @IBOutlet weak var priceFromLabel: UILabel!
    @IBOutlet weak var priceCurrencyLabel: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    
    @IBAction func pressBook(_ sender: Any) {
        viewModel.doBookingAction()
    }
    
    private var viewModel: PromotionViewModel! {
        didSet {
            guard viewModel != nil else {
                return
            }
            imageView.image = UIImage(named: viewModel.imageName)
            fromLocationLabel.text = "Departing from \(viewModel.fromLocation) to"
            toLocationLabel.text = viewModel.toLocation
            descriptionLabel.text = viewModel.description
            priceUnitLabel.text = "\(viewModel.price.unit)"
            priceCurrencyLabel.text = viewModel.price.currency
        }
    }

    static func instance(with viewModel: PromotionViewModel) -> PromotionView {
        guard let promotionView = Bundle.main.loadNibNamed("PromotionView", owner: nil, options: nil)?.first as? PromotionView else {
            assert(false, "Wrong setting up nib file for PromotionView")
        }
        promotionView.viewModel = viewModel
        return promotionView
    }
}
