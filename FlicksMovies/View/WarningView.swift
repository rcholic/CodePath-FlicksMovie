//
//  WarningView.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 4/1/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit

class WarningView: UIView {
    
    // TODO: add a close button to dismiss self
    
    public var infoText: String = "" {
        didSet {
            self.label.text = infoText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initPhase2()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPhase2()
    }
    
    convenience init(info: String, frame: CGRect) {
        self.init(frame: frame)
        self.infoText = info
        label.text = self.infoText
    }
    
    private func initPhase2() {
        self.backgroundColor = CELL_SEPARATOR_COLOR.withAlphaComponent(0.9)
        self.addSubview(label)
    }
    
    override func layoutSubviews() {
        
//        self.label.bounds = self.bounds
        self.label.clipsToBounds = true
//        self.label.sizeToFit()
    }
    
    deinit {
        self.label.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    private lazy var label: UILabel = {
        
        let label = UILabel(frame: self.bounds)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = NAVIGATIONBAR_TEXT_COLOR
        
        return label
    }()

}
