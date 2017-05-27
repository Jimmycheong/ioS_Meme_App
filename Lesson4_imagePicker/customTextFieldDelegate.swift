//
//  customTextFieldDelegate.swift
//  Lesson4_imagePicker
//
//  Created by Jimmy Cheong on 26/05/2017.
//  Copyright © 2017 jimmycheong. All rights reserved.
//

import Foundation
import UIKit

class customTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"  {
            textField.text = ""
        }

        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

}
