//
//  extensions.swift
//  ToDoList
//
//  Created by Ксения Маричева on 03.05.2025.
//

import UIKit

extension UILabel {
    
    func applyStrikethrough(font: UIFont? = nil,
                            color: UIColor? = nil,
                            lineColor: UIColor? = nil,
                            style: NSUnderlineStyle = .single) {
        guard let currentText = self.text else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? self.font ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: color ?? self.textColor ?? UIColor.label,
            .strikethroughStyle: style.rawValue,
            .strikethroughColor: lineColor ?? color ?? self.textColor ?? UIColor.label
        ]
        
        self.attributedText = NSAttributedString(string: currentText, attributes: attributes)
    }
    
    func removeStrikethrough() {
        let plainText = self.attributedText?.string ?? self.text ?? ""
        
        self.attributedText = nil
        self.text = plainText
    }
}
