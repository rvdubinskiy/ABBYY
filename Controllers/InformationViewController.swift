//
//  MainViewController.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 5/31/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    private var notes: Note?
    var flag: Bool = false
    var taskInfo = TaskInfo()
    var userKey = UserKey()
    var indexOfCurrentElement: Int = 0
    
    
    convenience init(with parameters: Note, index: String) {
        self.init()
        
        indexOfCurrentElement = Int(index)!
        self.notes = parameters
    
        
        
        setupNavigationItems()
        setupdefaultSettings()
        setupDates()
        setupCreateView()
        createStatusPicker()
        createToolBar()
    }
    
    func setupNavigationItems() {
        title = "Information"
        
        self.view.backgroundColor = UIColor.white
        let editButton = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(beginEditing))
        
        navigationItem.rightBarButtonItems = [editButton]
        self.toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                             UIBarButtonItem.init(title: "by Roman", style: .plain, target: self, action: nil),
                             UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)]

    }
    
    func setupdefaultSettings() {
        taskInfo.nameOfTask.textColor = UIColor.gray
        taskInfo.comment.textColor = UIColor.gray
        taskInfo.createButton.isHidden = true
        taskInfo.comment.isEditable = false
        
        taskInfo.nameOfTask.delegate = self
        taskInfo.comment.delegate = self
    }
    
    // button "Done" which changed status after click on it
    @objc func finishTask() {
        
        let alertController = UIAlertController(title: "Attention", message: "Are you really want to finish completing task?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            var index = UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.object(forKey: self.userKey.key) as? [[String]]
            
            index![self.indexOfCurrentElement][4] = "2"
            UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.set(index, forKey: self.userKey.key)
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
        

    }
    
    // navigation button "Edit" for editing task
    @objc func beginEditing() {
        taskInfo.nameOfTask.textColor = UIColor.black
        taskInfo.comment.textColor = UIColor.black
        taskInfo.comment.isEditable = true
        flag = true
        
        buttonSettings()
    }
    
    // save button settings
    func buttonSettings() {
        let button = taskInfo.createButton
        button.isHidden = false
        button.backgroundColor = UIColor.gray
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(changeDates), for: .touchUpInside)
        
    }
    
    // save all dates after editing
    @objc func changeDates() {
    
        var index = UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.object(forKey: userKey.key) as? [[String]]
        index![indexOfCurrentElement][1] = taskInfo.nameOfTask.text ?? "Default"
        index![indexOfCurrentElement][2] = (taskInfo.comment.text! as NSString) as String
        
        if taskInfo.statusFiels.text == "Status: new" {
            index![indexOfCurrentElement][4] = "0"
        } else if taskInfo.statusFiels.text == "Status: in the process" {
            index![indexOfCurrentElement][4] = "1"
        } else if taskInfo.statusFiels.text == "Status: done" {
            index![indexOfCurrentElement][4] = "2"
        } else {
            index![indexOfCurrentElement][4] = "0"
        }
        
        UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.set(index, forKey: userKey.key)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // set up all dated
    func setupDates() {
        taskInfo.nameOfTask.text = notes?.nameOfTask
        taskInfo.comment.text = notes?.comments
    }
    
    func setupCreateView() {
        self.view.addSubview(taskInfo.nameOfTask)
        self.view.addSubview(taskInfo.comment)
        self.view.addSubview(taskInfo.createButton)
        self.view.addSubview(taskInfo.statusFiels)
        taskInfo.nameOfTask.delegate = self
        
        setupConstraints()
    }
    
    func setupConstraints() {
        taskInfo.nameOfTask.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        taskInfo.nameOfTask.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        taskInfo.nameOfTask.heightAnchor.constraint(equalToConstant: 50).isActive = true
        taskInfo.nameOfTask.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        //setup comments
        taskInfo.comment.topAnchor.constraint(equalTo: self.taskInfo.nameOfTask.bottomAnchor).isActive = true
        taskInfo.comment.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        taskInfo.comment.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        taskInfo.comment.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 2/5).isActive = true
        
        
        // setup status button
        taskInfo.statusFiels.topAnchor.constraint(equalTo: self.taskInfo.comment.bottomAnchor).isActive = true
        taskInfo.statusFiels.heightAnchor.constraint(equalToConstant: 30).isActive = true
        taskInfo.statusFiels.widthAnchor.constraint(equalToConstant: 200).isActive = true
        taskInfo.statusFiels.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //setup button - create task
        taskInfo.createButton.topAnchor.constraint(equalTo: self.taskInfo.statusFiels.bottomAnchor, constant: 20).isActive = true
        taskInfo.createButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        taskInfo.createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        taskInfo.createButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if flag {
            return true
        } else {
            return false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        taskInfo.comment.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = taskInfo.nameOfTask.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 30
    }
    
    // restrictions
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = taskInfo.comment.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return changedText.count <= 500
    }
    func textViewShouldReturn(textView: UITextView!) -> Bool {
        self.view.endEditing(true);
        return true;
    }
    
    ///////
    let statuses = ["new",
                    "in the process",
                    "done"]
    
    var selectedStatus: String?
    
    func createStatusPicker() {
        var statusPicker = UIPickerView()
        statusPicker.delegate = self
        
        taskInfo.statusFiels.inputView = statusPicker
    }
    @objc func dismissKeyboard()
    {
        taskInfo.statusFiels.endEditing(true)
    }
    
    func createToolBar() {
        var toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(InformationViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        taskInfo.statusFiels.inputAccessoryView = toolBar
        buttonSettings()
        
    }
    
    
    
}

extension InformationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statuses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statuses[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStatus = statuses[row]
        
        taskInfo.statusFiels.text = "Status: \(selectedStatus!)"
    }
    
}
