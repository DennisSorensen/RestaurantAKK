//
//  MadRetTableViewCell.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 26/03/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import UIKit

class MadRetTableViewCell: UITableViewCell {

    @IBOutlet weak var madRetImageView: UIImageView!
    @IBOutlet weak var madRetNavnLabel: UILabel!
    @IBOutlet weak var prisLabel: UILabel!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func opdaterBillede(medBillede: UIImage?) {
        if let billede = medBillede {
            self.madRetImageView.image = billede
            
            self.madRetImageView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.madRetImageView.alpha = 1
                self.spinnerView.alpha = 0
            }) { (_) in
                self.spinnerView.stopAnimating()
            }
        }
        else {
            self.madRetImageView.image = nil
            self.madRetImageView.alpha = 0
            self.spinnerView.alpha = 1
            self.spinnerView.startAnimating()
        }
    }
}
