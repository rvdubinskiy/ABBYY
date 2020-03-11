//
//  CreatTaskViewViewController.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 5/26/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit
import CoreData

class CreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var taskInfo = TaskInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainSettingsOfWindow()
        taskInfo.createButton.addTarget(self, action: #selector(createData), for: .touchUpInside)
        setupCreateView()
    }
    
    func mainSettingsOfWindow() {
        
        title = "Create"
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.backgroundColor = UIColor.white
    }

    // get string with hours, minutes and seconds
    func GetTimeString(date: Date) -> String {
        let calendar = Calendar.current
        var hour = String()
        var minutes = String()
        var seconds = String()
        
        // get hours
        if calendar.component(.hour, from: date) < 10 {
            hour = "0" + "\(calendar.component(.hour, from: date))"
        } else {
            hour = "\(calendar.component(.hour, from: date))"
        }
        // get minutes
        if calendar.component(.minute, from: date) < 10 {
            minutes = "0" + "\(calendar.component(.minute, from: date))"
        } else {
            minutes = "\(calendar.component(.minute, from: date))"
        }
        // get seconds
        if calendar.component(.second, from: date) < 10 {
            seconds = "0" + "\(calendar.component(.second, from: date))"
        }else {
            seconds = "\(calendar.component(.second, from: date))"
        }
        let time = "\(hour):\(minutes):\(seconds)"
        return time
    }
    
    // set up main view and also subviews
    func setupCreateView() {
        self.view.addSubview(taskInfo.nameOfTask)
        self.view.addSubview(taskInfo.comment)
        self.view.addSubview(taskInfo.createButton)
        taskInfo.nameOfTask.delegate = self
        taskInfo.comment.delegate = self
        
        setupConstraints()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        taskInfo.comment.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func setupConstraints() {
        // set up name of task
        taskInfo.nameOfTask.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        taskInfo.nameOfTask.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        taskInfo.nameOfTask.heightAnchor.constraint(equalToConstant: 50).isActive = true
        taskInfo.nameOfTask.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        //setup comments
        taskInfo.comment.topAnchor.constraint(equalTo: self.taskInfo.nameOfTask.bottomAnchor).isActive = true
        taskInfo.comment.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        taskInfo.comment.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -30).isActive = true
        taskInfo.comment.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        //setup button - create task
        taskInfo.createButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        taskInfo.createButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        taskInfo.createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        taskInfo.createButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = taskInfo.nameOfTask.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 25
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
        
        return true
    }
    func textViewShouldReturn(textView: UITextView!) -> Bool {
        self.view.endEditing(true);
        return true;
    }
//    create data in core data 
    @objc func createData() {
        let date = Date()
        let time = GetTimeString(date: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDateString: String = dateFormatter.string(from: date)
        
        let arrayCom = taskInfo.comment.text! as NSString
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return;
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext;
        guard let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else { return; };
        
        let task = NSManagedObject(entity: taskEntity, insertInto: managedContext);
        task.setValue(taskInfo.nameOfTask.text!, forKeyPath: "name");
        task.setValue(arrayCom as String, forKey: "comments");
        task.setValue(currentDateString as String, forKey: "current_date");
        task.setValue(retrieveData() - 1, forKey: "id");
        task.setValue("0", forKey: "status");
        task.setValue("\(time)", forKey: "time");
        
        do {
            try managedContext.save();
            navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)");
        }
    }
    
    func retrieveData() -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result.count;
        } catch {
            
            print("Failed")
        }
        return 0;
    }
}
