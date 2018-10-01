//
//  InfoTableViewController.swift
//  FlurryCoreAnalyticsSampleApp_Swift
//
//  Created by Yilun Xu on 10/1/18.
//  Copyright © 2018 Flurry. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class InfoTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let fileName = "/setting.plist"
    let genders = ["", "Female", "Male"]
    var path: String!
    var config: FlurryCoreConfiguration!
    var picker: UIPickerView!
    
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config = FlurryCoreConfiguration.sharedInstance
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectory = paths.object(at: 0) as! NSString
        path = documentDirectory.appendingPathComponent(fileName)
        
        // show info
        if config.isKeyExist(key: "age") {
            ageTextField.text = config.getValue(key: "age") as? String
        }
        if config.isKeyExist(key: "gender") {
            genderTextField.text = config.getValue(key: "gender") as? String
        }
        if config.isKeyExist(key: "userId") {
            userIdTextField.text = config.getValue(key: "userId") as? String
        }
        
        // set textfield delegate
        ageTextField.delegate = self;
        userIdTextField.delegate = self;
        
        // set picker
        picker = UIPickerView.init()
        picker.delegate = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = true;
        genderTextField.inputView = picker;
        
    }
    
    @IBAction func save(_ sender: Any) {
        if !isTextFieldEmpty(fieldName: ageTextField) {
            config.setValue(filePath: path, key: "age", data: ageTextField.text as AnyObject)
            let age = Int(ageTextField.text!)
            Flurry.setAge(Int32(truncatingIfNeeded: age!))
        } else {
            config.removeKey(filePath: path, key: "age")
        }
        
        if !isTextFieldEmpty(fieldName: genderTextField) {
            config.setValue(filePath: path, key: "gender", data: genderTextField.text as AnyObject)
            Flurry.setGender(genderTextField.text!)
        } else {
            config.removeKey(filePath: path, key: "gender")
        }
        
        if !isTextFieldEmpty(fieldName: userIdTextField) {
            config.setValue(filePath: path, key: "userId", data: userIdTextField.text as AnyObject)
            Flurry.setUserID(userIdTextField.text)
        } else {
            config.removeKey(filePath: path, key: "userId")
        }
        // the alert view
        let alert = UIAlertController(title: "Success", message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func isTextFieldEmpty(fieldName: UITextField) -> Bool {
        if let text = fieldName.text, !text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: picker view delegate and data source
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
    
    // MARK: text field delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
}

