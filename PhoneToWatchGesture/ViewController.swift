//
//  ViewController.swift
//  PhoneToWatchGesture
//
//  Created by Lusenii Kromah on 9/1/16.
//  Copyright © 2016 Derivative. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var imageView:UIImageView!
    
  
    var recognizer:UIPanGestureRecognizer!
    
    
    @IBOutlet weak var beeImage: UIImageView!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!

    @IBOutlet weak var beeXValue: UILabel!
    @IBOutlet weak var beeYValue: UILabel!
    
    @IBAction func refresh(sender: UIButton) {
        refresh()
    }
    
    
    func refresh(){
        beeImage.frame = CGRect(x:view.center.x,y:view.center.y,width:100,height:100)
        view.addSubview(beeImage)
    }
    
    
    func moveButton(moveX:Double,moveY:Double){
        
        
        var x = Double(beeImage.center.x) + moveX
        var y = Double(beeImage.center.y) + moveY
        
        if ( beeImage.center.x  > 0 &&  beeImage.center.y > 0 && beeImage.center.x < view.bounds.size.width-100 && beeImage.center.y < view.bounds.size.height-100 ){
        
            beeImage.center = CGPointMake(CGFloat(x), CGFloat(y))
          
        }else {
            beeImage.center.x -= CGFloat(moveX)
            beeImage.center.y -= CGFloat(moveY)

        }
    
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      beeImage.frame = CGRect(x:view.center.x,y:view.center.y,width:100,height:100)
        
        recognizer = UIPanGestureRecognizer(target: self, action:#selector(ViewController.handleTap(_:)))
//        
        recognizer.delegate = self
        beeImage.addGestureRecognizer(recognizer)
        beeImage.userInteractionEnabled = true
        view.clipsToBounds = true
        beeImage.clipsToBounds = true
        beeImage.frame = self.view.bounds
        
    }
    
    func handleTap(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
            
            
        }
        
        
        print("x:\(beeImage.center.x)")
        print("y:\(beeImage.center.y)")
        
        recognizer.setTranslation(CGPointZero, inView: self.view)
        
        
        if recognizer.state == UIGestureRecognizerState.Ended {
            // 1
            let velocity = recognizer.velocityInView(self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
          
            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:beeImage.center.x + (velocity.x * slideFactor),
                                     y:beeImage.center.y + (velocity.y * slideFactor))
            // 4
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width-100)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height-100)
            
            // 5
            UIView.animateWithDuration(Double(slideFactor * 2),
                                       delay: 0,
                                       // 6
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {recognizer.view!.center = finalPoint },
                completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addImage(tag:Int){
        var image:UIImage?
        
        switch tag {
        case 100:
           
                image = UIImage(named:"bee")
        
            
            
        case 200:
    
                image = UIImage(named:"ogbee")  
            
        default:
            break
        }
        
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:view.center.x,y:view.center.y,width:100,height:100)

        view.addSubview(imageView)
        
        imageView.addGestureRecognizer(recognizer)
        imageView.userInteractionEnabled = true
        
    }
    
    func coordinates(x:Double,y:Double){
        xLabel.text = String(format:"%.2f",x)
        yLabel.text = String(format:"%.2f",y)
        print("x:\(x)\ty:\(y)")
    }
}

