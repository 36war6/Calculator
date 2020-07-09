//
//  ViewController.swift
//  Calculator
//
//  Created by Edward Lee on 2020-06-03.
//  Copyright © 2020 Edward Lee. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    var answer = ""
    var question = ""
    var part1 = "", operation = "", part2 = ""
    // When turn=1, the user is entering the left side of the operation. Else turn=2 and the right side of the operation will be filled in
    var turn = 1
    var numberError = false
    
    // - MARK: Equals Button
    @IBAction func equalButton(_ sender: Any) {
        equalOperation ()
    }
    
    func equalOperation () {
        if !(operation=="") && part2=="" {
            answer = "Error: No value after" + operation
            answerLabel.text=answer
            return
        }
        if !(operation=="") && part1=="" {
            answer = "Error: No value before" + operation
            answerLabel.text=answer
            return
        }
        if (part1.prefix(1)=="%" || part2.prefix(1)=="%") {
            answer = "Error: Misused %"
            answerLabel.text=answer
            return
        }
        if (answer=="" || answer.contains("Error")) && (part1.contains("Ans") || part2.contains("Ans")) {
            answer="Error: Answer has no value"
            answerLabel.text=answer
            return
        }
        let part1Num = turnToNum(part1), part2Num = turnToNum(part2)
        if (part2Num==0 && operation==" ÷ ") {
            answer="Error: Divide by 0"
            answerLabel.text=answer
            return
        }
        if numberError {
            answer="Error: Invalid number"
            answerLabel.text=answer
            numberError=false
            return
        }
        
        if operation=="" && part2Num==1.0 {
            answer=String(part1Num)
        }
        else if operation==" - " {
            answer = String(part1Num-part2Num)
        }
        else if operation==" + " {
            answer = String(part1Num+part2Num)
        }
        else if operation==" × " {
            answer = String(part1Num*part2Num)
        }
        else if operation==" ÷ " {
            answer = String(part1Num/part2Num)
        }
        else if operation==" ^ " {
            answer = String(pow(part1Num, part2Num))
        }
        if Double(answer)! > Double(Int.max) {
            answer="inf"
        }
        else if (Double(answer)!).truncatingRemainder(dividingBy: 1.0)==0.0 {
            answer = String(Int(Double(answer)!))
        }
        answerLabel.text=answer
    }
    
    //Recursively turns a string into a double
    func turnToNum(_ str: String) -> Double {
        if (str.count==0) {
            return 1.0
        }
        let number = str;
        if number.prefix(1)=="-" {
            return -1 * turnToNum(String(number.suffix(number.count-1)))
        }
        if (number.contains("%")) {
            if (number=="%") {
                return 0.01
            }
            var index = 0
            for i in 1...number.count {
                if (number.prefix(i)).suffix(1)=="%" {
                    index = i
                    break
                }
            }
            return turnToNum(String(number.prefix(index-1)))/100 * turnToNum(String(number.suffix(number.count - index)))
        }
        else if (number.contains("e")) {
            if (number=="e") {
                return M_E
            }
            var index = 0
            for i in 1...number.count {
                if (number.prefix(i)).suffix(1)=="e" {
                    index = i
                    break
                }
            }
            return turnToNum(String(number.prefix(index-1))) * M_E * turnToNum(String(number.suffix(number.count - index)))
        }
        else if (number.contains("🥧")) {
            if (number=="🥧") {
                return Double.pi
            }
            var index = 0
            for i in 1...number.count {
                if (number.prefix(i)).suffix(1)=="🥧" {
                    index = i
                    break
                }
            }
            return turnToNum(String(number.prefix(index-1))) * Double.pi * turnToNum(String(number.suffix(number.count - index)))
        }
        else if (number.contains("Rand")) {
            if (number.prefix(4)=="Rand") {
                return Double(Float.random(in: 0 ..< 1))*turnToNum(String(number.suffix(number.count-4)))
            }
            var index = 0
            for i in 1...number.count-3 {
                if (number.prefix(i)).suffix(1)=="R" {
                    index = i
                    break
                }
            }
            if (index == number.count-3) {
                return turnToNum(String(number.prefix(index-1))) * Double(Float.random(in: 0 ..< 1))
            }
            return turnToNum(String(number.prefix(index-1))) * Double(Float.random(in: 0 ..< 1)) * turnToNum(String(number.suffix(number.count - index+3)))
        }
        else if (number.contains("Ans")) {
            if (number.prefix(3)=="Ans") {
                return Double(answer)!*turnToNum(String(number.suffix(number.count-3)))
            }
            var index = 0
            for i in 1...number.count {
                if (number.prefix(i)).suffix(1)=="A" {
                    index = i
                    break
                }
            }
            if (index == number.count-3) {
                return turnToNum(String(number.prefix(index-1))) * Double(answer)!
            }
            return turnToNum(String(number.prefix(index-1))) * Double(answer)! * turnToNum(String(number.suffix(number.count - index+2)))
        }
        var num=0.0
        num = Double(number) ?? -66666.66666
        if num == -66666.66666 {
            numberError=true
        }
        return num
    }
    
    // - MARK: CLR Button
    @IBAction func clearButton(_ sender: Any) {
        question = ""
        part1 = ""
        operation = ""
        part2 = ""
        turn = 1
        questionLabel.text = ""
        answerLabel.text = ""
        numberError=false
    }
    
    // - MARK: DEL Button
    @IBAction func deleteButton(_ sender: Any) {
        if turn==1 && !(part1=="") {
            if part1.suffix(3)=="Ans" {
                part1=String(part1.prefix(part1.count-3))
            }
            else if part1.suffix(4)=="Rand" {
                part1=String(part1.prefix(part1.count-4))
            }
            else {
                part1=String(part1.prefix(part1.count-1))
            }
        }
        else if turn==2 && part2=="" {
            operation = ""
            turn=1
        }
        else if turn==2 {
            if part2.suffix(3)=="Ans" {
                part2=String(part2.prefix(part2.count-3))
            }
            else if (part2.suffix(4)==("Rand")) {
                part2=String(part2.prefix(part2.count-4))
            }
            else {
                part2=String(part2.prefix(part2.count-1))
            }
        }
        question = part1+operation+part2
        questionLabel.text = part1 + operation+part2
    }
    
    // - MARK: Operations
    func updateOperation (entry: String){
        operation = " "+entry+" "
        question = part1 + operation + part2
        questionLabel.text = question
    }
    
    @IBAction func exponentButton(_ sender: Any) {
        if (turn==1) {
            updateOperation(entry: "^")
            turn=2
        }
        else {
            equalOperation()
            part2=""
            if !(answer.contains("Error:")) {
                part1=answer
                updateOperation(entry: "^")
            }
            else {
                operation=""
                turn = 1
                part1 = ""
            }
            update(entry: "")
        }
    }
    @IBAction func multiplyButton(_ sender: Any) {
        if (turn==1) {
            updateOperation(entry: "×")
            turn=2
        }
        else {
            equalOperation()
            part2=""
            if !(answer.contains("Error:")) {
                part1=answer
                updateOperation(entry: "×")
            }
            else {
                operation=""
                turn = 1
                part1 = ""
            }
            update(entry: "")
        }
    }
    @IBAction func divideButton(_ sender: Any) {
        if (turn==1) {
            updateOperation(entry: "÷")
            turn=2
        }
        else {
            equalOperation()
            part2=""
            if !(answer.contains("Error:")) {
                part1=answer
                updateOperation(entry: "÷")
            }
            else {
                operation=""
                turn = 1
                part1 = ""
            }
            update(entry: "")
        }
    }
    @IBAction func plusButton(_ sender: Any) {
        if (turn==1) {
            updateOperation(entry: "+")
            turn=2
        }
        else {
            equalOperation()
            part2=""
            if !(answer.contains("Error:")) {
                part1=answer
                updateOperation(entry: "+")
            }
            else {
                operation=""
                turn = 1
                part1 = ""
            }
            update(entry: "")
        }
    }
    @IBAction func minusButton(_ sender: Any) {
        if (turn==1) {
            updateOperation(entry: "-")
            turn=2
        }
        else {
            equalOperation()
            part2=""
            if !(answer.contains("Error:")) {
                part1=answer
                updateOperation(entry: "-")
            }
            else {
                operation=""
                turn = 1
                part1 = ""
            }
            update(entry: "")
        }
    }
    
    // - MARK: Update Question
    func update (entry: String) {
        if question.count<20 {
            if turn==1 {
                if entry=="-" {
                    if part1.prefix(1)=="-" {
                        part1=String(part1.suffix(part1.count-1))
                    }
                    else{
                        part1="-"+part1
                    }
                }
                else {
                    part1+=entry
                }
            }
            else if turn==2 {
                if entry=="-" {
                    if part2.prefix(1)=="-" {
                        part2=String(part2.suffix(part2.count-1))
                    }
                    else{
                        part2="-"+part2
                    }
                }
                else {
                    part2+=entry
                }
            }
        }
        question = part1 + operation + part2
        questionLabel.text = question
    }
    
    // - MARK: Negative Button
    @IBAction func negativeButton(_ sender: Any) {
        update(entry: "-")
    }
    
    // - MARK: period Button
    @IBAction func periodButton(_ sender: Any) {
        update(entry: ".")
    }
    
    // - MARK: %, 🥧, & e Buttons
    @IBAction func percentButton(_ sender: Any) {
        update(entry:"%")
    }
    @IBAction func pieButton(_ sender: Any) {
        update(entry:"🥧")
    }
    @IBAction func eButton(_ sender: Any) {
        update(entry:"e")
    }
    
    // - MARK: Rand & Ans Buttons
    @IBAction func randButton(_ sender: Any) {
        update(entry:"Rand")
    }
    @IBAction func ansButton(_ sender: Any) {
        update(entry:"Ans")
    }
    
    // - MARK: 0-9 Buttons
    @IBAction func zeroButton(_ sender: Any) {
        update(entry: "0")
    }
    @IBAction func oneButton(_ sender: Any) {
        update(entry: "1")
    }
    @IBAction func twoButton(_ sender: Any) {
        update(entry: "2")
    }
    @IBAction func threeButton(_ sender: Any) {
        update(entry: "3")
    }
    @IBAction func fourButton(_ sender: Any) {
        update(entry: "4")
    }
    @IBAction func fiveButton(_ sender: Any) {
        update(entry: "5")
    }
    @IBAction func sixButton(_ sender: Any) {
        update(entry: "6")
    }
    @IBAction func sevenButton(_ sender: Any) {
        update(entry: "7")
    }
    @IBAction func eightButton(_ sender: Any) {
        update(entry: "8")
    }
    @IBAction func nineButton(_ sender: Any) {
        update(entry: "9")
    }
}

