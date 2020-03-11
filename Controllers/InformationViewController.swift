//
//  MainViewController.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 5/31/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit
import CoreData


class InformationViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    private var notes: Note?
    var textViewScroll = UIScrollView();
    
    var flag: Bool = false
    var taskInfo = TaskInfo()
    var indexOfCurrentElement: Int = 0
    let statuses = ["new",
                    "in the process",
                    "done"]
    var selectedStatus: String?
    
    override func viewWillDisappear(_ animated: Bool) {
        changeDates();
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    convenience init(with parameters: Note, index: String) {
        self.init()
        
        indexOfCurrentElement = Int(index)!
        self.notes = parameters
        
        taskInfo.nameOfTask.delegate = self
        taskInfo.comment.delegate = self
    
        setupCreateView()
        setupNavigationItems()
        setupdefaultSettings()
        createStatusPicker()
        createToolBar()
    }
    
    // MARK: - Set up default settings
    
    func setupNavigationItems() {
        title = "Information"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = UIColor.white
        
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.init(name: "Quicksand-Regular", size: 20)!]
        
        let statusButton = UIBarButtonItem.init(title: "Status", style: .plain, target: self, action: #selector(finishTask))
        statusButton.tintColor = UIColor.black
        let editButton = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(beginEditing))
        editButton.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItems = [editButton, statusButton]

    }
    func setupdefaultSettings() {
        taskInfo.nameOfTask.textColor = UIColor.gray
        taskInfo.comment.textColor = UIColor.gray
        taskInfo.createButton.isHidden = true
        taskInfo.comment.isEditable = false
    }
    
    // set up all dated
    func setupDates() {
        taskInfo.nameOfTask.text = notes?.nameOfTask
        taskInfo.comment.text = notes?.comments
        taskInfo.statusFiels.text = "Status: " + notes!.status
    }
    
    func setupCreateView() {
        setupDates()
        
        textViewScroll.translatesAutoresizingMaskIntoConstraints = false;
        textViewScroll.backgroundColor = UIColor.white
//        textViewScroll.frame = self.view.bounds;
//        textViewScroll.autoresizingMask = .flexibleHeight;
//        textViewScroll.bounces = true;
        taskInfo.comment.text = notes?.comments;
        textViewScroll.contentSize.height = taskInfo.comment.contentSize.height;
        
        self.view.addSubview(textViewScroll)
        
        textViewScroll.addSubview(taskInfo.nameOfTask)
        textViewScroll.addSubview(taskInfo.comment)
        textViewScroll.addSubview(taskInfo.createButton)
        
        textViewScroll.addSubview(taskInfo.statusFiels)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        textViewScroll.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true;
        textViewScroll.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        textViewScroll.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        textViewScroll.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;

        taskInfo.nameOfTask.topAnchor.constraint(equalTo: self.textViewScroll.topAnchor).isActive = true;
        taskInfo.nameOfTask.leftAnchor.constraint(equalTo: self.textViewScroll.leftAnchor, constant: 22).isActive = true
        taskInfo.nameOfTask.heightAnchor.constraint(equalToConstant: 50).isActive = true
        taskInfo.nameOfTask.widthAnchor.constraint(equalTo: self.textViewScroll.widthAnchor).isActive = true
        
        //setup comments

        taskInfo.comment.topAnchor.constraint(equalTo: self.taskInfo.nameOfTask.bottomAnchor).isActive = true
        taskInfo.comment.leftAnchor.constraint(equalTo: self.textViewScroll.leftAnchor, constant: 15).isActive = true
        taskInfo.comment.widthAnchor.constraint(equalTo: self.textViewScroll.widthAnchor, constant: -30).isActive = true
        taskInfo.comment.heightAnchor.constraint(equalToConstant: taskInfo.comment.contentSize.height).isActive = true
        
        
        // setup status button
        taskInfo.statusFiels.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        taskInfo.statusFiels.heightAnchor.constraint(equalToConstant: 30).isActive = true
        taskInfo.statusFiels.widthAnchor.constraint(equalToConstant: 200).isActive = true
        taskInfo.statusFiels.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
//    MARK: - Actions with data
    
    // button "Done" which changed status after click on it
    @objc func finishTask() {
        
        let alertController = UIAlertController(title: "Attention", message: "Are you really want to finish completing task?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            self.updateData(index: self.indexOfCurrentElement, value: "2");
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
    }
    
    
    // save all dates after editing
    func changeDates() {
    
        updateDataAfterEditing(index: self.indexOfCurrentElement, name: taskInfo.nameOfTask.text ?? "Default", comment: ((taskInfo.comment.text! as NSString) as String?)!)
        taskInfo.statusFiels.font = UIFont.init(name: "Quicksand-Regular", size: 17)
        if taskInfo.statusFiels.text == "Status: new" {
            updateData(index: indexOfCurrentElement, value: "0");
        } else if taskInfo.statusFiels.text == "Status: in the process" {
            updateData(index: indexOfCurrentElement, value: "1");
        } else if taskInfo.statusFiels.text == "Status: done" {
            updateData(index: indexOfCurrentElement, value: "2");
        } else {
            updateData(index: indexOfCurrentElement, value: "0");
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
//    MARK: - Text field delegates
    
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
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }

        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: self.view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                textViewScroll.contentSize.height = estimatedSize.height + self.view.frame.height
                constraint.constant = textViewScroll.contentSize.height
            }
        }
    }
    func textViewShouldReturn(textView: UITextView!) -> Bool {
        textView.endEditing(true);
        return true;
    }
    
    @objc func createStatusPicker() {
        let statusPicker = UIPickerView()
        statusPicker.delegate = self
        
        taskInfo.statusFiels.inputView = statusPicker
    }
    @objc func dismissKeyboard()
    {
        taskInfo.statusFiels.endEditing(true)
    }
    
