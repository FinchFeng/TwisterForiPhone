//
//  ViewController.swift
//  Twister
//
//  Created by 冯奕琦 on 2017/6/20.
//  Copyright © 2017年 冯奕琦. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,CountingDelegate {

    //talking properity
    let speechSynthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resultDisplay: UIImageView!
    @IBOutlet weak var timerDisplay: UIImageView!
    @IBOutlet weak var BodyDisplay: UIImageView!
    @IBOutlet weak var timeDisplayLabel: UILabel!
    @IBOutlet weak var buttonDisplay: UIImageView!

    let twister = TwisterModel()
    
    //MARK: delegate from the model
    
    var counter: Int = 0 {
        didSet{
            timeDisplayLabel.text = String(counter)+" s"
            if twister.isWorking{
                speak(Out: counter)
            }
            print(counter)
        }
    }
    
    var displayColor:Bool = false {
        didSet{
            displayColor = false
            
            
            resultDisplay.image = getImageOf(color: twister.currentColor)
            timerDisplay.image = getImageOf(color: twister.currentColor)
            buttonDisplay.image = getImageOf(color: twister.currentColor)
            playAnimation(on: resultDisplay,timerDisplay,buttonDisplay, isCircleTrue: true)
            print("Color! : ",twister.currentColor)
        }
    }
    
    var displayBody:Bool = false{
        didSet{
            displayBody = false
            //先设定值再播动画
            BodyDisplay.image = getImageOf(body: twister.currentBody)
            print("Body! : ",twister.currentBody)
            playAnimation(on: BodyDisplay, isCircleTrue: false)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the delegate
        twister.delegate = self
        
        
    }
    
    @IBAction func changeTime() {
        //判断是否在运行
        if !twister.isWorking {
            twister.changeTimeGap()
        }
        
    }
    

    @IBAction func powerButtom(_ sender: UIButton) {
        //start or stop the twister
        if twister.isWorking {
            twister.isWorking = false
            twister.reset()
            //change words
            startButton.setTitle("Start", for: .normal)
        }else{
            twister.isWorking = true
            twister.start()
            //change words
            startButton.setTitle("Reset", for: .normal)
            view.backgroundColor = UIColor.white
        }
       
    }
    
    
    func getImageOf(body:body) -> UIImage {
        
        switch body {
        case .leftfoot:
            return #imageLiteral(resourceName: "LEFT FOOT ")
        case .rightfoot:
            return #imageLiteral(resourceName: "RIGHT FOOT")
        case .lefthand:
            return #imageLiteral(resourceName: " LEFT HAND")
        case .righthand:
            return #imageLiteral(resourceName: " RIGHT HAND")
        }
    }
    
    func getImageOf(color:circleColor) -> UIImage {
        switch color {
        case .blue:
            return #imageLiteral(resourceName: "blueCircle")
        case .green:
            return #imageLiteral(resourceName: "greenCircle")
        case .red:
            return #imageLiteral(resourceName: "redCircle")
        case .yellow:
            return #imageLiteral(resourceName: "yellowCircle")
        }
    }
    
    //播放动画
    
    func playAnimation(on ImageviewArray:UIImageView...,isCircleTrue:Bool ) {
        
        
        func creatARandomArray()-> [Int]{
            
            var result = [Int]()
            
            func thisNumberNeverAppend(_ newNumber : Int) -> Bool{
                for numbers in result{
                    if numbers == newNumber {
                        return false
                    }
                }
                return true
            }
            
            while result.count < 4 {
                let newNumber = Int(arc4random()%6)+1
                if thisNumberNeverAppend(newNumber) {
                    result.append(newNumber)
                }
            }
            
            return result
        }
        
        
        func creatAImageArray(_ numberArray :[Int])->[UIImage] {
            var  imageArray = [UIImage]()
            
            if isCircleTrue {
                for number in numberArray {
                    switch number {
                    case 1:
                        imageArray.append(#imageLiteral(resourceName: "blueCircle"))
                    case 2:
                        imageArray.append(#imageLiteral(resourceName: "yellowCircle"))
                    case 3:
                        imageArray.append(#imageLiteral(resourceName: "greenCircle"))
                    case 4:
                        imageArray.append(#imageLiteral(resourceName: "redCircle"))
                    default:
                        break
                    }
                    
                }
            }else{
                for number in numberArray {
                    
                    switch number {
                    case 1:
                        imageArray.append(#imageLiteral(resourceName: "LEFT FOOT "))
                    case 2:
                        imageArray.append(#imageLiteral(resourceName: "RIGHT FOOT"))
                    case 3:
                        imageArray.append(#imageLiteral(resourceName: " LEFT HAND"))
                    case 4:
                        imageArray.append(#imageLiteral(resourceName: " RIGHT HAND"))
                    default:
                        break
                    }
                    
                }
            }
            return imageArray
        }
        
        let randomImageArray = creatAImageArray(creatARandomArray())
        
        //配置所有传入的ImageView
        for Imageview in ImageviewArray{
            
            Imageview.animationImages = randomImageArray
            Imageview.animationRepeatCount = 1
            Imageview.animationDuration = 0.6
            Imageview.startAnimating()
        }
    }
    
    //speak feature
    
    func soundMark(Of number:Int) -> String {
        
        switch number {
        case 1:
            return "wun"
        case 2:
            return "tu"
        case 3:
            return "θri:"
        case 4:
            return "for"
        case 5:
            return "faɪv:"
        case 6:
            return "siks"
        case 7:
            return "'sevən"
        case 8:
            return "eit"
        case 9:
            return "naɪn"
        case 10:
            return "ten"
        default:
            return "tʃendʒ"
        }
    }
    
    func speak(Out number:Int){
        if speechSynthesizer.isSpeaking{
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        let mark = AVSpeechUtterance(string: soundMark(Of: number))
        mark.rate = AVSpeechUtteranceDefaultSpeechRate
        mark.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        speechSynthesizer.speak(mark)
    }


}


