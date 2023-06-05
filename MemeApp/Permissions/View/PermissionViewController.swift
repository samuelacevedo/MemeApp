//
//  PermissionViewController.swift
//  MemeApp
//
//  Created by UbiiPagos on 1/6/23.
//

import UIKit
import CoreLocation

class PermissionViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var allowButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    //MARK: Permission
    var permissionEnum: Permission = .camera
    
    //MARK: View Model
    var viewModel: PermissionViewModel?
    
    var locationManager: CLLocationManager?
    
    //MARK: - View Did Layout Subviews
    override func viewDidLayoutSubviews() {
        allowButton.ubiiCardButtonGradient(colours: [K.firstGradientColor, K.secondGradientColor], cornerMultiplier: 0.5)
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: View Model
        viewModel = PermissionViewModel()
        
        //MARK: Setup Info
        if let permissionInfo = viewModel?.getPermissionInformation(permissionEnum: permissionEnum) {
            if let image = UIImage(named: permissionInfo.iconName) {
                iconImageView.image = image
            }
            titleLabel.text = permissionInfo.title
            descriptionLabel.text = permissionInfo.description
            
            if permissionEnum == .location {
                locationManager = CLLocationManager()
            }
        }
    }
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .clear
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.backItem?.title = " "
        self.navigationItem.title = " "
    }
    
    //MARK: - Allow
    @IBAction func allowButtonAction(_ sender: Any) {
        switch permissionEnum {
            case .camera:
                viewModel?.askCameraPermission()
                viewModel?.permissionResult.bind { (respond) in
                    switch respond {
                        case .success(_):
                        DispatchQueue.main.async {
                            if let vc = UIStoryboard(name: "Permissions", bundle: nil).instantiateViewController(withIdentifier: "PermissionVC") as? PermissionViewController {
                                vc.permissionEnum = .notification
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            case .notification:
                viewModel?.askNotificationPermission()
                viewModel?.permissionResult.bind { (respond) in
                    switch respond {
                    case .success(_):
                        DispatchQueue.main.async {
                            if let vc = UIStoryboard(name: "Permissions", bundle: nil).instantiateViewController(withIdentifier: "PermissionVC") as? PermissionViewController {
                                vc.permissionEnum = .location
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .location:
                viewModel?.askLocationPermissions(locationManager: locationManager)
                viewModel?.permissionResult.bind { (respond) in
                    switch respond {
                        case .success(_):
                            DispatchQueue.main.async {
                                //MARK: Set Finish Permission & User Defaults
                                let defaults = UserDefaults.standard
                                defaults.set(true, forKey: "permissions")
                                
                                //MARK: Change RootViewController To Home
                                let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                                if let home = homeStoryboard.instantiateViewController(withIdentifier: "HomeNavController") as? UINavigationController {
                                    if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                        scene.changeRootViewController(home)
                                    }
                                }
                            }
                        case .failure(let error):
                            print(error)
                            print(error.hashValue)
                            print(error.localizedDescription)
                    }
                    
                }
            case .none :
                print("none")
        }
    }
    
    //MARK: - Cancel
    @IBAction func cancelButtonAction(_ sender: Any) {
        
    }
    
}
