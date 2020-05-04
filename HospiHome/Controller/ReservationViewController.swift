//
//  ReservationViewController.swift
//  SlotsUI
//
//  Created by Seif Elmenabawy on 5/1/20.
//  Copyright © 2020 Seif Elmenabawy. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,MFCardDelegate{
    var doctor: Doctor?
    
    func cardDoneButtonClicked(_ card: Card?, error: String?) {
        print(card?.number)
        print(card?.name)
        print(card?.month)
        print(card?.year)
        print(card?.cvc)
        
        
    }
    
    
//    func aesEncrypt(raw: String,key: String, iv: String) throws -> String{
//        let data = raw.data(using: .utf8)
//        let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes(), padding: )
//        
//        let encData = NSData(bytes: enc, length: Int(enc.count))
//        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
//        let result = String(base64String)
//        return result
//    }
    
    
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
       

            if(self.calendarView.selectedDates[0] != date){
            self.calendarView.deselectDate(self.calendarView.selectedDates[0])
            }
        
        timeSlotsCollectionView.isUserInteractionEnabled = true
        availableTimes = []
        timeSlotsCollectionView.reloadData()
        fetchTimeSlotsForDate()
        //print(date)
    }
    
    

    func fetchTimeSlotsForDate(){
       
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat="yyyy-MM-dd"
        let dateString = dateFormatter.string(from: self.calendarView.selectedDates[0])
        
        let parameters = ["date": dateString, "doctorid":doctor!.info.id]
        API().httpPOSTRequest(endpoint: .getFreeTimeSlots, postData: parameters) { (data, error) in
            guard let data = data else{return;}
            
            if let decodedResponse = try? JSONDecoder().decode(AvailableTimeSlotsResponse.self, from: data){
            self.timeSlots = decodedResponse.slots
          
          let dateFormatter = DateFormatter()
          dateFormatter.timeZone = TimeZone.current //Set timezone that you want
          dateFormatter.locale = NSLocale.current
          dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
         
          for i in 0..<self.timeSlots.count{
              let date = Date(timeIntervalSince1970: Double(self.timeSlots[i]))
              let strDate = dateFormatter.string(from: date)
              self.availableTimes.append(strDate)
              
          }
            DispatchQueue.main.async {
                 self.timeSlotsCollectionView.reloadData()
            }
         
            }
            
        }
        
    }
    

    
    var availableTimes = [String]()
    var timeSlots = [Int]()
    
    @IBOutlet var calendarView: CalendarView!
    @IBOutlet var timeSlotsCollectionView: UICollectionView!
    @IBOutlet var chosenTimeLabel: UILabel!
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        availableTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as! TimeSlotCollectionViewCell
        cell.label.text = availableTimes[indexPath.row]
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseSlot(_:))))
        return cell
    }
    
    @IBAction func nextMonthTapped(_ sender: Any) {
         self.calendarView.goToNextMonth()
    }
    
    @IBAction func previousMonthTapped(_ sender: Any) {
        self.calendarView.goToPreviousMonth()
    }
    
    @IBAction func paymentTapped(_ sender: Any) {
    var myCard : MFCardView
    myCard  = MFCardView(withViewController: self)
    myCard.delegate = self
    myCard.autoDismiss = true
    myCard.toast = true
    myCard.blurStyle  = UIBlurEffect(style: UIBlurEffect.Style.light)
        myCard.layoutIfNeeded()
    myCard.showCard()
    
    }
    
    @objc func chooseSlot(_ sender: UITapGestureRecognizer) {
       let location = sender.location(in: timeSlotsCollectionView)
       let indexPath = timeSlotsCollectionView.indexPathForItem(at: location)
        
        timeSlotsCollectionView.cellForItem(at: indexPath!)?.backgroundColor = .yellow
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
        
        

        
       if let index = indexPath {
        var date = Date(timeIntervalSince1970: Double(timeSlots[index.row]))
        let timeString = dateFormatter.string(from: date)
        date = calendarView.selectedDates[0]
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        
        let completeString = dateString + " " + timeString
        
        dateFormatter.dateFormat="dd/MM/yyyy HH:mm"
        date = dateFormatter.date(from: completeString)!
        let dateStamp:TimeInterval = date.timeIntervalSince1970
        //let chosenTimeStamo:Int = Int(dateStamp)
        
        chosenTimeLabel.text = completeString
        //print(chosenTimeLabel.text)
       }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        timeSlotsCollectionView.delegate = self
        timeSlotsCollectionView.dataSource = self
        timeSlotsCollectionView.isUserInteractionEnabled = false
        calendarView.style.cellColorOutOfRange = UIColor(white: 1.0, alpha: 0.5)
        
        
         calendarView.disabledDaysInt = [0,1,2,3,4,5,6]
        
        for workingDay in doctor!.workingHours{
            switch workingDay.day {
                case "Mondays": setDayAsOff(0)
            case "Tuesdays": setDayAsOff(1)
                case "Wednesdays": setDayAsOff(2)
                case "Thursdays": setDayAsOff(3)
                case "Fridays": setDayAsOff(4)
                case "Saturdays": setDayAsOff(5)
                case "Sundays": setDayAsOff(6)
            default: break
                
            }
        }
        
       
    }

    func setDayAsOff(_ index: Int){
        calendarView.disabledDaysInt.removeAll { (x) -> Bool in
            x == index
        }
    }
    
}



extension ReservationViewController: CalendarViewDataSource {
    
      func startDate() -> Date {
          return Date()
      }
      
      func endDate() -> Date {
          
          var dateComponents = DateComponents()
        
          dateComponents.month = +3
          let today = Date()
          
        let threeMonthsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)
          
          return threeMonthsFromNow!
    
      }
    
}

extension ReservationViewController: CalendarViewDelegate {
       func calendar(_ calendar: CalendarView, didScrollToMonth date : Date) {
          // print(self.calendarView.selectedDates)
       }

    
    
}
