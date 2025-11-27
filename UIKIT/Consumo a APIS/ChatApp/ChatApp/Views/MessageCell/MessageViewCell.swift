//
//  MessageViewCell.swift
//  ChatApp
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 26/11/25.
//
import UIKit

class MessageViewCell: UITableViewCell {

    let bubbleView = UIView()
    let messageLabel = UILabel()
    let timeLabel = UILabel()
    let dateLabel = UILabel()
    let senderLabel = UILabel()
    
    var bubbleLeadingConstraint: NSLayoutConstraint!
    var bubbleTrailingConstraint: NSLayoutConstraint!
    var dateLeadingConstraint: NSLayoutConstraint!
    var dateTrailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        bubbleView.layer.cornerRadius = 15
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .right
        
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = UIColor.secondaryLabel
        
        senderLabel.font = UIFont.systemFont(ofSize: 12)
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.textColor = UIColor.tertiaryLabel
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(timeLabel)
        contentView.addSubview(senderLabel)
        
        bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        dateLeadingConstraint = dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        dateTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            
            bubbleView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            bubbleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8),
            
            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8),
            timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
            
            senderLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 4),
            senderLabel.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            senderLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    func configure(message: String, sender: String, dateTime: Date) {
        messageLabel.text = message
        senderLabel.text = sender
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateLabel.text = dateFormatter.string(from: dateTime)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeLabel.text = timeFormatter.string(from: dateTime)
        
        let myUsername = UserDefaults.standard.string(forKey: "username") ?? ""
        
        if sender == myUsername {
            bubbleView.backgroundColor = UIColor { trait in
                trait.userInterfaceStyle == .dark ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.9)
            }
            messageLabel.textColor = UIColor { trait in
                trait.userInterfaceStyle == .dark ? .white : .white
            }
            
            bubbleLeadingConstraint.isActive = false
            bubbleTrailingConstraint.isActive = true
            dateLeadingConstraint.isActive = false
            dateTrailingConstraint.isActive = true
        } else {
            bubbleView.backgroundColor = UIColor { trait in
                trait.userInterfaceStyle == .dark ? UIColor.darkGray : UIColor.systemGray5
            }
            messageLabel.textColor = UIColor { trait in
                trait.userInterfaceStyle == .dark ? .white : .black
            }
            
            bubbleTrailingConstraint.isActive = false
            bubbleLeadingConstraint.isActive = true
            dateTrailingConstraint.isActive = false
            dateLeadingConstraint.isActive = true
        }
    }
}