//    MARK: - Create Tool Bar
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(InformationViewController.dismissKeyboard))
        doneButton.tintColor = UIColor.black
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true

        taskInfo.statusFiels.inputAccessoryView = toolBar
    }
    
//MARK: - COREDATA requests
    
    func updateData(index: Int, value: String){
     
         //As we know that container is set up in the AppDelegates so we need to refer that container.
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
         
         //We need to create a context from this container
         let managedContext = appDelegate.persistentContainer.viewContext
         
         let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Task")
         fetchRequest.predicate = NSPredicate(format: "id == %@", "\(index)")
         do
         {
             let test = try managedContext.fetch(fetchRequest)
    
                 let objectUpdate = test[0] as! NSManagedObject
                 objectUpdate.setValue(value, forKey: "status")
                 do{
                     try managedContext.save()
                 }
                 catch
                 {
                     print(error)
                 }
             }
         catch
         {
             print(error)
         }
    
     }
    
    func updateDataAfterEditing(index: Int, name: String, comment: String){
     
         //As we know that container is set up in the AppDelegates so we need to refer that container.
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
         
         //We need to create a context from this container
         let managedContext = appDelegate.persistentContainer.viewContext
         
         let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Task")
         fetchRequest.predicate = NSPredicate(format: "id == %@", "\(index)")
         do
         {
             let test = try managedContext.fetch(fetchRequest)
    
                guard let objectUpdate = test[0] as? NSManagedObject else { return}
                objectUpdate.setValue(comment, forKey: "comments");
                objectUpdate.setValue(name, forKey: "name");
                 do{
                     try managedContext.save()
                 }
                 catch
                 {
                     print(error)
                 }
             }
         catch
         {
             print(error)
         }
    
     }
        
    
}
//MARK: - Keyboard

extension InformationViewController {
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            taskInfo.comment.contentInset = .zero
        } else {
            taskInfo.comment.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 200, right: 0)
        }

        taskInfo.comment.scrollIndicatorInsets = taskInfo.comment.contentInset

        let selectedRange = taskInfo.comment.selectedRange
        taskInfo.comment.scrollRangeToVisible(selectedRange)
    }
}

// MARK: - Status picker

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
        taskInfo.statusFiels.font = UIFont.init(name: "Quicksand-Regular", size: 17)
    }
    
}
