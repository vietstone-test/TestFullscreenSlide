//
//  VerticalSlideViewController.swift
//  TestFullscreenSlide
//
//  Created by Viet Nguyen Tran on 5/11/18.
//  Copyright © 2018 iossimple. All rights reserved.
//

import UIKit

class VerticalSlideViewController: UIViewController {
    
    var promotionViews: [UIView] = [] {
        didSet {
            initSlideState()
        }
    }
    
    private var middleViewIndex: Int? {
        didSet {
            guard let index = middleViewIndex, index < promotionViews.count else {
                assert(false, "wrong logic for middleViewIndex")
            }
            middleFullscreenView.subviews.forEach { $0.removeFromSuperview() }
            placeView(promotionViews[index], on: middleFullscreenView)
            pageControl.currentPage = index
        }
    }
    
    @IBOutlet weak var middleViewTopConstraint: NSLayoutConstraint!
    
    private var aboveFullscreenView: UIView!
    @IBOutlet weak var middleFullscreenView: UIView!
    private var belowFullscreenView: UIView!
    
    private var pageControl: UIPageControl!
    
    private func configureUI() {
        aboveFullscreenView = UIView()
        self.view.addSubview(aboveFullscreenView)
        aboveFullscreenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aboveFullscreenView.widthAnchor.constraint(equalTo: middleFullscreenView.widthAnchor),
            aboveFullscreenView.heightAnchor.constraint(equalTo: middleFullscreenView.heightAnchor),
            aboveFullscreenView.leftAnchor.constraint(equalTo: middleFullscreenView.leftAnchor),
            aboveFullscreenView.bottomAnchor.constraint(equalTo: middleFullscreenView.topAnchor)
            ])
        
        belowFullscreenView = UIView()
        self.view.addSubview(belowFullscreenView)
        belowFullscreenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            belowFullscreenView.widthAnchor.constraint(equalTo: middleFullscreenView.widthAnchor),
            belowFullscreenView.heightAnchor.constraint(equalTo: middleFullscreenView.heightAnchor),
            belowFullscreenView.leftAnchor.constraint(equalTo: middleFullscreenView.leftAnchor),
            belowFullscreenView.topAnchor.constraint(equalTo: middleFullscreenView.bottomAnchor)
            ])
        
        self.view.backgroundColor = .clear
        self.aboveFullscreenView.backgroundColor = .clear
        self.middleFullscreenView.backgroundColor = .clear
        self.belowFullscreenView.backgroundColor = .clear
        
        pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.addTarget(self, action: #selector(onPageControlChanged(_:)), for: .valueChanged)
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            pageControl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 5)
            ])
        pageControl.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    
    private func configureGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    
    
    private func initSlideState() {
        guard isViewLoaded, promotionViews.count > 0 else {
            return
        }
        
        pageControl.numberOfPages = promotionViews.count
        middleViewIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureGesture()
        initSlideState()
        
        dummyData()
    }

    // MARK: - Utility
    
    private func placeView(_ view: UIView, on belowView: UIView) {
        belowView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: belowView.topAnchor),
            view.leftAnchor.constraint(equalTo: belowView.leftAnchor),
            view.bottomAnchor.constraint(equalTo: belowView.bottomAnchor),
            view.rightAnchor.constraint(equalTo: belowView.rightAnchor)
            ])
    }
    
    private func dummyData() {
        //        let yellowView = UIView()
        //        yellowView.backgroundColor = .yellow
        //        let redView = UIView()
        //        redView.backgroundColor = UIColor(red: 230.0/255.0, green: 57.0/255.0, blue: 98.0/255.0, alpha: 1)
        //        let cyanView = UIView()
        //        cyanView.backgroundColor = .cyan
        //
        //        self.promotionViews = [yellowView, redView, cyanView]
        
        let sydney = PromotionView.instance(with: DummyPromotionViewModel.instanceSydney())
        let diepson = PromotionView.instance(with: DummyPromotionViewModel.instanceDiepson())
        let singapore = PromotionView.instance(with: DummyPromotionViewModel.instanceSingapore())
        
        self.promotionViews = [sydney, diepson, singapore]
    }
    
    // MARK: - User interaction handling
    
    @objc private func handlePanGesture(_ pan: UIPanGestureRecognizer) {
        guard promotionViews.count > 1, let middleViewIndex = middleViewIndex else {
            return
        }
        
        let translation = pan.translation(in: self.view)
        middleViewTopConstraint.constant = translation.y
        
        if pan.state == .began {
            let velocity = pan.velocity(in: self.view)
            print(velocity.y)
            if velocity.y > 0 { // slide down
                print("=== began down")
                let previousIndex = promotionViews.circularPreviousIndex(of: middleViewIndex)
                placeView(promotionViews[previousIndex], on: aboveFullscreenView)
            } else { // slide up
                print("=== began up")
                let nextIndex = promotionViews.circularNextIndex(of: middleViewIndex)
                placeView(promotionViews[nextIndex], on: belowFullscreenView)
            }
        }
        else if pan.state == .cancelled {
            moveMiddleView(y: 0, duration: 0.3) // reset
        } else if pan.state == .ended {
            if translation.y > 50 { // move down then reset
                let yToMove = middleFullscreenView.frame.size.height
                moveMiddleView(y: yToMove, duration: 0.4) {
                    let previousIndex = self.promotionViews.circularPreviousIndex(of: middleViewIndex)
                    self.middleViewIndex = previousIndex
                    self.moveMiddleView(y: 0, duration: 0) // reset
                }
            } else if translation.y < -50 { // move up then reset
                let yToMove = 0 - middleFullscreenView.frame.size.height
                moveMiddleView(y: yToMove, duration: 0.4) {
                    let nextIndex = self.promotionViews.circularNextIndex(of: middleViewIndex)
                    self.middleViewIndex = nextIndex
                    self.moveMiddleView(y: 0, duration: 0) // reset
                }
            } else {
                moveMiddleView(y: 0, duration: 0.3) // reset
            }
        }
    }
    
    private func moveMiddleView(y: CGFloat, duration: TimeInterval, completion: (()-> Void)? = nil) {
        middleViewTopConstraint.constant = y
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            completion?()
        }
    }
    
    @objc private func onPageControlChanged(_ pageControl: UIPageControl) {
        middleViewIndex = pageControl.currentPage
    }
    
}

