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

    private lazy var textView: IOS10TextView = {
        let tv = IOS10TextView(frame: CGRect.zero)
        tv.iehDelegate = self
        tv.backgroundColor = UIColor.white()
        tv.textColor = UIColor.black().withAlphaComponent(0.8)
        tv.becomeFirstResponder()
        tv.layer.cornerRadius = 2.0
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = self.isScrollingEnabled
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.isEnabled = self.buttonEnabled

        button.setTitleColor(UIColor.white(), for: .highlighted)
        button.setTitleColor(UIColor.brightBlue(), for: .focused)
        button.setTitleColor(UIColor.white().withAlphaComponent(0.6), for: .selected)

        button.setTitle("↑", for: UIControlState())

        button.backgroundColor = UIColor.brightBlue()

        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        button.addTarget(self, action: #selector(KeyboardBar.sendButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30/2
        return button
    }()

    private lazy var containerView: UIView = {
        let view = UIView(frame: self.frame)
        view.layer.borderColor = UIColor.blue().cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white()
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 18.0
        view.layer.borderColor = UIColor.containerViewBorderColor().cgColor
        view.clipsToBounds = true
        return view
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
        addSubview(containerView)
        containerView.addSubview(textView)
        containerView.addSubview(sendButton)

        let cv = ["containerView": containerView]
        let horizontalContraintsCV = NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[containerView]-4-|", options: .alignAllCenterY, metrics: nil, views: cv)
        let verticalContraintsCV   = NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[containerView]-4-|", options: [], metrics: nil, views: cv)

        let horizontalContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[textView]-4-[sendButton]-6-|", options: .alignAllCenterY, metrics: nil, views: views)
        let verticalContraints   = NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[textView]-4-|", options: [], metrics: nil, views: views)

        let height = NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1.0, constant: 30)
        let width = NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .width, multiplier: 1.0, constant: 30)

        height.isActive = true
        width.isActive = true

        NSLayoutConstraint.activate(horizontalContraints + verticalContraints + horizontalContraintsCV + verticalContraintsCV)
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
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CustomView.tappedMainView(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
extension UIColor {
    class func brightBlue() -> UIColor {
        return UIColor(colorLiteralRed: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    }

    class func containerViewBorderColor() -> UIColor {
        return UIColor(colorLiteralRed: 200/255, green: 200/255, blue: 205/255, alpha: 1.0)
    }

    class func buttonDisabledColor() -> UIColor {
        return UIColor(colorLiteralRed: 171/255, green: 183/255, blue: 183/255, alpha: 1.0)
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
