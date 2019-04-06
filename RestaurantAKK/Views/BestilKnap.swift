//
//  BestilKnap.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 14/02/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import UIKit

class BestilKnap: UIButton {

    //Overstyrre init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    //Denne init sørger for at man kan bruge storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //Laver knap pæn
    private func setup() {
        //Laver runde hjørner
        self.layer.cornerRadius = 5.0
        //Laver shadow på knappen
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 5
    }
    
    //Func til at bounce knap ved klik
    public func klikAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.transform = CGAffineTransform.identity
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
