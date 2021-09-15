//
//  ViewController.swift
//  TTextField
//
//  Created by Tunc Tugcu on 07/27/2021.
//  Copyright (c) 2021 Tunc Tugcu. All rights reserved.
//

import UIKit
import TTextField

final class ViewController: UIViewController {
    @IBOutlet private weak var uiTextField: TTextField!
    
    private let textField = TTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiTextField.text = "Initialized from XIB"
        uiTextField.hint = "I have hint here, I have hint here I have hint here, I have hint here!!!!!I have hint here, I have hint here I have hint here, I have hint here!!!!!I have hint here, I have hint here I have hint here, I have hint here!!!!!I have hint here, I have hint here I have hint here, I have hint here!!!!!I have hint here, I have hint here I have hint here, I have hint here!!!!!I have hint here, I have hint here I have hint here, I have hint here!!!!!I have hint here, I have hint here I have hint here, I have hint here!!!!!"
        setupTextField()
        textField.text = "Programmatically done"
        textField.hint = "I have hint here 2"
        
        setupTestFrames()
    }
    
    private func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: uiTextField.bottomAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: uiTextField.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: uiTextField.trailingAnchor)
        ])
    }
    
    private func setupTestFrames() {
        uiTextField.layer.borderColor = UIColor.brown.cgColor
        uiTextField.layer.borderWidth = 1
        
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.blue.cgColor
    }
    
    @IBAction private func toggleHint() {
        uiTextField.hintIsHidden.toggle()
    }
    
}

