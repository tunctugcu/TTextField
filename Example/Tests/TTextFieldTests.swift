//
//  TTextFieldTests.swift
//  TTextField_Tests
//
//  Created by Selahattin Dulgeroglu on 26.09.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import TTextField

class TTextFieldTests: XCTestCase {

    var window: UIWindow!

    enum Constants {
        static let placeholderColor: UIColor = .gray
        static let onTopPlaceholderColor: UIColor = .blue
        static let placeholderFont = UIFont.systemFont(ofSize: 12)
        static let onTopPlaceholderFont = UIFont.systemFont(ofSize: 9)
        
        static let hintFont = UIFont.systemFont(ofSize: 6)
        static let hintColor: UIColor = .darkText
        
        static let separatorColor: UIColor = .magenta
    }

    var textField: TTextField!

    override func setUp() {
        super.setUp()
        textField = TTextField(frame: .init(x: 0, y: 0, width: 200, height: 50))
        textField.separatorColor = Constants.separatorColor

        textField.placeholderColor = Constants.placeholderColor
        textField.onTopPlaceholderColor = Constants.onTopPlaceholderColor
        textField.placeholderFont = Constants.placeholderFont
        textField.onTopPlaceholderFont = Constants.onTopPlaceholderFont
        
        // To make responder chain work properly we need to add textField to visible view hierarchy
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        let controller = UIViewController()
        controller.view.addSubview(textField)
        window.rootViewController = controller
    }
    
    func testPlaceholder() {
        textField.placeholder = "Test Placeholder"
        XCTAssertEqual(textField.placeholderLabel.text, "Test Placeholder")
    }

    func testPlaceholderModeSimple() {
        textField.placeholderMode = .simple

        // When empty and not editing
        textField.text = nil
        _ = textField.resignFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.placeholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.placeholderFont)
        
        // When empty and editing
        _ = textField.becomeFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.placeholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.placeholderFont)
        
        // When not empty and not editig
        _ = textField.resignFirstResponder()
        textField.text = "Some Input"
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.placeholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.placeholderFont)
        
        // When not empty and not editig
        _ = textField.becomeFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.placeholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.placeholderFont)
    }

    func testPlaceholderModeOnTopWhenEditing() {
        textField.placeholderMode = .onTopWhenEditing

        // When empty and not editing
        textField.text = nil
        _ = textField.resignFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.placeholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.placeholderFont)
        
        // When empty and editing
        _ = textField.becomeFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.onTopPlaceholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.onTopPlaceholderFont)
        
        // When not empty and not editig
        _ = textField.resignFirstResponder()
        textField.text = "Some Input"
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.onTopPlaceholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.onTopPlaceholderFont)
        
        // When not empty and not editig
        _ = textField.becomeFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.onTopPlaceholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.onTopPlaceholderFont)
        
    }

    func testPlaceholderModeOnTopWhenNotEmpty() {
        textField.placeholderMode = .onTopWhenNotEmpty

        // When empty and not editing
        textField.text = nil
        _ = textField.resignFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.placeholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.placeholderFont)
        
        // When empty and editing
        _ = textField.becomeFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.placeholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.placeholderFont)
        
        // When not empty and not editig
        _ = textField.resignFirstResponder()
        textField.text = "Some Input"
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.onTopPlaceholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.onTopPlaceholderFont)
        
        // When not empty and not editig
        _ = textField.becomeFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.onTopPlaceholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.onTopPlaceholderFont)
        
    }

    func testPlaceholderModeOnTopAlways() {
        textField.placeholderMode = .onTopAlways

        // When empty and not editing
        textField.text = nil
        _ = textField.resignFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.onTopPlaceholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.onTopPlaceholderFont)
        
        // When empty and editing
        _ = textField.becomeFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.onTopPlaceholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.onTopPlaceholderFont)
        
        // When not empty and not editig
        _ = textField.resignFirstResponder()
        textField.text = "Some Input"
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.onTopPlaceholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.onTopPlaceholderFont)
        
        // When not empty and not editig
        _ = textField.becomeFirstResponder()
        XCTAssertEqual(textField.placeholderLabel.textColor, Constants.onTopPlaceholderColor)
        XCTAssertEqual(textField.placeholderLabel.font, Constants.onTopPlaceholderFont)
        
    }
    
    func testPlaceholderColor() {
        textField.placeholderColor = .yellow
        XCTAssertEqual(textField.placeholderLabel.textColor, .yellow)
    }
    
    func testSepatatorColor() {
        textField.separatorColor = .cyan
        XCTAssertEqual(textField.separator.backgroundColor, .cyan)
    }

    func testHint() {

        textField.hint = "Some Hint"
        XCTAssertEqual(textField.hintLabel.text, "Some Hint")
    }
    
    func testHintFont() {
        let font = UIFont.preferredFont(forTextStyle: .caption1)
        textField.hintFont = font
        XCTAssertEqual(textField.hintLabel.font, font)
    }
    
    func testHintColor() {
        textField.hintColor = .green
        XCTAssertEqual(textField.hintLabel.textColor, .green)
    }
}

extension UIView {

    func viewWithIdentifier<T>(_ identifier: String) -> T? {
        return viewWithIdentifier(identifier) as? T
    }

    func viewWithIdentifier(_ identifier: String) -> UIView? {
        
        for view in subviews {
            if view.accessibilityIdentifier == identifier {
                return view
            }
        }
        
        for view in subviews {
            if let view = view.viewWithIdentifier(identifier) {
                return view
            }
        }

        return nil
    }
}

extension TTextField {

    var placeholderLabel: UILabel {
        return viewWithIdentifier("Placeholder").unsafelyUnwrapped
    }
    
    var separator: UIView {
        return viewWithIdentifier("Separator").unsafelyUnwrapped
    }
    
    var hintLabel: UILabel {
        return viewWithIdentifier("Hint").unsafelyUnwrapped
    }
}
