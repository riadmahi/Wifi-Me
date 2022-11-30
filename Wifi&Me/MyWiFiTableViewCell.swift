//
//  NetworkTableViewCell.swift
//  Wifi&Me
//
//  Created by Riad Mahi on 28/11/2022.
//

import UIKit

class MyWiFiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations {
            if self.isFocused {
                self.info.textColor = .black
            } else {
                self.info.textColor = .label
            }
        }
    }
}
