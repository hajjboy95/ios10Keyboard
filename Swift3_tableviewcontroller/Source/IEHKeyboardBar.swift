//
//  File.swift
//  generalTests
//
//  Created by Ismail el Habbash on 07/07/2016.#FAFAFA
//  Copyright © 2016 ismail el habbash. All rights reserved.
//

import UIKit
protocol IEHKeyboardBarProtocol: class {
    func iehKeyboardFinishing(text: String)
}

class IEHKeyboardBar: UIView {

    weak var iehKeyboardDelegate: IEHKeyboardBarProtocol?
    private var buttonEnabled = false {
        didSet {
            if buttonEnabled == false {
                sendButton.backgroundColor = UIColor.gray().withAlphaComponent(0.4)
            } else {
                sendButton.backgroundColor = UIColor.brightBlue()
            }
        }
    }
    private var isScrollingEnabled = false {
        didSet {
            textView.isScrollEnabled = isScrollingEnabled
        }
    }

    private var resetSelfToOriginalSize = false {
        didSet {
            if resetSelfToOriginalSize == true {
                invalidateIntrinsicContentSize()
            }
        }
    }

    // MARK: - View Setup

    private lazy var textView: IEHTextView = {
        let tv = IEHTextView(frame: CGRect.zero)
        tv.iehDelegate = self
        tv.backgroundColor = UIColor.backgroundColor()
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

        button.setTitleColor(UIColor.brightBlue().withAlphaComponent(0.4), for: .highlighted)
        button.setTitleColor(UIColor.white(), for: .selected)
        button.setTitle("↑", for: UIControlState())

        button.backgroundColor = UIColor.buttonDisabledColor()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        button.addTarget(self, action: #selector(IEHKeyboardBar.sendButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30/2
        return button
    }()

    private lazy var containerView: UIView = {
        let view = UIView(frame: self.frame)
        view.layer.borderColor = UIColor.blue().cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.backgroundColor()
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 18.0
        view.layer.borderColor = UIColor.containerViewBorderColor().cgColor
        view.clipsToBounds = true
        return view
    }()

    func sendButtonTapped(_ sender: UIButton) {
        print(textView.text)
        if textView.text.characters.count > 1 {
            iehKeyboardDelegate?.iehKeyboardFinishing(text: textView.text)
            textView.text = ""
            resetView()
        }
    }

    // MARK: - Inits

    convenience init() {
        let screen = UIScreen.main().bounds
        let frame = CGRect(x: 0, y: 0, width: screen.size.width, height: 40)
        self.init(frame: frame)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white()
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

        let horizontalContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[textView]-4-[sendButton]-4-|", options: .alignAllBottom, metrics: nil, views: views)
        let verticalContraints   = NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[textView]-4-|", options: [], metrics: nil, views: views)

        let height = NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1.0, constant: 30)
        let width = NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .width, multiplier: 1.0, constant: 30)

        height.isActive = true
        width.isActive = true

        NSLayoutConstraint.activate(horizontalContraints + verticalContraints + horizontalContraintsCV + verticalContraintsCV)
    }

    // MARK: - Intrinsic size

    override func intrinsicContentSize() -> CGSize {
        // stop the expansion of the textview and make it scrollable instead
        return textViewProperties()
    }

    private func textViewProperties() -> CGSize {
        if resetSelfToOriginalSize {
            resetSelfToOriginalSize = false
            isScrollingEnabled = false
            return CGSize(width: self.frame.size.width, height: 40.0)
        } else {
            if textView.contentSize.height >= 99 {
                // stop expanding frame
                isScrollingEnabled = true
                return CGSize(width: bounds.width, height: 99)
            } else {
                isScrollingEnabled = false
                return textView.contentSize
            }
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

    private func resetView() {
        buttonEnabled = false
        //reset the intrinzicContentSize
        resetSelfToOriginalSize = true
    }
}

extension IEHKeyboardBar: IEHTextViewDelegate {
    func iehTextView(isEmpty: Bool) {
        buttonEnabled = !isEmpty
        sendButton.isEnabled = !isEmpty
        invalidateIntrinsicContentSize()
    }

    func iehTextViewChanged(_ text: String) {
        print("^ text in the textView == \(text)")
    }
}

extension UIColor {
    class func brightBlue() -> UIColor {
        return UIColor(red: 0, green: 122, blue: 255)
    }

    class func containerViewBorderColor() -> UIColor {
        return  UIColor(red:200, green:200, blue:205)
    }

    class func buttonDisabledColor() -> UIColor {
        return UIColor.gray().withAlphaComponent(0.4)
    }

    class func backgroundColor() -> UIColor {
        return UIColor(red:250, green:250, blue:250)
    }

    convenience init(red: Int, green: Int, blue:Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}

// Make this the custom tableview class in storyboard to get the keyboard as the input accessory view

class IEHTableView: UITableView {
    lazy var keyboardBar = IEHKeyboardBar()

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        becomeFirstResponder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        becomeFirstResponder()
    }

    // pass in a indexpath and once tableview has reached it then iehKeboard will pop up from the bottom.
    func iehBecomeFirstResponder(forIndex index: IndexPath) {
        guard let indexPathsForVisibleRows = indexPathsForVisibleRows else {return}

        for a in indexPathsForVisibleRows where a == index{
            becomeFirstResponder()
        }
    }

    override var inputAccessoryView: UIView {
        get {
            return keyboardBar
        }
    }
}

class IEHView: UIView {

    private lazy var keyboardBar = IEHKeyboardBar()

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        becomeFirstResponder()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(IEHView.tappedMainView(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        becomeFirstResponder()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(IEHView.tappedMainView(_:))))
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
