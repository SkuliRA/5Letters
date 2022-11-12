//
//  MyTextField.swift
//  5Letters
//
//  Created by Skuli on 03.11.2022.
//

import UIKit

class MyTextField: UITextField {

    override public func deleteBackward() {
        if text == "" {
            if let vc = delegate as? ViewController {
                vc.backspace(tag: tag)
            }
        }
        super.deleteBackward()
    }
    
}
