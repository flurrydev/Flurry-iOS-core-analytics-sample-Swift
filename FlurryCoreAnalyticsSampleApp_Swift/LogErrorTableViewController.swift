//
//  LogErrorTableViewController.swift
//  FlurryCoreAnalyticsSampleApp_Swift
//
//  Created by Yilun Xu on 10/1/18.
//  Copyright © 2018 Flurry. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class LogErrorTableViewController: UITableViewController {
    
    let sLogException = "sample log exception";
    let sLogExceptionName = "sample log exception name";
    let sLogError = "sample log error";
    let sLogExceptionWithTags = "sample log exception with tags";
    let sLogExceptionWithTagsName = "sample log exception with tags name";
    let sLogErrorWithTags = "sample log error with tags";
    let sFlurryAppDomain = "sample flurry app domain";
    let sEventsExcetpionName = "sample events excetpion name";
    let sBreadcrumbsInfo = "sample breadcrumbs info";
    let sAlertDismissTime: Double = 0.35
    
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
        if indexPath.row == 0 {
            // log exception
            let exception = NSException.init(name: NSExceptionName.init(rawValue: sLogException), reason: "sample reason", userInfo: nil)
            Flurry.log(errorId: sLogException, message: "log with exception message", exception: exception)
            displayAlertWithTitle(title: "Log Exception", message: nil, dissmissAfter: sAlertDismissTime)
        } else if indexPath.row == 1 {
            // log error
            let error = NSError.init(domain: sFlurryAppDomain, code: 42, userInfo: nil)
            Flurry.log(errorId: sLogError, message: nil, error: error)
            displayAlertWithTitle(title: "Log Error", message: nil, dissmissAfter: sAlertDismissTime)
        } else if indexPath.row == 2 {
            // log error with tags
            let error = NSError.init(domain: sFlurryAppDomain, code: 42, userInfo: nil)
            let errorTags = ["location" : "not valid"]
            Flurry.log(errorId: sLogErrorWithTags, message: "log error with tags", error: error, parameters: errorTags)
            displayAlertWithTitle(title: "log error with tags", message: nil, dissmissAfter: sAlertDismissTime)
        } else if indexPath.row == 3 {
            // log exception with tags
            let exception = NSException.init(name: NSExceptionName(rawValue: sLogExceptionWithTags), reason: "sample reason", userInfo: nil)
            let exceptionTags = ["appVersion" : "3.2"]
            Flurry.log(errorId: "log exception with tags", message: nil, exception: exception, parameters: exceptionTags)
            
            displayAlertWithTitle(title: "Log exception with tags", message: nil, dissmissAfter: sAlertDismissTime)
        } else if indexPath.row == 4 {
            // leave breadcrumbs
            Flurry.leaveBreadcrumb(sBreadcrumbsInfo)
            displayAlertWithTitle(title: "web view not loading", message: nil, dissmissAfter: sAlertDismissTime)
        } else {
            // crash
            fatalError()
        }
    }
}
