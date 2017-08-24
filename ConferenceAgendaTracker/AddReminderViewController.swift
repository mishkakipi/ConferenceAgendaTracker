//
//  AddReminderViewController.swift
//  ConferenceAgendaTracker
//
//  Created by imac_1 on 8/12/17.
//  Copyright © 2017 Afeka. All rights reserved.
//

import UIKit
import UserNotifications

class AddReminderViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var timeBeforeEvent: UISegmentedControl!
    @IBAction func unwindToReminder(segue: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var speaker: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var saveReminder: UIBarButtonItem!
    @IBOutlet weak var timeFrame: UILabel!
    @IBOutlet weak var timeOffset: UISegmentedControl!

    var sessionTitle = String()
    var sessionSpeaker = String()
    var sessionRoom = String()
    var sessionStartTime = String()
    var sessionEndTime = String()

    @IBAction func CancelReminderAddition(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = self.sessionTitle
        speaker.text = self.sessionSpeaker
        room.text = self.sessionRoom
        timeFrame.text = sessionStartTime + "-" + sessionEndTime
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveReminder === sender as! UIBarButtonItem{
            let reminderOffset = (5*(timeOffset.selectedSegmentIndex+1))
            let notification = UNMutableNotificationContent()
            notification.title = self.lblTitle.text!
            notification.body = self.room.text! + " starting in " + String(reminderOffset) + " minutes"
            notification.sound = UNNotificationSound.default()
            var tempHour = Int(sessionStartTime.components(separatedBy: ":")[0])
            var tempMinute = Int(sessionStartTime.components(separatedBy: ":")[1])! - reminderOffset
            if tempMinute<0 {
                tempMinute = tempMinute + 60
                tempHour = tempHour! - 1
            }
            var date = DateComponents()
            date.hour = tempHour
            date.minute = tempMinute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            let request = UNNotificationRequest.init(identifier: "ComferenceSessionReminder", content: notification, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
         }
    }
    

}
