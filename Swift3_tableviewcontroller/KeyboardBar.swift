//
//  File.swift
//  generalTests
//
//  Created by Ismail el Habbash on 07/07/2016.
//  Copyright © 2016 ismail el habbash. All rights reserved.
//

import UIKit

class KeyboardBar: UIView {

    private lazy var buttonEnabled = false
    private var isScrollingEnabled = false {
        didSet {
            textView.isScrollEnabled = isScrollingEnabled
        }
    }

    // MARK: - view setup

    private lazy var textView: IEHTextView = {
        let tv = IEHTextView(frame: CGRect.zero)
        tv.iehDelegate = self
        tv.backgroundColor = UIColor.white()
        tv.textColor = UIColor.black().withAlphaComponent(0.8)
        tv.becomeFirstResponder()
        tv.layer.cornerRadius = 2.0
        tv.layer.borderWidth = 0.15
        tv.layer.borderColor = UIColor.lightGray().withAlphaComponent(0.5).cgColor
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = self.isScrollingEnabled
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.setTitleColor(UIColor(red: 89/255, green: 171/255, blue: 227/255, alpha: 1.0) , for: UIControlState())
        button.setTitleColor(UIColor(red: 89/255, green: 171/255, blue: 227/255, alpha: 1.0).withAlphaComponent(0.4) , for: .highlighted)
        button.setTitleColor(UIColor.lightGray() , for: .disabled)

        button.isEnabled = self.buttonEnabled
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        button.setTitle("Send", for: UIControlState())
        button.addTarget(self, action: #selector(KeyboardBar.sendButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    func sendButtonTapped(_ sender: UIButton) {
        print(textView.text)
        textView.text = ""
    }

    // MARK: - Inits

    convenience init() {
        let screen = UIScreen.main().bounds
        let frame = CGRect(x: 0, y: 0, width: screen.size.width, height: 40)
        self.init(frame: frame)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure views

    private func configureViews() {
        autoresizingMask = .flexibleHeight
        let views = ["textView":textView, "sendButton": sendButton]
        addSubview(textView)
        addSubview(sendButton)

        let horizontalContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[textView]-4-[sendButton(35)]-4-|", options: .alignAllCenterY, metrics: nil, views: views)
        let verticalContraints   = NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[textView]-4-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalContraints + verticalContraints)
    }

    override func intrinsicContentSize() -> CGSize {
        // stop the expansion of the textview and make it scrollable instead
        return textViewProperties()
    }

    private func textViewProperties() -> CGSize {

        if textView.contentSize.height >= 99 {
            // stop expanding frame
            isScrollingEnabled = true
            return CGSize(width: bounds.width, height: 99)
        } else {
            isScrollingEnabled = false
            return textView.contentSize
        }
    }

    private func invalidateTextViewIntrinsicSizeIfNeeded() {

        if isScrollingEnabled == false {
            invalidateIntrinsicContentSize()
        } else {
            if textView.contentSize.height >= 99 {
                isScrollingEnabled = true
            } else {
                isScrollingEnabled = false
            }
        }
    }
}

extension KeyboardBar: IEHTextViewDelegate {
    func iehTextView(_ isEmpty: Bool) {
        sendButton.isEnabled = !isEmpty
        invalidateTextViewIntrinsicSizeIfNeeded()

    }
}

class CustomTableView: UITableView {
    private lazy var keyboardBar = KeyboardBar()

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
//        becomeFirstResponder()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CustomView.tappedMainView(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        becomeFirstResponder()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CustomView.tappedMainView(_:))))

    }
     func iehBecomeFirstResponder(forIndex index: IndexPath) {

        guard let indexPathsForVisibleRows = indexPathsForVisibleRows else {return}

        print("index = \(index)")
        print("")
        for a in indexPathsForVisibleRows where a == index{
            print(a)
            becomeFirstResponder()
        }
    }

    func tappedMainView(_ sender:UITapGestureRecognizer) {
        becomeFirstResponder()
    }

    override var inputAccessoryView: UIView {
        get {
            return keyboardBar
        }
    }
}

class CustomView: UIView {

    private lazy var keyboardBar = KeyboardBar()

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        becomeFirstResponder()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CustomView.tappedMainView(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        becomeFirstResponder()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CustomView.tappedMainView(_:))))
    }

    func tappedMainView(_ sender:UITapGestureRecognizer) {
        becomeFirstResponder()
    }

    override var inputAccessoryView: UIView {
        get {
            return keyboardBar
        }
    }
}
