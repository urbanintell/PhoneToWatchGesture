//
//  InterfaceController.swift
//  PhoneToWatchGesture WatchKit Extension
//
//  Created by Lusenii Kromah on 9/1/16.
//  Copyright © 2016 Derivative. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var xLabel: WKInterfaceLabel!
    
    @IBOutlet var yLabel: WKInterfaceLabel!
    
    @IBOutlet var zLabel: WKInterfaceLabel!
    let motionManager = CMMotionManager()
    
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        motionManager.accelerometerUpdateInterval = 0.1
    }

    
    @IBAction func pressedBee() {
        
//        let motion = MotionKit()
        if WCSession.defaultSession().reachable == true {
            
            let requestValues = ["command" : "pressedBee"]
            let session = WCSession.defaultSession()
            
            session.sendMessage(requestValues, replyHandler: { reply in
                print("BEE ")
                }, errorHandler: { error in
                    print("error: \(error)")
            })
        }
    }
    
    @IBAction func pressedOGBee() {
        
        if WCSession.defaultSession().reachable == true {
            
            let requestValues = ["command" : "pressedOG"]
            let session = WCSession.defaultSession()
            
            session.sendMessage(requestValues, replyHandler: { reply in
                print("OG BEE")
                }, errorHandler: { error in
                    print("error: \(error)")
            })
        }
    }

  

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        
        if (motionManager.accelerometerAvailable == true) {
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: NSError?) -> Void in
                
                let requestValues = ["command":"movement","x":data!.acceleration.x,"y":data!.acceleration.y]
                let session = WCSession.defaultSession()
                session.sendMessage(requestValues as! [String : AnyObject],
                                    replyHandler: { reply in
                                      print("x:\(data!.acceleration.x)\ty:\(data!.acceleration.y)")
                    }, errorHandler: { error in
                        print("error: \(error)")
                })
                self.xLabel.setText(String(format: "%.2f", data!.acceleration.x))
                self.yLabel.setText(String(format: "%.2f", data!.acceleration.y))
                self.zLabel.setText(String(format: "%.2f", data!.acceleration.z))
            }
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: handler)
        }
        else {
            self.xLabel.setText("not available")
            self.yLabel.setText("not available")
            self.zLabel.setText("not available")
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        motionManager.stopAccelerometerUpdates()
    }

}
