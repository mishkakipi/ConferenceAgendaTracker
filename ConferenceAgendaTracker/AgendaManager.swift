//
//  AgendaManager.swift
//  ConferenceAgendaTracker
//
//  Created by imac_1 on 8/11/17.
//  Copyright © 2017 Afeka. All rights reserved.
//

import Foundation

struct SessionDetails {
    var id: String = ""
    var title: String = ""
    var speaker: String = ""
    var location: String = ""
    var startTime: Date = Date()
    var endTime: Date = Date()
}

struct ConferenceAgenda{
    var name: String
    var date: Date
    var sessionList: [SessionDetails]

}
