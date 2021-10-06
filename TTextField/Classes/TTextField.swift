//
//  TTextField.swift
//  Pods-TTextField_Example
//
//  Created by Tunc Tugcu on 4.08.2021.
//

import UIKit

open class TTextField: UITextField {

    public enum PlaceholderMode {
        /// The default behavior of `UITextField`
        case simple
        
        /// The placeholder scales when it is not empty or when the text field is being edited
        case onTopWhenEditing
            
        /// The placeholder scales when it is not empty
        case onTopWhenNotEmpty
        
        /// The placeholder is locked in the transformed position above the text field
        case onTopAlways
    }

    private enum Constant {
        
        static let heightMeasurementSampleText = "X"
        static let horizontalSpacing: CGFloat = 5.0

        enum Separator {
            static let accessibiliyIdentifier = "Separator"
            static let height: CGFloat = 1/3
        }
        
        enum Hint {
            static let accessibiliyIdentifier = "Hint"
            static let defaultOffset: CGFloat = 0
        }
        
        enum Placeholder {
            static let accessibiliyIdentifier = "Placeholder"
            static let defaultOffset: CGFloat = 0.0
        }
    }

    override open var text: String? {
        didSet {
                updatePlaceholderConstraints()
        }
    }

    private var padding: UIEdgeInsets {
        var bottomInset = Constant.Separator.height + bottomTextPadding
        
        if hintAvailable {
            bottomInset += hintLabelHeight
        }

        return UIEdgeInsets(top: placeholderOnTopRectHeight + topTextPadding,
                            left: leftPadding,
                            bottom: bottomInset,
                            right: rightPadding)
    }

    private var leftPadding: CGFloat {
        guard layoutDirection == .rightToLeft, rightView != nil else { return .zero }
        return leftViewRect(forBounds: bounds).maxX + Constant.horizontalSpacing
    }

    private var rightPadding: CGFloat {
        guard layoutDirection == .leftToRight, rightView != nil else { return .zero }
        return bounds.width - rightViewRect(forBounds: bounds).minX + Constant.horizontalSpacing
    }

    // MARK: - Properties
    public override var placeholder: String? {
        get { return placeholderLabel.text }
        set {
            placeholderLabel.text = newValue
            updatePlaceholderConstraints()
        }
    }
    
    public var placeholderMode: PlaceholderMode = .onTopWhenNotEmpty {
        didSet {
            updatePlaceholderConstraints()
        }
    }

    public var placeholderFont: UIFont? {
        didSet {
            updatePlaceholderConstraints()
        }
    }
    
    public var onTopPlaceholderFont: UIFont? = UIFont.systemFont(ofSize: 11) {
        didSet {
            updatePlaceholderConstraints()
        }
    }

    public var placeholderColor: UIColor? = .gray {
        didSet {
            updatePlaceholderConstraints()
        }
    }
    
    public var onTopPlaceholderColor: UIColor? = .blue {
        didSet {
            updatePlaceholderConstraints()
        }
    }

    public var separatorColor: UIColor? {
        get { return separator.backgroundColor }
        set { separator.backgroundColor = newValue }
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
            hintLabel.font = hintFont
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

    public override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
            hintLabel.textAlignment = textAlignment
        }
    }

    public var layoutDirection: UIUserInterfaceLayoutDirection = .leftToRight {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable public var hasIntrinsicHeight: Bool = true

    @IBInspectable public var hintOffset: CGFloat = Constant.Hint.defaultOffset {
        didSet {
            updateBottomConstraints()
        }
    }

    @IBInspectable public var onTopPlaceholderOffset: CGFloat = Constant.Placeholder.defaultOffset {
        didSet {
            updatePlaceholderConstraints()
        }
    }
    
    @IBInspectable public var bottomTextPadding: CGFloat = .zero {
        didSet {
            updatePlaceholderConstraints()
        }
    }

    @IBInspectable public var topTextPadding: CGFloat = .zero {
        didSet {
            updatePlaceholderConstraints()
        }
    }

    // MARK: - Private properties

    private lazy var separatorBottomConstraint = separator.bottomAnchor.constraint(equalTo: bottomAnchor)
    private lazy var placeholderLabelBottomConstraint = placeholderLabel.bottomAnchor.constraint(equalTo: separator.topAnchor)
    private lazy var placeholderLabelTopConstraint = placeholderLabel.topAnchor.constraint(equalTo: topAnchor)
    
    // MARK: - Views
    private let separator = UIView()
    private let hintLabel = UILabel()
    private let placeholderLabel = UILabel()

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
        setupPlaceholderLabel()
        setupSeparator()
        setupHintLabel()

        /// Initial styling
        style()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldChanged(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: self)

    }
    
    // MARK: - Setup Elements
    
    private func setupPlaceholderLabel() {
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.numberOfLines = 1
        placeholderLabel.font = placeholderFont
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.accessibilityIdentifier = Constant.Placeholder.accessibiliyIdentifier
        addSubview(placeholderLabel)
    }

    private func setupSeparator() {
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.accessibilityIdentifier = Constant.Separator.accessibiliyIdentifier
        addSubview(separator)
    }
    
    private func setupHintLabel() {
        hintLabel.lineBreakMode = .byWordWrapping
        hintLabel.numberOfLines = 0
        hintLabel.font = hintFont
        hintLabel.textColor = hintColor
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.accessibilityIdentifier = Constant.Hint.accessibiliyIdentifier
        addSubview(hintLabel)
    }

    private func setupConstraints() {
        
        /// Placeholder
        let placeholderLabelLeadingConstraint = placeholderLabel.leadingAnchor.constraint(equalTo: separator.leadingAnchor)
        let placeholderLabelTrailingConstraint = placeholderLabel.trailingAnchor.constraint(equalTo: separator.trailingAnchor)

        /// Separator
        let separatorHeightConstraint = separator.heightAnchor.constraint(equalToConstant: Constant.Separator.height)
        let separatorLeadingConstraint = separator.leadingAnchor.constraint(equalTo: leadingAnchor)
        let separatorTrailingConstraint = separator.trailingAnchor.constraint(equalTo: trailingAnchor)

        /// Hint Label
        let hintLabelLeadingConstraint = hintLabel.leadingAnchor.constraint(equalTo: separator.leadingAnchor)
        let hintLabelTrailingConstraint = hintLabel.trailingAnchor.constraint(equalTo: separator.trailingAnchor)
        let hintLabelTopConstraint = hintLabel.bottomAnchor.constraint(equalTo: bottomAnchor)

        NSLayoutConstraint.activate([placeholderLabelTopConstraint,
                                     placeholderLabelLeadingConstraint,
                                     placeholderLabelTrailingConstraint,
                                     separatorHeightConstraint,
                                     separatorLeadingConstraint,
                                     separatorTrailingConstraint,
                                     separatorBottomConstraint,
                                     hintLabelLeadingConstraint,
                                     hintLabelTrailingConstraint,
                                     hintLabelTopConstraint])
    }

    // MARK: - Styling
    private func style() {
        hintLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    // MARK: - Changes
    @objc private func textFieldChanged(_ notification: Notification) {
        guard let textField = notification.object as? TTextField, textField == self else { return }
        updatePlaceholderConstraints()
    }
    
    // MARK: - Focus changes
    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        defer { updatePlaceholderConstraints() }
        return super.becomeFirstResponder()
    }
    
    @discardableResult
    open override func resignFirstResponder() -> Bool {
        defer { updatePlaceholderConstraints() }
        return super.resignFirstResponder()
    }
}

