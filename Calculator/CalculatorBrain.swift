//
//  CalculateBrain.swift
//  Calculator
//
//  Created by CHEN CHEN on 3/30/17.
//  Copyright © 2017 CHEN CHEN. All rights reserved.
//

import Foundation

struct CalculatorBrain{
    
    private var accumulator: Double?
    private var descriptionAdded: Bool = false
    var resultIsPending: Bool = false
    var description: String = ""
    var allClear: Bool = false


    // enum used to support multiple operation types in operationMap
    // each case can have an associate value, function is also considered a normal type
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
    }
    
    private var operationMap: Dictionary<String,Operation> =
    [
     "π" : Operation.constant(Double.pi),
     "e" : Operation.constant(M_E),
     "√" : Operation.unaryOperation(sqrt),
     "sin" : Operation.unaryOperation(sin),
     "cos" : Operation.unaryOperation(cos),
     "log" : Operation.unaryOperation(log10),
     "ln" : Operation.unaryOperation(log),
     "+" : Operation.binaryOperation({$0 + $1}), // use closure for simple operation
     "-" : Operation.binaryOperation({$0 - $1}),
     "×" : Operation.binaryOperation({$0 * $1}),
     "÷" : Operation.binaryOperation({$0 / $1}),
     "=" : Operation.equals,
     "AC" : Operation.clear
    ]
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand:Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operationMap[symbol] {
            switch operation {
            case .constant(let value):
                    accumulator = value
                    description += symbol
                    descriptionAdded = true
            case .unaryOperation(let unaryFunc):
                if accumulator != nil{
                    if resultIsPending {
                        description += symbol + "(" + String(format: "%g", accumulator!) + ")"
                        descriptionAdded = true
                    }else{
                        description = symbol + "(" + description + ")"
                    }
                    accumulator = unaryFunc(accumulator!)
                }
            case .binaryOperation(let binaryFunc):
                if accumulator != nil{
                    if resultIsPending {
                        performPendingBinaryOperation()
                    }
                    description += symbol
                    descriptionAdded = false
                    pendingBinaryOperation = PendingBinaryOperation(function: binaryFunc, firstOperand: accumulator!)
                    //accumulator = nil
                    resultIsPending = true
                }
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false
            case .clear:
                accumulator = nil
                pendingBinaryOperation = nil
                description = ""
                resultIsPending = false
                descriptionAdded = false
                allClear = true
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil{
            if !descriptionAdded {
                description += String(format: "%g", accumulator!)
            }else {
                descriptionAdded = false
            }
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
        if !resultIsPending {
            description = String(format: "%g", accumulator!)
        }
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
}
