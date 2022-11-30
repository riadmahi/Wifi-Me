//
//  HostTableViewCell.swift
//  Wifi&Me
//
//  Created by Riad Mahi on 23/11/2022.
//

import UIKit

class HostTableViewCell: UITableViewCell {
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var statusDot: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations {
            if self.isFocused {
                self.name.textColor = .black
                self.deviceImage.tintColor = .black
            } else {
                self.name.textColor = .label
                self.deviceImage.tintColor = .label
            }
        }
       
    }
}
