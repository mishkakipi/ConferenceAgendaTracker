//
//  FirstViewController.swift
//  ConferenceAgendaTracker
//
//  Created by imac_1 on 8/10/17.
//  Copyright © 2017 Afeka. All rights reserved.
//

import UIKit
import UserNotifications

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var agendaSessionsTable: UITableView!
    @IBAction func unwindToAgenda(segue: UIStoryboardSegue) {
    }
    var sessions: [SessionDetails]? = []
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.fetchAgenda()
        //self.agendaSessionsTable.reloadData()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh List")
        refreshControl.addTarget(self, action: #selector(FirstViewController.refreshAgenda), for: .valueChanged)
        if #available(iOS 10.0, *) {
            agendaSessionsTable.refreshControl = self.refreshControl
        } else {
            agendaSessionsTable.addSubview(self.refreshControl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchAgenda() {
        let urlRequest = URLRequest(url: URL(string: "http://192.168.1.7:8081/conference/agenda")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if (error != nil) {
                print(error!)
                return
            }
            self.sessions = [SessionDetails]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                let conferenceName = json["name"] as? String
                let conferenceDate = json["date"] as? String
                if let sessionsFromJson = json["sessions"] as? [[String:AnyObject]] {
                    for sessionFromJson in sessionsFromJson {
                        var sessionDetails = SessionDetails()
                        if let sessionId = sessionFromJson["id"] as? String,
                            let sessionTitle = sessionFromJson["title"] as? String,
                            let sessionStartTime = sessionFromJson["startTime"] as? String,
                            let sessionEndTime = sessionFromJson["endTime"] as? String,
                            let sessionSpeaker = sessionFromJson["speaker"] as? String,
                            let sessionLocation = sessionFromJson["location"] as? String {
                            let dateStartTime = conferenceDate! + " " + sessionStartTime
                            let dateEndTime = conferenceDate! + " " + sessionEndTime
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                            sessionDetails.id = sessionId
                            sessionDetails.title = sessionTitle
                            sessionDetails.speaker = sessionSpeaker
                            sessionDetails.startTime = dateFormatter.date(from: dateStartTime)!
                            sessionDetails.endTime = dateFormatter.date(from: dateEndTime)!
                            sessionDetails.location = sessionLocation
                        }
                        self.sessions?.append(sessionDetails)
                    }
                }
                DispatchQueue.main.async {
                    self.agendaSessionsTable.reloadData()
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
        
    }
    func refreshAgenda(sender: AnyObject) {
        self.fetchAgenda()
        self.refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sessionCell = tableView.dequeueReusableCell(withIdentifier: "agendaSessionCell", for: indexPath) as! AgendaSessionCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        sessionCell.sessionTitleLabel.text = self.sessions?[indexPath.item].title
        sessionCell.sessionRoomLabel.text = "at " + (self.sessions?[indexPath.item].location)!
        sessionCell.sessionSpeakerLabel.text = "by " + (self.sessions?[indexPath.item].speaker)!
        sessionCell.sessionStartTimeLabel.text = dateFormatter.string(from: (self.sessions?[indexPath.item].startTime)!)
        sessionCell.sessionEndTimeLabel.text = dateFormatter.string(from: (self.sessions?[indexPath.item].endTime)!)
        
        return sessionCell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sessions?.count ?? 0
    }
    @IBAction func addReminder(_ sender: UIButton) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let selectedCell = (sender as AnyObject).superview??.superview as? AgendaSessionCell {
            //let selectedSession = selectedCell as AgendaSessionCell
            let addReminderVC = segue.destination as! AddReminderViewController
            addReminderVC.sessionTitle = ((selectedCell.sessionTitleLabel.text)!)
            addReminderVC.sessionEndTime = ((selectedCell.sessionEndTimeLabel.text)!)
            addReminderVC.sessionStartTime = ((selectedCell.sessionStartTimeLabel.text)!)
            addReminderVC.sessionRoom = ((selectedCell.sessionRoomLabel.text)!)
            addReminderVC.sessionSpeaker = ((selectedCell.sessionSpeakerLabel.text)!)
        }
    }

}

