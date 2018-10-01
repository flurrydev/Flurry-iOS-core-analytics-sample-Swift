//
//  SessionOriginTableViewController.swift
//  FlurryCoreAnalyticsSampleApp_Swift
//
//  Created by Yilun Xu on 10/1/18.
//  Copyright © 2018 Flurry. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK


class SessionOriginTableViewController: UITableViewController {
    
    let sSessionOriginName = "facebuk";
    let sSessionOriginWithDeeplinkName = "facebuk with a link";
    let sOriginName = "Interesting Wrapper";
    let sDeeplink = "Flurry://app/analytics";
    let sOriginVersion = "1.0.0";
    let sAlertDismissTime: Double = 0.35;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlertWithTitle(title: String, message: String?, dissmissAfter seconds: Double) -> Void {
        // set alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        if seconds <= 0 {
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
            
            alertController.addAction(dismissAction)
            alertController.dismiss(animated: true, completion: nil)
        }
        self.present(alertController, animated: true, completion: {
            if seconds > 0 {
                let delay = DispatchTime.now() + seconds
                DispatchQueue.main.asyncAfter(deadline: delay){
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
        })
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                // add session origin
                Flurry.addSessionOrigin(sSessionOriginName)
                displayAlertWithTitle(title: "session origin added", message: nil, dissmissAfter: sAlertDismissTime)
            } else if indexPath.row == 1 {
                // add session origin with deeplink
                Flurry.addSessionOrigin(sSessionOriginName, withDeepLink: sDeeplink)
                displayAlertWithTitle(title: "session origin with deeplink added", message: nil, dissmissAfter: sAlertDismissTime)
            } else {
                // set session property
                let properties = ["location":"sunnyvale"]
                Flurry .sessionProperties(properties)
                displayAlertWithTitle(title: "session properties set", message: nil, dissmissAfter: sAlertDismissTime)
            }
            break;
        case 1:
            if indexPath.row == 0 {
                //add origin with version
                Flurry.addOrigin(sOriginName, withVersion: sOriginVersion)
                displayAlertWithTitle(title: "origin with version added", message: nil, dissmissAfter: sAlertDismissTime)
            } else {
                // add origin with params and version
                let params = ["origin info key":"origin info value"]
                Flurry.addOrigin(sOriginName, withVersion: sOriginVersion, withParameters: params)
                displayAlertWithTitle(title: "origin with version and params added", message: nil, dissmissAfter: sAlertDismissTime)
            }
            break;
        default:
            break;
        }
    }
    
}
