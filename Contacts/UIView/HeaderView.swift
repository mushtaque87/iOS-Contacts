//
//  HeaderView.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 06/02/2020.
//  Copyright © 2020 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    let nibName = "HeaderView"
    //var contentView: UIView?
    
    @IBOutlet weak var imageView: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    var contactToShow : ContactToSave?

    
    weak var delegate: ContactDetailsVCDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        //contentView = view
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
    }
    
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func  decorateView(){
        nameLabel.text = (contactToShow?.first_name ?? "") + " " + (contactToShow?.last_name ?? "")
        favBtn.setBackgroundImage(contactToShow?.favorite ?? false ? UIImage(named: "favourite_button_selected" ) :  UIImage(named:"favourite_button" ), for: .normal)
    }
    
    @IBAction func setImages(){
        delegate?.setImage(sender: self.imageView)
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        delegate?.setFavorite()
    }
    @IBAction func sendMail(_ sender: Any) {
    }
    @IBAction func call(_ sender: Any) {
    }
    @IBAction func sendSms(_ sender: Any) {
    }
    
}



