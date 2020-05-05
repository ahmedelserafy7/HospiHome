//
//  CreateScheduleViewController.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/4/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class CreateScheduleViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet var dayPicker: UIPickerView!
    var schedule = [Day]()
    let days = ["","Sundays","Mondays","Tuesdays","Wednesdays","Thursdays","Fridays","Saturdays"]
    var chosenRow = 0
    
    @IBOutlet var fromTimePicker: UIDatePicker!
    @IBOutlet var toTimePicker: UIDatePicker!
    @IBOutlet var isWorkingSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayPicker.dataSource = self
        dayPicker.delegate = self
        
        API().httpGETRequest(endpoint: .getOwnSchedule) { (data, error) in
            guard let data = data else{self.alertError(withTitle: "Error", withMessage: "Unknown Response from server, please try again later");return;}
            
            if let response = try? JSONDecoder().decode(GetScheduleResponse.self, from: data){
                if response.success{
                    self.schedule = response.schedule!
                } else {
                    for day in self.days{
                        self.schedule.append(Day(name: day, working: false, startTimeStamp: 1588320000, endTimeStamp: 1588338000))
                    }
                }
            }
        }
    }
    
    @IBAction func isWorkingSwitchAction(_ sender: UISwitch) {
        var isWorking = false
        if sender.isOn{
            isWorking = true
            fromTimePicker.isEnabled = true
            toTimePicker.isEnabled = true
        }
        
        schedule[chosenRow].working = isWorking
    }
    
    @IBAction func fromTimePicker(_ sender: UIDatePicker) {
        schedule[chosenRow].startTimeStamp =  Int(sender.date.timeIntervalSince1970)
    }
    
    @IBAction func toTimePicker(_ sender: UIDatePicker) {
        schedule[chosenRow].endTimeStamp =  Int(sender.date.timeIntervalSince1970)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenRow = row
        
        if(chosenRow == 0){
            fromTimePicker.isEnabled = false
            toTimePicker.isEnabled = false
            isWorkingSwitch.isEnabled = false
        } else{
            fromTimePicker.isEnabled = true
            toTimePicker.isEnabled = true
            isWorkingSwitch.isEnabled = true
        }
        
        let chosenDay = schedule[chosenRow]
        fromTimePicker.setDate(Date(timeIntervalSince1970: Double(chosenDay.startTimeStamp)), animated: false)
        toTimePicker.setDate(Date(timeIntervalSince1970: Double(chosenDay.endTimeStamp)), animated: false)
        isWorkingSwitch.isOn = chosenDay.working
        
        if chosenDay.working{
            fromTimePicker.isEnabled = true
            toTimePicker.isEnabled = true
        } else {
            fromTimePicker.isEnabled = false
            toTimePicker.isEnabled = false
        }
    }
    
    @IBAction func saveSchedule(_ sender: Any) {
        schedule.remove(at: 0)
        let JSONSchedule = try! JSONEncoder().encode(schedule)
        
        let parameters = ["schedule": String(bytes: JSONSchedule, encoding: .utf8)!]
        API().httpPOSTRequest(endpoint: .updateSchedule, postData: parameters) { (data, error) in
            
            guard let data = data else{self.alertError(withTitle: "Error", withMessage: "Unknown Response from server, please try again later"); return }
            
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data){
                if response.success{
                    //self.alertError(withTitle: "Success", withMessage: "Schedule update successfully")}
                    DispatchQueue.main.async {self.dismiss(animated: true, completion: nil)}
                } else {
                    self.alertError(withTitle: "Error", withMessage: response.msg)
                }
                
            }
        }
    }
    
    func alertError(withTitle: String,withMessage: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
