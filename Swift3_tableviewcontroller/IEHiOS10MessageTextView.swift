//
//  ios10MessageTextView.swift
//  Swift3_tableviewcontroller
//
//  Created by Ismail el Habbash on 15/07/2016.
//  Copyright © 2016 ismail el habbash. All rights reserved.
//

import UIKit

class Ios10MessageTextView: UITextView {
    @IBInspectable var pText:String = "enter message" {
        didSet {
            placeholderLabel.text = pText
        }
    }

    @IBInspectable var pColor:UIColor = UIColor.gray() {
        didSet {
            placeholderLabel.textColor = pColor
        }
    }

    weak var iehDelegate:IEHTextViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureLabelWithText(pText)
        registerToNotifications()
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureLabelWithText(pText)
        registerToNotifications()
    }

    deinit {
        NotificationCenter.default().removeObserver(self)
    }

    private func registerToNotifications() {
        NotificationCenter.default().addObserver(self, selector: #selector(IEHTextView.textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
    }

    func textDidChange() {
        if self.text.characters.count > 0 {
            placeholderLabel.isHidden = true
            iehDelegate?.iehTextView(false)
        } else {
            placeholderLabel.isHidden = false
            iehDelegate?.iehTextView(true)
        }
    }

    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.gray()
        return label
    }()

    private func configureLabelWithText(_ text:String) {
        configureLabel()
        placeholderLabel.text = text
    }
    private func configureLabel() {
        self.addSubview(placeholderLabel)

        let view = ["placeholderLabel":placeholderLabel]
        let horizonalConstraint  = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[placeholderLabel]-0-|", options: [], metrics: nil, views: view)
        let VerticalConstraint  = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[placeholderLabel]->=0-|", options: [], metrics: nil, views: view)
        NSLayoutConstraint.activate(horizonalConstraint + VerticalConstraint)
    }
}
