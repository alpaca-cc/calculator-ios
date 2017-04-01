//
//  ViewController.swift
//  Calculator
//
//  Created by CHEN CHEN on 3/25/17.
//  Copyright © 2017 CHEN CHEN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userInMiddleOfTyping = false
    
    // function to input number
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userInMiddleOfTyping {
            let currentTextDisplay = display.text!
            display.text = currentTextDisplay + digit
        }else {
            display.text = digit
            userInMiddleOfTyping = true
        }
    }
    
    var displayValue:Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userInMiddleOfTyping {
            brain.setOperand(displayValue)
            userInMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
}

