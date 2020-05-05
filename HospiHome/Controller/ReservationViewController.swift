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
    var chosenTimeStamp: Int?
    
    func cardDoneButtonClicked(_ card: Card?, error: String?) {
        if let cardCVC = card?.cvc,let cardMonth = card?.month, let cardYear = card?.year,let cardNumber = card?.number
            ,let cardName = card?.name
        {
            var cardInfo = cardNumber + "@" + cardName + "@"
            cardInfo = cardInfo + cardMonth.rawValue + "@" + cardYear + "@"
             cardInfo = cardInfo + cardCVC + "@"
            cardInfo = cardInfo + String(chosenTimeStamp!) + "@" + doctor!.info.id
            
            let cal = Calendar.current
            let startOfHour = cal.dateInterval(of: .hour, for: Date())!.start.timeIntervalSince1970
            
            let password =   access_token! + String(Int(startOfHour))
            let ciphertext = RNCryptor.encrypt(data: cardInfo.data(using: .utf8)!, withPassword: password)
            
            let parameters = ["paymentToken":ciphertext.base64EncodedString()]
            API().httpPOSTRequest(endpoint: .reserve, postData: parameters) { (data, error) in
                  guard let data = data else{self.alertError(withMessage: "Unknown Response from server, please try again later");return;}
                
                          let paymentResponse = try? JSONDecoder().decode(APIResponse.self, from: data)
                
                    if let response = paymentResponse{
                        if response.success{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success", message: response.msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.parent?.present(alert, animated: true, completion: {
                            self.navigateToHomeVC()
                        })
                            }
                        }
                        else{
                            self.alertError(withMessage: response.msg)
                        }
                }
            }
        }

    }
    
    

    func navigateToHomeVC() {
        DispatchQueue.main.async {
            let homeViewController = self.storyboard?.instantiateViewController(identifier: "tabBar")
        homeViewController!.modalPresentationStyle = .fullScreen
        self.present(homeViewController!, animated: true, completion: nil)
        }
    }

    
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {


            dateHasChanged()
            if(self.calendarView.selectedDates[0] != date){
            self.calendarView.deselectDate(self.calendarView.selectedDates[0])
            }
        

        fetchTimeSlotsForDate()
        //print(date)
    }
    
    func dateHasChanged(){
        if let lastSelectedCell = lastSelectedCell{
            lastSelectedCell.backgroundColor = .lightGray
        }
        timeSlotsCollectionView.isUserInteractionEnabled = true
        availableTimes = []
        timeSlotsCollectionView.reloadData()
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
    var lastSelectedCell: UICollectionViewCell?
    
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
         dateHasChanged()
         self.calendarView.goToNextMonth()
    }
    
    @IBAction func previousMonthTapped(_ sender: Any) {
         dateHasChanged()
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
        
        if let lastSelectedCell = lastSelectedCell{
            lastSelectedCell.backgroundColor = .lightGray
        }
        
        lastSelectedCell = timeSlotsCollectionView.cellForItem(at: indexPath!)
        lastSelectedCell!.backgroundColor = .yellow
        
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
        chosenTimeStamp = Int(dateStamp)
        
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
    
    func alertError(withMessage: String){
        DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: withMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
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
