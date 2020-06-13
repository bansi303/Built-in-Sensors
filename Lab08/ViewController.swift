//
//  ViewController.swift
//  Lab08
//
//  Created by Sanif Himani on 2020-04-07.
//  Copyright © 2020 Sanif Himani. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var labelSensorDataX: UILabel!
    @IBOutlet weak var labelSensorDataY: UILabel!
    @IBOutlet weak var labelSensorDataZ: UILabel!
    @IBOutlet weak var labelPhonePositionStatus: UILabel!
    @IBOutlet weak var labelPhoneOrientation: UILabel!
    @IBOutlet weak var labelTypingOrientationStatus: UILabel!
    
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManager.deviceMotionUpdateInterval = 1
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (deviceMotion, error) in
            if let deviceMotion = deviceMotion {
                DispatchQueue.main.async {
                    self.labelSensorDataX.text = String(format: "%.4f", deviceMotion.gravity.x)
                    self.labelSensorDataY.text = String(format: "%.4f", deviceMotion.gravity.y)
                    self.labelSensorDataZ.text = String(format: "%.4f", deviceMotion.gravity.z)
                }
                self.detectPickup(userAcceleration: deviceMotion.userAcceleration)
                self.detectOrientation(gravity: deviceMotion.gravity)
                self.detectTyping(gravity: deviceMotion.gravity)
            }
        }
    }
    
    func detectPickup(userAcceleration: CMAcceleration) {
        let userAccelerationX: Double = userAcceleration.x
        let userAccelerationY: Double = userAcceleration.y
        let userAccelerationZ: Double = userAcceleration.z
        
        let magnitude = (pow(userAccelerationX, 2) + pow(userAccelerationY, 2) + pow(userAccelerationZ, 2)) * 100
        if(magnitude > 1.0) {
            labelPhonePositionStatus.text = "Phone Picked Up"
            labelPhonePositionStatus.backgroundColor = UIColor.red
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showPhoneStatus), userInfo: nil, repeats: false)
        }
    }
    
    func detectOrientation(gravity: CMAcceleration) {
        let gravityX: Double = gravity.x
        let gravityY: Double = gravity.y
        let gravityZ: Double = gravity.z
        
        switch true {
        case gravityY < 0 && abs(gravityY) > abs(gravityZ) && abs(gravityY) > abs(gravityX): labelPhoneOrientation.text = "Portrait"
        case gravityY > 0 && abs(gravityY) > abs(gravityZ) && abs(gravityY) > abs(gravityX): labelPhoneOrientation.text = "Portrait Upside Down"
        case gravityX > 0 && abs(gravityX) > abs(gravityY) && abs(gravityX) > abs(gravityZ): labelPhoneOrientation.text = "Landscape right"
        case gravityX < 0 && abs(gravityX) > abs(gravityY) && abs(gravityX) > abs(gravityZ): labelPhoneOrientation.text = "Landscape Left"
        case gravityZ < 0 && abs(gravityZ) > abs(gravityY) && abs(gravityZ) > abs(gravityX): labelPhoneOrientation.text = "Faced Up"
        case gravityZ > 0 && abs(gravityZ) > abs(gravityY) && abs(gravityZ) > abs(gravityX): labelPhoneOrientation.text = "Faced Down"
        default: labelPhoneOrientation.text = "Couldn't determine orientation"
        }
    }
    
    func detectTyping(gravity: CMAcceleration) {
        let gravityX: Double = gravity.x
        let gravityY: Double = gravity.y
        let gravityZ: Double = gravity.z
        
        switch true {
        case abs(gravityY) > 0.4 && abs(gravityZ) > 0.7: labelTypingOrientationStatus.text = "Typing!"
        case abs(gravityX) > 0.4 && abs(gravityZ) > 0.7: labelTypingOrientationStatus.text = "Typing!"
        default: labelTypingOrientationStatus.text = "Not Typing"
        }
    }
    
    @objc func showPhoneStatus() {
        labelPhonePositionStatus.text = "IDLE"
        labelPhonePositionStatus.backgroundColor = #colorLiteral(red: 0.4460462332, green: 0.6765121818, blue: 0.3005098701, alpha: 1)
    }
}
