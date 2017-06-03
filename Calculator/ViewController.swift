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
    @IBOutlet weak var sequence: UILabel!
    
    var userInMiddleOfTyping = false
    var dotDisable = false
    
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
    
    @IBAction func touchDot(_ sender: UIButton) {
        if !dotDisable {
            let dot = sender.currentTitle!
            dotDisable = true
            let currentTextDisplay = display.text!
            display.text = currentTextDisplay + dot
            userInMiddleOfTyping = true
        }
    }
    
    var displayValue:Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(format: "%g", newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userInMiddleOfTyping {
            brain.setOperand(displayValue)
            userInMiddleOfTyping = false
            dotDisable = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }else if brain.allClear{
            displayValue = 0
            sequence.text = ""
            brain.allClear = false
        }
        if brain.description != "" {
            if brain.resultIsPending {
                sequence.text = brain.description + " ..."
            }else{
                sequence.text = brain.description + " ="
            }
        }else{
            sequence.text = ""
        }
    }
    
    
    
}

