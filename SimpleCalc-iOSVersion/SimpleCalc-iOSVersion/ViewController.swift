//
//  ViewController.swift
//  SimpleCalc-iOSVersion
//
//  Created by Megan Hodge on 10/20/15.
//  Copyright © 2015 Megan Hodge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    // gets the input from the buttons pressed and collects all of the numbers
    var calcInput : Double = 0.0
    
    // gets the input from the display and saves it to use later in the calculation
    var calcInputStored : Double = 0.0
    
    // gets all of the operation input from the buttons pressed
    var operationInput : String = ""
    
    // boolean to keep track of whether or not the screen should be reset/cleared to display the next number/result
    var clearForNext : Bool = false
    
    // keeps track of the count for the count operation
    var countC : Int = 0
    
    // keeps track of the number of numbers entered for the average function
    var countA : Int = 1
    
    var traditional : Bool = true
    
    var arrayForRPN : [Double] = []
    
    var totalForRPN : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func hasBeenClicked(sender: UIButton) {
        // uses RPN version of the calculator
        if !traditional {
            // collects numbers until an operator is pressed
            arrayForRPN.append(Double(self.display.text!)!)
            if sender.titleLabel!.text! == "=" {
                clearForNext = true
            } else {
                switch sender.titleLabel!.text! {
                    case "+":
                        self.display.text = String(arrayForRPN.reduce(0, combine: +))
                    case "-":
                        var total = arrayForRPN[0]
                        for each in 1...(arrayForRPN.count - 1) {
                            total -= arrayForRPN[each]
                        }
                        self.display.text = String(total)
                    case "x":
                        self.display.text = String(arrayForRPN.reduce(1, combine: *))
                    case "/":
                        var total = arrayForRPN[0]
                        for each in 1...(arrayForRPN.count - 1) {
                            total /= arrayForRPN[each]
                        }
                        self.display.text = String(total)
                    case "Clear":
                        self.display.text = "0"
                        clearForNext = false
                    default : break
                }
                arrayForRPN.removeAll()
                clearForNext = true
            }
        // uses the traditional version of the calculator
        } else {
            if sender.titleLabel!.text! != "=" && sender.titleLabel!.text! != "Avg" {
                clearForNext = true
                calcInputStored = Double(self.display.text!)!
            }
            switch sender.titleLabel!.text! {
                // only one number for calculation ex. 3 Fact => 6
                case "Fact" :
                    operationInput = "Fact"
                    self.display.text = String(fact(calcInputStored))
                // will follow pattern ex. # Avg # Avg # =  => (displays average of those three numbers)
                case "Avg" :
                    operationInput = "Avg"
                    clearForNext = true
                    // adds the numbers entered to collect the sum
                    calcInputStored += Double(self.display.text!)!
                    countA++
                
                case "Count" : // input for calculation follows pattern # Count # Count # = => 3 for example
                    operationInput = "Count"
                    countC++
                
                // for add, subtract, multiply, divide, and mod we are assuming the user will click in # then (+, 0, x, /, %) then # then = and we will show the result, they can then click another operation (+, 0, x, /, %) and then # and then = and it will do the operation using the last calculation's result and the new number and operation
                case "/" :
                    operationInput = "/"
                
                case "x" :
                    operationInput = "x"
                
                case "-" :
                    operationInput = "-"

                case "+" :
                    operationInput = "+"
                
                case "%" :
                    operationInput = "%"
                
                case "=" :
                    // stores the displayed number
                    //let calcInput = Double(self.display.text!)!
                    calcInput = Double(self.display.text!)!
                    // variable to keep track of the overall calculation
                    var displayCalculation : Double = 0
                    // since Fact takes one number it is calculated above
                    switch operationInput {
                        case "Avg" :
                            displayCalculation = (calcInput + calcInputStored) / Double(countA)
                        case "Count" :
                            displayCalculation = Double(countC + 1)
                        case "/" :
                            displayCalculation = calcInputStored / calcInput
                        case "x" :
                            displayCalculation = calcInputStored * calcInput
                        case "-" :
                            displayCalculation = calcInputStored - calcInput
                        case "+" :
                            displayCalculation = calcInputStored + calcInput
                        case "%" :
                            displayCalculation = calcInputStored % calcInput
                        default :
                            break
                    }
                    self.display.text! = String(displayCalculation)
                    clearForNext = true // will reset the display so that more numbers can be entered after the calculation is completed without adding numbers to the end of the calculated value
                    // still allows the user to click 3 + 1 = (shows 4) but if they click = again then it will continue to add 1 everytime they click = again so displays 5 then 6 etc.
                
                case "Clear" :
                    self.display.text = "0"
                    resetVariables() // if the user clicks clear then everything is reset to their original values
                default :
                    break
            }
        }
    }
    
    @IBAction func hasSelectedNumber(sender: UIButton) {
        // if it is zero then we know they are at the beginning of a calculation so we display nothing because we don't want the zero to float in front and we will then display the number clicked
        if self.display.text == "0" {
            self.display.text = ""
        }
        
        // if reset is true then it will clear the screen so the new input can be displayed
        if clearForNext {
            self.display.text = ""
            clearForNext = false
        }
        
        // gets the text from the button (button has label object which has text property)
        switch sender.titleLabel!.text! {
            case "0" :
                self.display.text! += "0"
            case "1" :
                self.display.text! += "1"
            case "2" :
                self.display.text! += "2"
            case "3" :
                self.display.text! += "3"
            case "4" :
                self.display.text! += "4"
            case "5" :
                self.display.text! += "5"
            case "6" :
                self.display.text! += "6"
            case "7" :
                self.display.text! += "7"
            case "8" :
                self.display.text! += "8"
            case "9" :
                self.display.text! += "9"
            case "." :
                // need to check if a decimal place is already there because if it is then it shouldn't add another since 1.0.0 doesn't make sense
                // if it does not contain the decimal place already then it adds one to the end of the number(s)
                if !self.display.text!.containsString(".") {
                    self.display.text! += "."
                }
            default :
                break
        }
    }
    
    // switches between traditional and RPN functionality
    @IBAction func Toggle(sender: UISwitch) {
        if !sender.on {
            traditional = false
        } else {
            traditional = true
        }
    }
    
    
    // resets the calculation input and operation input because everything should be clean/reset for a new calculation, variable reset is reset to false
    func resetVariables() -> Void {
        calcInput = 0
        operationInput = ""
        clearForNext = false
    }
    
    // calculates factorial
    func fact(input : Double) -> Double {
        if input == 0 {
            return 1
        } else {
            return input * fact(input - 1)
        }
    }
}