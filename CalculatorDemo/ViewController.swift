//
//  ViewController.swift
//  CalculatorDemo
//
//  Created by Frank on 2016/9/25.
//  Copyright © 2016年 frankc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var btnSound: AVAudioPlayer!
    
    enum Operation: String{
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
        case Clear = "Clear"
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    @IBOutlet weak var outputLbl: UILabel!
    @IBAction func onDividePressed(_ sender: UIButton) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(_ sender: UIButton) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(_ sender: UIButton) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(_ sender: UIButton) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(_ sender: UIButton) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func onClearPressed(_ sender: UIButton) {
        playSound()
        currentOperation = Operation.Empty
        runningNumber = "" //User is inputting number
        leftValStr = ""  //The first input
        rightValStr = "" //The next input
        result = ""
        outputLbl.text = "0"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do{
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        playSound()
        if sender.tag != 0 || outputLbl.text != "0" {
            runningNumber += "\(sender.tag)"
            outputLbl.text = runningNumber
        }
    }
    
    func playSound(){
        if btnSound.isPlaying{
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            //A user selected an operator, but then selected another operator without first entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract{
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                leftValStr = result
                outputLbl.text = result
            }
            currentOperation = operation
        } else {
            if runningNumber != ""{
                //This is the first time an operator has been pressed
                leftValStr = runningNumber
                runningNumber = ""
                currentOperation = operation
            }
        }
    }
}










