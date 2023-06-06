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
                            self.nextViewController()
                        }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                if error != .none {
                                    self.nextViewController()
                                }
                            }
                    }
                }
            case .notification:
                viewModel?.askNotificationPermission()
                viewModel?.permissionResult.bind { (respond) in
                    switch respond {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.nextViewController()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            if error != .none {
                                self.nextViewController()
                            }
                        }
                    }
                }
            case .location:
                viewModel?.askLocationPermissions(locationManager: locationManager)
                viewModel?.permissionResult.bind { (respond) in
                    switch respond {
                        case .success(_):
                            DispatchQueue.main.async {
                                self.viewModel?.changeRootViewController()
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                if error != .none {
                                    self.viewModel?.changeRootViewController()
                                }
                            }
                    }
                }
            case .none :
                print("none")
        }
    }
    
    private func nextViewController() {
        if let vc = self.viewModel?.getNextViewController(permissionEnum: self.permissionEnum) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Cancel
    @IBAction func cancelButtonAction(_ sender: Any) {
        switch permissionEnum {
            case .camera:
                self.nextViewController()
            case .notification:
                self.nextViewController()
            case .location:
                self.viewModel?.changeRootViewController()
            case .none:
                print("none")
        }
    }
    
}
