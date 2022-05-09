//
//  SettingViewController.swift
//  FlurryCoreAnalyticsSampleApp_Swift
//
//  Created by Yilun Xu on 10/1/18.
//  Copyright © 2018 Flurry. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK


class SettingViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let fileName = "/setting.plist"
    let genders = ["", "Female", "Male"]
    var path: String!
    var config: FlurryCoreConfiguration!
    var picker: UIPickerView!
    
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var enableCrashReportSwitch: UISwitch!
    @IBOutlet weak var appVersionTextField: UITextField!
    @IBOutlet weak var sessionSecondsTextField: UITextField!
    @IBOutlet weak var apiKeyTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        showDetail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // show the setting page
    func showDetail()->(Void) {
        config = FlurryCoreConfiguration.sharedInstance
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectory = paths.object(at: 0) as! NSString
        path = documentDirectory.appendingPathComponent(fileName)
        
        // show settings
        apiKeyTextField.text  = config.getValue(key: "apiKey") as? String
        appVersionTextField.text = config.getValue(key: "appVersion") as? String
        let seconds = config.getValue(key: "sessionSeconds") as? Int
        sessionSecondsTextField.text = seconds?.description
        enableCrashReportSwitch.setOn(config.getValue(key: "enableCrashReport") as! Bool, animated: true)
        
        if config.isKeyExist(key: "age") {
            ageTextField.text = config.getValue(key: "age") as? String
        }
        if config.isKeyExist(key: "gender") {
            genderTextField.text = config.getValue(key: "gender") as? String
        }
        if config.isKeyExist(key: "userId") {
            userIdTextField.text = config.getValue(key: "userId") as? String
        }
        
        // text field delegate
        appVersionTextField.delegate = self;
        apiKeyTextField.delegate = self;
        sessionSecondsTextField.delegate = self;
        ageTextField.delegate = self;
        userIdTextField.delegate = self;
        
        // picker view
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        genderTextField.inputView = picker
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func isTextFieldEmpty(fieldName: UITextField) -> Bool {
        if let text = fieldName.text, !text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func start(_ sender: Any) {
        // Required attributes when start session: apiKey, appVersion, sessionSeconds, enableCrashReport
        // Option attributes when start session: age, gender, userid
        
        // if required attributes are not empty, set new value into the plist
        if !isTextFieldEmpty(fieldName: appVersionTextField) {
            config.setValue(filePath: path, key: "appVersion", data: appVersionTextField.text as AnyObject)
        }
        if !isTextFieldEmpty(fieldName: apiKeyTextField) {
            config.setValue(filePath: path, key: "apiKey", data: apiKeyTextField.text as AnyObject)
        }
        if !isTextFieldEmpty(fieldName: sessionSecondsTextField) {
            let seconds:Int? = Int(sessionSecondsTextField.text!)
            config.setValue(filePath: path, key: "sessionSeconds", data:seconds as AnyObject)
        }
        config.setValue(filePath: path, key: "enableCrashReport", data: enableCrashReportSwitch.isOn as AnyObject)
        
        
        // set new value to optional attributes (ok if it is empty)
        if !isTextFieldEmpty(fieldName: ageTextField) {
            config.setValue(filePath: path, key: "age", data: ageTextField.text as AnyObject)
            let age = Int(ageTextField.text!)
            Flurry.set(age: Int32(truncatingIfNeeded: age!))
        } else {
            config.removeKey(filePath: path, key: "age")
        }
        
        if !isTextFieldEmpty(fieldName: genderTextField) {
            config.setValue(filePath: path, key: "gender", data: genderTextField.text as AnyObject)
            Flurry.set(gender: genderTextField.text!)
        } else {
            config.removeKey(filePath: path, key: "gender")
        }
        
        if !isTextFieldEmpty(fieldName: userIdTextField) {
            config.setValue(filePath: path, key: "userId", data: userIdTextField.text as AnyObject)
            Flurry.set(userId: userIdTextField.text)
        } else {
            config.removeKey(filePath: path, key: "userId")
        }
        
        
        // If one of the required attributes is empty, prompt an alert. If not, start session
        // The alert will ask user if they want to start session with one of the required field empty. If yes, we will use the defualt value instead.
        if (isTextFieldEmpty(fieldName: apiKeyTextField)) || (isTextFieldEmpty(fieldName: appVersionTextField)) || (isTextFieldEmpty(fieldName: sessionSecondsTextField)) {
            
            let alertController = UIAlertController(title: "Message", message: "Some non-optional text field is still empty. We will use the default value if you want to start session anyway..", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
            }
            
            let start = UIAlertAction(title: "Start", style: .default) { (action:UIAlertAction) in
                print("user press start");
                // set default value if users still leave some of the requirecd fields empty
                if self.isTextFieldEmpty(fieldName: self.apiKeyTextField) {
                    self.config.setValue(filePath: self.path, key: "apiKey", data: self.config.getDefaultValue(key: "apiKey") as AnyObject)
                    self.apiKeyTextField.text = self.config.getDefaultValue(key: "apiKey") as? String
                }
                if self.isTextFieldEmpty(fieldName: self.appVersionTextField) {
                    self.config.setValue(filePath: self.path, key: "appVersion", data: self.config.getDefaultValue(key: "appVersion") as AnyObject)
                    self.appVersionTextField.text = self.config.getDefaultValue(key: "appVersion") as? String
                }
                if self.isTextFieldEmpty(fieldName: self.sessionSecondsTextField) {
                    self.config.setValue(filePath: self.path, key: "sessionSeconds", data: self.config.getDefaultValue(key: "sessionSeconds") as AnyObject)
                    self.sessionSecondsTextField.text = self.config.getDefaultValue(key: "sessionSeconds") as? String
                }
                self.performSegue(withIdentifier: "start", sender: nil)
                self.startFlurrySession()
            }
            
            alertController.addAction(cancel)
            alertController.addAction(start)
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "start", sender: nil)
            startFlurrySession()
        }
    }
    
    // start flurry session
    func startFlurrySession() ->(Void){
        let version = config.getValue(key: "appVersion") as! String
        print (version)
        let apiKey = config.getValue(key: "apiKey") as! String
        print(apiKey)
        let enableCrashReport = config.getValue(key: "enableCrashReport") as! Bool
        print(enableCrashReport)
        let seconds = config.getValue(key: "sessionSeconds") as! Int
        let builder = FlurrySessionBuilder.init()
            .build(appVersion: version)
            .build(logLevel: .all)
            .build(crashReportingEnabled: enableCrashReport)
            .build(sessionContinueSeconds: seconds)
        Flurry.startSession(apiKey: apiKey, sessionBuilder: builder)
    }
    
    // MARK: - picker view delegate and data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    
}