// MARK: - Padding
extension TTextField {

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return editingText(forBounds: bounds)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return editingText(forBounds: bounds)
    }
    
    private func editingText(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return leftRightViewRect(forRect: super.leftViewRect(forBounds: bounds))
    }

    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return leftRightViewRect(forRect: super.rightViewRect(forBounds: bounds))
    }

    private func leftRightViewRect(forRect rect: CGRect) -> CGRect {
        
        let textHeight = Constant.heightMeasurementSampleText.size(using: font).height
        let size = rect.size
        let y = placeholderOnTopRectHeight + 0.5 * (textHeight - size.height)
        let rect = CGRect(origin: CGPoint(x: rect.origin.x, y: y), size: size)
        
        return rect
    }
}

// MARK: - Helper
extension TTextField {

    private var hintLabelHeight: CGFloat {
        guard hintLabel.font != nil else { return 0 }
        return hintLabel.textHeight + hintOffset
    }
    
    private var hintAvailable: Bool {
        return !hintLabel.isHidden && hintLabel.text != nil
    }
    
    private func updateBottomConstraints() {
        if hintAvailable {
            separatorBottomConstraint.constant = -hintLabelHeight
        } else {
            separatorBottomConstraint.constant = 0
        }
        
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    private var placeholderHeight: CGFloat {

        if placeholderMode != .simple {
            return placeholder?.size(using: onTopPlaceholderFont).height ?? .zero
        } else {
            return .zero
        }
    }
    
    private var placeholderOnTopRectHeight: CGFloat {
        guard placeholderMode != .simple else { return .zero }
        return placeholderHeight + onTopPlaceholderOffset
    }

    private func updatePlaceholderConstraints() {
        placeholderLabel.font = isPlaceholderOnTop ? onTopPlaceholderFont : placeholderFont
        placeholderLabel.textColor = isPlaceholderOnTop ? onTopPlaceholderColor : placeholderColor
        placeholderLabelTopConstraint.isActive = isPlaceholderOnTop || !hasIntrinsicHeight
        placeholderLabelBottomConstraint.constant = -bottomTextPadding
        placeholderLabelBottomConstraint.isActive = !isPlaceholderOnTop
        placeholderLabel.isHidden = !isPlaceholderOnTop && !isEmpty
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    private var isPlaceholderOnTop: Bool {
        switch placeholderMode {
        case .simple:
            return false
        case .onTopAlways:
            return true
        case .onTopWhenEditing:
            return  isFirstResponder || !isEmpty
        case .onTopWhenNotEmpty:
            return !isEmpty
        }
    }

    private var isEmpty: Bool {
        return (text ?? "").isEmpty
    }
}

private extension String {
    func size(using font: UIFont?, availableWidth: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        
        guard let font = font else { return .zero }
        let size = CGSize(width: availableWidth, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [ .usesLineFragmentOrigin, .usesFontLeading ]
        let boundingRect = self.boundingRect(with: size, options: options, attributes: [ .font: font ], context: nil)
        let ceilSize = CGSize(width: ceil(boundingRect.width), height: ceil(boundingRect.height))
        
        return ceilSize
    }
}

private extension UILabel {
    var textHeight: CGFloat {
        guard let text = text else { return .zero }
        let width = superview?.bounds.width ??  .greatestFiniteMagnitude
        return text.size(using: font, availableWidth: width).height
    }
}
