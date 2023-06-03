//
//  K.swift
//  MemeApp
//
//  Created by UbiiPagos on 2/6/23.
//

import Foundation
import UIKit

struct K {
    //MARK: - Info
    static let cameraPermissionInfo: PermissionInfo =
        PermissionInfo(title: "Camera Access", description: "Please allow access to your\ncamera to take photos", iconName: "CameraIcon")
    static let notificationPermissionInfo: PermissionInfo =
        PermissionInfo(title: "Enable push notifications", description: "Enable push notifications to let\nsend you personal news and\nupdates.", iconName: "NotificationIcon")
    static let locationPermissionInfo: PermissionInfo =
        PermissionInfo(title: "Enable location services", description: "We wants to access your location\nonly to provide a better experience\nby helping you find new friends\nnearby.", iconName: "LocationIcon")
    
    //MARK: - Colors
    static let firstGradientColor: UIColor = UIColor(red: 1, green: 137/255, blue: 96/255, alpha: 1.0)
    static let secondGradientColor: UIColor = UIColor(red: 254/255, green: 98/255, blue: 165/255, alpha: 1.0)
    
}
