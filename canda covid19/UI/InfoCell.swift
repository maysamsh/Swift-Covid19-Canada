//
//  InfoCell.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-03.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import UIKit

@IBDesignable
class InfoCell: UIView {
    private var view: UIView!
    var alternateColor: Bool = false {
        didSet {
            changeColors(alternate: alternateColor)
        }
    }
    var largerIsWorse: Bool = true {
        didSet {
            changeSubValueColors(largerIsWorse: largerIsWorse)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var subValuePrefix: UILabel!
    @IBOutlet weak var subValueLabel: EFCountingLabel!
        
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
        setup()
    }
    
    private func setup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        self.view = view
        view.backgroundColor = .clear
        self.backgroundColor = .clear
        configureUI()
    }
    
    private func configureUI(){
        subValuePrefix.text = ""
        titleLabel.text = "-"
        subtitleLabel.text = ""
        valueLabel.text = "-"
        for item in [subValueLabel, subValuePrefix] {
            item?.font = UIFont.boldSystemFont(ofSize: 10)
        }
    }
    
    private func changeColors(alternate: Bool) {
        if alternate {
            if #available(iOS 13.0, *) {
                subtitleLabel.textColor = .tertiaryLabel
                for item in [titleLabel, valueLabel] {
                    item?.textColor = .secondaryLabel
                }
            } else {
                subtitleLabel.textColor = .lightGray
                for item in [titleLabel, valueLabel] {
                    item?.textColor = .darkGray
                }
            }
        } else {
            if #available(iOS 13.0, *) {
                subtitleLabel.textColor = .secondaryLabel
                for item in [titleLabel, valueLabel] {
                    item?.textColor = .label
                }
            } else {
                subtitleLabel.textColor = .darkGray
                for item in [titleLabel, valueLabel] {
                    item?.textColor = .black
                }
            }
        }
    }
    
    private func changeSubValueColors(largerIsWorse: Bool){
        if largerIsWorse {
            for item in [subValueLabel, subValuePrefix] {
                if #available(iOS 13.0, *) {
                    switch subValuePrefix.text {
                    case "+"?:
                        item?.textColor = .systemRed
                    case "-"?:
                        item?.textColor = .systemGreen
                    default:
                        item?.textColor = titleLabel.textColor
                    }
                    
                } else {
                    switch subValuePrefix.text {
                    case "+"?:
                        item?.textColor = .red
                    case "-"?:
                        item?.textColor = .red
                    default:
                        item?.textColor = titleLabel.textColor
                    }
                }
            }
        } else {
            for item in [subValueLabel, subValuePrefix] {
                if #available(iOS 13.0, *) {
                    switch subValuePrefix.text {
                    case "-"?:
                        item?.textColor = .systemRed
                    case "+"?:
                        item?.textColor = .systemGreen
                    default:
                        item?.textColor = titleLabel.textColor
                    }
                    
                } else {
                    switch subValuePrefix.text {
                    case "-"?:
                        item?.textColor = .red
                    case "+"?:
                        item?.textColor = .red
                    default:
                        item?.textColor = titleLabel.textColor
                    }
                }
            }
        }
    }
}
