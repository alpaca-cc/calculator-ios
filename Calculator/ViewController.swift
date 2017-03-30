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
    
    @IBAction func performOperation(_ sender: UIButton) {
        userInMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            switch mathematicalSymbol {
                case "π":
                    displayValue = Double.pi
                case "√":
                    displayValue = sqrt(displayValue)
                default:
                    break
            }
        }
    }
    
}

