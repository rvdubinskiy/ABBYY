//
//  CreatTaskViewViewController.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 5/26/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var taskInfo = TaskInfo()
    var userKey = UserKey()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainSettingsOfWindow()
        taskInfo.createButton.addTarget(self, action: #selector(createNewTask), for: .touchUpInside)
        setupCreateView()
    }
    
    func mainSettingsOfWindow() {
        
        title = "Create"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.backgroundColor = UIColor.white
    }
    
    // action after click on Create task button
    @objc func createNewTask() {
        let date = Date()
        let time = GetTimeString(date: date)
        var arrayEl = [[String]]()
        var str = [String]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDateString: String = dateFormatter.string(from: date)
        
        
        
        let arrayCom = taskInfo.comment.text! as NSString
        var index = UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.object(forKey: userKey.key) as? [[String]]
        

        let ind = index?.count ?? 0 + 1
        str.append("\(ind)")
        str.append(taskInfo.nameOfTask.text!)
        str.append(arrayCom as String)
        str.append(time)
        str.append("0")
        str.append(currentDateString)

        if(index != nil) {
            for i in 0..<index!.count {
                var temp = [String]()
                temp.append(index![i][0])
                temp.append(index![i][1])
                temp.append(index![i][2])
                temp.append(index![i][3])
                temp.append(index![i][4])
                temp.append(index![i][5])
                
                arrayEl.append(temp)
            }
        }
        
        arrayEl.append(str)
        
        UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.set(arrayEl, forKey: userKey.key)

        navigationController?.popViewController(animated: true)
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
        taskInfo.comment.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        taskInfo.comment.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        taskInfo.comment.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 2/4).isActive = true
        
        //setup button - create task
        taskInfo.createButton.topAnchor.constraint(equalTo: self.taskInfo.comment.bottomAnchor).isActive = true
        taskInfo.createButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        taskInfo.createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        taskInfo.createButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }

}
