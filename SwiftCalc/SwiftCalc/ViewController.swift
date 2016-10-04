//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Create an instance of Helper to use for calculations and other utilities
    let model = Helper()
    

    // Displays the text resulting from a calculation or button press
    var resultDisplay: String {
        get {
            return resultLabel.text!
        }
        set {
            if model.numbersDisplayed < 7 {
                resultLabel.text = newValue
            }
        }
    }
    
    
    // REQUIRED: The responder to a number button being pressed.
    
    // User starts typing when he or she presses the first digit of a number or presses an operator
    var inMiddleOfTyping = false

    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        
        // Displays new number if user stops typing
        if (inMiddleOfTyping) {
                resultDisplay = resultDisplay + sender.content
        } else {
                resultDisplay = sender.content
                inMiddleOfTyping = true
        }
        
        // Sets operand depending on whether or not operator has been set
        if model.operatorSet == "" {
            model.firstOperand = resultDisplay
        } else {
            model.secondOperand = resultDisplay
        }
        
        // Increment # of numbers displayed
        model.numbersDisplayed += 1
    }
    
    var previousOperatorWasEqual = false
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        print("Pressed \(sender.content)")
        model.numbersDisplayed = 0
        switch sender.content {
            case "C":
                inMiddleOfTyping = false
                resultDisplay = String(0)
                model.firstOperand = ""
                model.secondOperand = ""
                model.operatorSet = ""
                model.numbersDisplayed = 0
            case "%":
                resultDisplay = String(Double(resultDisplay)! / 100)
            case "+/-":
                
                // Will not work if there is already 7 characters in the display
                if model.numbersDisplayed >= 7 {
                    if Double(resultDisplay)! > 0 {
                        return
                    }
                }
                
                // Makes sure the displayed value is still the original type
                if Double(resultDisplay)!.truncatingRemainder(dividingBy: 1) != 0 {
                    resultDisplay = String(-Double(resultDisplay)!)
                    
                } else {
                    resultDisplay = String(-Int(resultDisplay)!)
                }
                
                if model.secondOperand != "" {
                    model.secondOperand = resultDisplay
                } else {
                    model.firstOperand = resultDisplay
                }
            
            case "=":
                
                inMiddleOfTyping = false
                previousOperatorWasEqual = true
                
                // Make sure the first and second operands aren't nil
                guard Double(model.firstOperand) != nil else { return }
                guard Double(model.secondOperand) != nil else { return }
                
                // If either of these two are doubles, then use the general calculation function to return a double
                if Double(model.firstOperand)?.truncatingRemainder(dividingBy: 1) != 0 ||
                    Double(model.secondOperand)?.truncatingRemainder(dividingBy: 1) != 0 {
                    let first = model.firstOperand
                    let second = model.secondOperand
                    model.firstOperand = String(model.calculate(a: first, b: second, operation: model.operatorSet))
                    
                // Both are integers, so use intCalculation
                } else {
                    let first = Int(model.firstOperand)!
                    let second = Int(model.secondOperand)!
                    model.firstOperand = model.intCalculate(a: first, b: second, operation: model.operatorSet)
                }
                
                // Display numbers only if the display has less than or equal to seven numbers
                if model.firstOperand.characters.count <= 7 {
                    resultDisplay = model.firstOperand
                    
                } else {
                    let scientificNotation = model.changeToScientific(x: Double(model.firstOperand)!)
                    if (scientificNotation.characters.count <= 7) {
                        resultDisplay = scientificNotation
                    }
                }
        
            // Operator pressed was +, -, *, or /
            default:
                
                inMiddleOfTyping = false
                
                // Allows for consecutive arithmetic operators
                if previousOperatorWasEqual {
                    model.secondOperand = ""
                }
                
                // Save the current operation if the current operator is + or -, so order of operations is respected
                if (sender.content == "*" || sender.content == "/") && model.secondOperand != "" {
                    if model.operatorSet == "+" || model.operatorSet == "-" {
                        model.accumulated = model.firstOperand
                        model.pendingOperator = model.operatorSet
                        model.firstOperand = model.secondOperand
                        model.operatorSet = sender.content
                        model.secondOperand = ""
                        break;
                    }
                }
                
                    
                // Allow for consecutive operations
                if model.secondOperand != "" {
                        
                    // If either of these two are doubles, then use the general calculation function and return a double
                    if Double(model.firstOperand)?.truncatingRemainder(dividingBy: 1) != 0 ||
                        Double(model.secondOperand)?.truncatingRemainder(dividingBy: 1) != 0 {
                        let first = model.firstOperand
                        let second = model.secondOperand
                        model.firstOperand = String(model.calculate(a: first, b: second, operation: model.operatorSet))
                        
                    // Both are integers so use intCalculate
                    } else {
                        let first = Int(model.firstOperand)!
                        let second = Int(model.secondOperand)!
                        model.firstOperand = model.intCalculate(a: first, b: second, operation: model.operatorSet)
                    }
                    
                    
                    // Display numbers only if the display has less than or equal to seven numbers
                    if model.firstOperand.characters.count <= 7 {
                        
                        resultDisplay = model.firstOperand
                        
                    } else {
                        let scientificNotation = model.changeToScientific(x: Double(model.firstOperand)!)
                        if (scientificNotation.characters.count <= 7) {
                            resultDisplay = scientificNotation
                        }
                        return
                    }
                    
                // No previous accumulated values
                } else {
                    model.firstOperand = resultDisplay
                    
                }
                model.operatorSet = sender.content
                model.secondOperand = ""
            }
    }
    
        
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
        if model.numbersDisplayed >= 7 { return }
        if sender.content == "0" {
            print("pressed 0")
            
            if (inMiddleOfTyping) {
                resultDisplay = resultDisplay + sender.content
            } else {
                resultDisplay = sender.content
                inMiddleOfTyping = true
            }
            
            // Sets operand depending on whether or not operator has been set
            if model.operatorSet == "" {
                model.firstOperand = resultDisplay
            } else {
                model.secondOperand = resultDisplay
            }
            
        } else if sender.content == "." {
            inMiddleOfTyping = true
            if resultDisplay.characters.last != "." {
                resultDisplay = resultDisplay + sender.content
            }
        }
        model.numbersDisplayed += 1
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

