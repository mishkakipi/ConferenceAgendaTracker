//
//  AgendaSessionCell.swift
//  ConferenceAgendaTracker
//
//  Created by imac_1 on 8/11/17.
//  Copyright © 2017 Afeka. All rights reserved.
//

import UIKit

class AgendaSessionCell: UITableViewCell {

    @IBOutlet weak var sessionTitleLabel: UILabel!

    @IBOutlet weak var sessionSpeakerLabel: UILabel!
    @IBOutlet weak var sessionRoomLabel: UILabel!
    @IBOutlet weak var sessionStartTimeLabel: UILabel!
    @IBOutlet weak var sessionEndTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
