//
//  PermissionViewModel.swift
//  MemeApp
//
//  Created by UbiiPagos on 2/6/23.
//

import Foundation
import AVFoundation
import UserNotifications
import CoreLocation

enum Permission {
    case camera
    case notification
    case location
    
    case none
}

enum PermissionError: Error {
    case noGranted
    case restricted
    case denied
    
    case none
}

//MARK: - Protocol
protocol ObservablePermissionProtocol {
    //MARK: Functions
    func askCameraPermission()
    func askNotificationPermission()
    func askLocationPermissions(locationManager: CLLocationManager?)
    
    //MARK: Observable
    var permissionResult: Observable<(Result<String, PermissionError>)> { get set }
}

//MARK: - View Model
class PermissionViewModel : NSObject, ObservablePermissionProtocol, CLLocationManagerDelegate {
    
    //MARK: Observable
    var permissionResult: Observable<(Result<String, PermissionError>)>
    
    override init(){
        self.permissionResult = Observable(.failure(.none))
    }
    
    
    //MARK: - Info
    func getPermissionInformation(permissionEnum: Permission) -> PermissionInfo? {
        switch permissionEnum {
            case .camera:
                return K.cameraPermissionInfo
            case .notification:
                return K.notificationPermissionInfo
            case .location:
                return K.locationPermissionInfo
            default:
                return nil
        }
    }
    
    //MARK: - Permissions
    func askCameraPermission(){
        let camaraPermissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch camaraPermissionStatus {
            case .authorized:
                self.permissionResult.value = .success("Success Message")
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        self.permissionResult.value = .success("Success Message")
                    }else {
                        self.permissionResult.value = .failure(.noGranted)
                    }
                })
            case .restricted:
                self.permissionResult.value = .failure(.restricted)
            case .denied:
                self.permissionResult.value = .failure(.denied)
            default:
                self.permissionResult.value = .failure(.none)
        }
    }
    
    //MARK: - Notification
    func askNotificationPermission(){
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                if granted {
                    self.permissionResult.value = .success("Success Message")
                }else {
                    self.permissionResult.value = .failure(.denied)
                }
            }
    }
    
    
    //MARK: - Location
    func askLocationPermissions(locationManager: CLLocationManager?) {
        locationManager?.delegate = self
        
        locationManager?.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways:
                self.permissionResult.value = .success("Success Message")
            case .authorizedWhenInUse:
                self.permissionResult.value = .success("Success Message")
            case .denied:
                self.permissionResult.value = .failure(.denied)
            case .notDetermined:
                self.permissionResult.value = .failure(.noGranted)
            case .restricted:
                self.permissionResult.value = .failure(.restricted)
            default:
                self.permissionResult.value = .failure(.none)
            
        }
    }
}



