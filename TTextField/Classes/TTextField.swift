//
//  TTextField.swift
//  Pods-TTextField_Example
//
//  Created by Tunc Tugcu on 4.08.2021.
//

import UIKit

public final class TTextField: UITextField {
    
    private enum Constant {
        enum Separator {
            static let height: CGFloat = 1/3
        }
        
        enum Hint {
            static let verticalPadding: CGFloat = 0
        }
    }
    
    private var padding: UIEdgeInsets {
        var bottomInset = Constant.Separator.height
        
        if hintAvailable {
            bottomInset += hintLabelHeight
        }
        
        return UIEdgeInsets(top: 0,
                            left: 0,
                            bottom: bottomInset,
                            right: 0)
    }
    
    // MARK: - Properties
    public override var placeholder: String? {
        get { return placeHolderLabel.text }
        set { placeHolderLabel.text = newValue }
    }
    
    public var placeholderFont: UIFont? {
        didSet {
            placeHolderLabel.font = placeholderFont
        }
    }
    
    public var placeholderColor: UIColor? {
        didSet {
            placeHolderLabel.textColor = placeholderColor
        }
    }
    
    public var hint: String? {
        get { return hintLabel.text }
        set {
            hintLabel.text = newValue
            updateBottomConstraints()
        }
    }
    
    public var hintFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
            hintLabel.font = font
            setNeedsDisplay()
        }
    }
    
    public var hintColor: UIColor = UIColor.systemRed {
        didSet {
            hintLabel.textColor = hintColor
            setNeedsDisplay()
        }
    }
    
    public var hintIsHidden: Bool {
        get { hintLabel.isHidden }
        set {
            hintLabel.isHidden = newValue
            updateBottomConstraints()
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Private properties
    private lazy var hintLabelHeightConstraint: NSLayoutConstraint = hintLabel.heightAnchor.constraint(equalToConstant: 0)
    private lazy var separatorBottomConstraint = separator.bottomAnchor.constraint(equalTo: bottomAnchor)
    
    // MARK: - Views
    private let separator = UIView()
    private let hintLabel = UILabel()
    private let placeHolderLabel = UILabel()
    
    // MARK: - Initalizers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        print("Init with frame")
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("Init with coder")
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        borderStyle = .none
        setupSeparator()
        setupHintLabel()
        
        /// Initial styling
        style()
        
        setupConstraints()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldChanged(_:)),
                                               name: NSNotification.Name.UITextFieldTextDidChange,
                                               object: self)
    }
    
    // MARK: - Setup Elements
    private func setupSeparator() {
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
    }
    
    private func setupHintLabel() {
        hintLabel.lineBreakMode = .byWordWrapping
        hintLabel.numberOfLines = 0
        hintLabel.font = hintFont
        hintLabel.textColor = hintColor
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hintLabel)
    }
    
    private func setupPlaceholder() {
        placeHolderLabel.lineBreakMode = .byWordWrapping
        placeHolderLabel.numberOfLines = 0
        
    }
    
    private func setupConstraints() {
        /// Separator
        let separatorHeightConstraint = separator.heightAnchor.constraint(equalToConstant: Constant.Separator.height)
        let separatorLeadingConstraint = separator.leadingAnchor.constraint(equalTo: leadingAnchor)
        let separatorTrailingConstraint = separator.trailingAnchor.constraint(equalTo: trailingAnchor)
        
        
        /// Hint Label
        let hintLabelLeadingConstraint = hintLabel.leadingAnchor.constraint(equalTo: separator.leadingAnchor)
        let hintLabelTrailingConstraint = hintLabel.trailingAnchor.constraint(equalTo: separator.trailingAnchor)
        let hintLabelTopConstraint = hintLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        
        NSLayoutConstraint.activate([separatorHeightConstraint,
                                     separatorLeadingConstraint,
                                     separatorTrailingConstraint,
                                     separatorBottomConstraint,
                                     hintLabelHeightConstraint,
                                     hintLabelLeadingConstraint,
                                     hintLabelTrailingConstraint,
                                     hintLabelTopConstraint])
    }
    
    // MARK: - Styling
    private func style() {
        separator.backgroundColor = .systemRed
        hintLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    // MARK: - Changes
    @objc private func textFieldChanged(_ notification: Notification) {
        guard let textField = notification.object as? TTextField, textField == self else { return }
        
    }
    
    // MARK: - Focus changes
    public override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        
        return super.resignFirstResponder()
    }
}

// MARK: - Padding
extension TTextField {
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

// MARK: - Helper
extension TTextField {
    private var hintLabelHeight: CGFloat {
        guard let font = hintLabel.font else { return 0 }
        let actualHeight = hintLabel.text?.size(using: font, availableWidth: bounds.width).height ?? 0
        
        return actualHeight + Constant.Hint.verticalPadding
    }
    
    private var hintAvailable: Bool {
        return !hintLabel.isHidden && !(hintLabel.text ?? "").isEmpty
    }
    
    private func updateBottomConstraints() {
        if hintAvailable {
            hintLabelHeightConstraint.constant = hintLabelHeight
            separatorBottomConstraint.constant = -hintLabelHeight
        } else {
            separatorBottomConstraint.constant = 0
        }
        
        setNeedsLayout()
    }
    
    private func updateTopConstraints() {
        
    }
}

private extension String {
    func size(using font: UIFont, availableWidth: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        let size = CGSize(width: availableWidth, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [ .usesLineFragmentOrigin, .usesFontLeading ]
        let boundingRect = self.boundingRect(with: size, options: options, attributes: [ .font: font ], context: nil)
        let ceilSize = CGSize(width: ceil(boundingRect.width), height: ceil(boundingRect.height))
        
        return ceilSize
    }
}

