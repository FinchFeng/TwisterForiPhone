//
//  TwisterModel.swift
//  Twister
//
//  Created by 冯奕琦 on 2017/6/27.
//  Copyright © 2017年 冯奕琦. All rights reserved.
//

import Foundation


enum circleColor{
    case red,blue,yellow,green
}

enum body{
    case lefthand,righthand,leftfoot,rightfoot
}

protocol CountingDelegate {
    
    var counter:Int { get set }
    var displayColor:Bool{get set}
    var displayBody:Bool{get set}
    
    
    
}


class TwisterModel{

    //MARK: screen values
    var currentColor:circleColor = .red{
        didSet{
            delegate.displayColor = true
        }
    }
    var currentBody:body = .leftfoot{
        didSet{
            delegate.displayBody = true
        }
    }
    var isWorking = false
    
    //viod class to be set
    var delegate:CountingDelegate!
    
    
    //MARK: Timer Values
    
    let minTimeGap = 3
    let maxTimeGap = 10
    
    var timer :Timer!
    var gapTime = 10 {
        didSet{
            countDown = gapTime
        }
    }
    var countDown = 10{
        didSet{
            delegate.counter = countDown
        }
    }
    
    func start() {
        
        //makeATimer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(rock), userInfo: nil, repeats: true)
    
        
    }
    
    func reset()  {
        
        timer.invalidate()
        countDown = gapTime
    }
    
    //timer's selector methol
    @objc func rock() {
        //count the second
        countDown = countDown - 1
        
        //rockOrNot
        if countDown == 0  {
            
            currentBody = getRandomBody()
            currentColor = getRandomColor()

            //resetCountDown
            countDown = gapTime
            
        }
        
        
        
    }
    //更改时间函数
    func changeTimeGap() {
        
        if gapTime > minTimeGap {
            gapTime = gapTime - 1
        }else{
            gapTime = maxTimeGap
        }
    }
    
    //随机获取方法
    
    func getRandomColor() -> circleColor {
        
        let randomInt = Int(arc4random()%4)+1
        
        switch randomInt {
        case 1:
            return circleColor.blue
        case 2:
            return circleColor.green
        case 3:
            return circleColor.red
        default:
            return circleColor.yellow
        }
    }
    
    func getRandomBody() -> body {
        
        let randomInt = Int(arc4random()%4)+1
        
        switch randomInt {
        case 1:
            return body.leftfoot
        case 2:
            return body.lefthand
        case 3:
            return body.rightfoot
        default:
            return body.righthand
        }

    }
    
    //
    
    
    
    
    
}
