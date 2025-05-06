//
//  CheckboxControl.swift
//  ToDoList
//
//  Created by Ксюша on 02.05.2025.
//

import UIKit

final class CheckboxControl: UIControl {
    
    // MARK: - Properties
    
    var isChecked: Bool = false
    
    private let checkmarkLayer = CAShapeLayer()
    private lazy var borderLayer = CAShapeLayer()
    
    // MARK: - Colors
    
    var uncheckedBorderColor: UIColor = .gray
    var checkedBorderColor: UIColor = .systemBlue
    var checkmarkColor: UIColor = .systemBlue
    
    // MARK: - Sizes
    
    var borderWidth: CGFloat = 2.0
    var checkmarkLineWidth: CGFloat = 2.0
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        addGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    // MARK: - Setup
    private func setupLayers() {
        layer.addSublayer(borderLayer)
        layer.addSublayer(checkmarkLayer)
        checkmarkLayer.fillColor = UIColor.clear.cgColor
    }
    
    private func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func handleTap() {
        sendActions(for: .valueChanged)
    }
    
    // MARK: - UI Update
    
    private func updateUI() {
        
        // Circle
        
        borderLayer.frame = bounds
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        borderLayer.lineWidth = borderWidth
    
        borderLayer.strokeColor = isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor
        
        // Checkmark
        
        if isChecked {
            let checkmarkPath = UIBezierPath()
            let startPoint = CGPoint(x: bounds.width * 0.25, y: bounds.height * 0.5)
            let middlePoint = CGPoint(x: bounds.width * 0.45, y: bounds.height * 0.7)
            let endPoint = CGPoint(x: bounds.width * 0.75, y: bounds.height * 0.3)
            
            checkmarkPath.move(to: startPoint)
            checkmarkPath.addLine(to: middlePoint)
            checkmarkPath.addLine(to: endPoint)
            
            checkmarkLayer.path = checkmarkPath.cgPath
            checkmarkLayer.strokeColor = checkmarkColor.cgColor
            checkmarkLayer.lineWidth = checkmarkLineWidth
            checkmarkLayer.lineCap = .round
            checkmarkLayer.lineJoin = .round
        } else {
            checkmarkLayer.path = nil
        }
    }
    
    func setChecked(_ checked: Bool) {
        
        if isChecked != checked {
            isChecked = checked
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            updateUI()
            CATransaction.commit()
        }
    }

}
