//
//  NoSaleCell.swift
//  HuPOS
//
//  Created by Cody Husek on 3/17/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit

class NoSaleCell: UITableViewCell {
    
    var message:String = "No Sale"
    var mainImage:UIImage = #imageLiteral(resourceName: "EmptyBag")
    
    var messageView:UITextView = {
        var textView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 40)
        textView.textAlignment = .center
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    var mainImageView:UIImageView = {
        var mainImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
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


        mainImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mainImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mainImageView.anchor(top: nil, left: nil, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 300, height: 300)
        messageView.anchor(top: nil, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
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
