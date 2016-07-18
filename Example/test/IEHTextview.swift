//
//  IEHTextView.swift
//  IEHTextView
//
//  Created by Ismail El-Habbash on 6/12/16.
//  Copyright © 2016 Ismail El-Habbash. All rights reserved.
//

import UIKit


@objc protocol IEHTextViewDelegate: class {
    func iehTextView(isEmpty empty:Bool)
    @objc optional func iehTextViewChanged(_ text: String)
}

@IBDesignable final class IEHTextView: UITextView {
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
        NotificationCenter.default.removeObserver(self)
    }

    private func registerToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(IEHTextView.textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
    }

    func textDidChange() {
        if text.characters.count > 0 {
            placeholderLabel.isHidden = true
            iehDelegate?.iehTextViewChanged?(text)
            iehDelegate?.iehTextView(isEmpty: false)
        } else {
            placeholderLabel.isHidden = false
            iehDelegate?.iehTextView(isEmpty: true)
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
