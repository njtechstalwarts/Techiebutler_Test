//
//  Common.swift
//  Techiebutler_Test
//
//  Created by techstalwarts on 26/04/24.
//

import Foundation
import UIKit
import ProgressHUD

class Common {
    
    static let shared = Common()
    var alertController: UIAlertController?
    var viewController: UIViewController?
    
    private init() { }
    
    func showAlert(title: String, message: String, vc: UIViewController) {

        GCDHelper.delay(0.5) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    func showHUD() {
        ProgressHUD.animate("Fetching data...", .circlePulseMultiple)
    }
    
    func hideHUD() {
        ProgressHUD.dismiss()
    }
    
}
