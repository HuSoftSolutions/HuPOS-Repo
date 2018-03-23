//
//  NoSaleCell.swift
//  HuPOS
//
//  Created by Cody Husek on 3/17/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit

class NoSaleCell: UITableViewCell {
    
    var message:String = "No current sale!"
    var mainImage:UIImage = #imageLiteral(resourceName: "shoppingcart")
    
    var messageView:UITextView = {
        var textView = UITextView(frame: CGRect(x: 0, y: 800, width: 200, height: 50))
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 30)
        textView.textAlignment = .center
        return textView
    }()
    
    var mainImageView:UIImageView = {
        var mainImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        return mainImageView
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.mainImageView.image = self.mainImage
        self.messageView.text = self.message
        self.addSubview(mainImageView)
        self.backgroundColor = .lightGray
        self.addSubview(messageView)

        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //mainImageView.bottomAnchor.constraint(equalTo: self.messageView.topAnchor).isActive = true
//
        mainImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //mainImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        mainImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        //messageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        messageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        messageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        //messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //messageView.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor).isActive = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
