//
//  ViewController.swift
//  Calculator
//
//  Created by ctlemler on 11/10/15.
//  Copyright © 2015 Chris Lemler. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false

    
    @IBAction func appendDigit(sender: UIButton) {
        let dot = "."
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if (digit == dot) && display.text!.containsString(dot) {
                return
            }
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    // Clear the stack, reset the display, and put
    // the calculator back to its original state
    @IBAction func clear(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        display.text = ""
        operandStack.removeAll()
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        // If user has entered a number, then selected an operation,
        // make certain the number has been pushed on to the operandStack
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        switch operation {
            case "×": performOperation({$0 * $1})
            case "÷": performOperation({$1 / $0})
            case "+": performOperation({$0 + $1})
            case "−": performOperation({$1 - $0})
            case "√": performOperation({ sqrt($0) })
            case "sin": performOperation({ sin($0) })
            case "cos": performOperation({ cos($0) })
            case "𝛑": performOperation({ sqrt($0) })
            default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    @nonobjc
    func performOperation(operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
}

