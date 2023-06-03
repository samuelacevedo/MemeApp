//
//  PermissionViewModel.swift
//  MemeApp
//
//  Created by UbiiPagos on 2/6/23.
//

import Foundation
import AVFoundation

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

protocol ObservablePermissionProtocol {
    //MARK: Functions
    func cameraPermission()
    
    //MARK: Observable
    var permissionResult: Observable<(Result<String, PermissionError>)> { get set }
}

class PermissionViewModel : NSObject, ObservablePermissionProtocol {
    
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
                return K.locationPermissionInfo
            case .location:
                return K.locationPermissionInfo
            default:
                return nil
        }
    }
    
    //MARK: - Permissions
    func cameraPermission(){
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
}
