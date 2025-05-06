//
//  MainTableView.swift
//  ToDoList
//
//  Created by Ксюша on 02.05.2025.
//

import UIKit

protocol MainTableViewCellDellegate: AnyObject {
    func checkboxIsTapped(indexPath: IndexPath)
}

class MainTableViewCell: UITableViewCell {
    
    // MARK: - Naming
    
    static let identifier = "MainTableViewCell"
    
    weak var delegate: MainTableViewCellDellegate?
    
    private var indexPath: IndexPath?
    
    private var completed: Bool = false
    
    private lazy var checkbox: CheckboxControl = {
        let checkbox = CheckboxControl()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.addTarget(self, action: #selector(checkboxTapped), for: .valueChanged)
        checkbox.borderWidth = 1.5
        checkbox.checkmarkLineWidth = 1.5
        checkbox.checkedBorderColor = .themeYellow
        checkbox.checkmarkColor = .themeYellow
        return checkbox
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackVeiw =  UIStackView(arrangedSubviews: [titleLabel, noteLabel, dateLabel])
        stackVeiw.axis = .vertical
        stackVeiw.spacing = 6
        stackVeiw.translatesAutoresizingMaskIntoConstraints = false
        return stackVeiw
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.removeStrikethrough()
    }
    
    // MARK: - Methods
    
    private func setupCell() {
        contentView.addSubview(checkbox)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            checkbox.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            checkbox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            checkbox.heightAnchor.constraint(equalToConstant: 24),
            checkbox.widthAnchor.constraint(equalToConstant: 24),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func updateCompleteness() {
        
        checkbox.setChecked(completed)
        
        if completed {
            titleLabel.textColor = .lightGray
            titleLabel.applyStrikethrough()
            noteLabel.textColor = .lightGray
        } else {
            titleLabel.textColor = .white
            titleLabel.removeStrikethrough()
            noteLabel.textColor = .white
        }
    }
    
    func configure(with task: Task, indexPath: IndexPath) {
        
        titleLabel.text = task.title
        noteLabel.text = task.todo
        dateLabel.text = task.date
        
        completed = task.completed
        updateCompleteness()
        
        self.indexPath = indexPath
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc func checkboxTapped() {
        guard let indexPath else { return }
        completed.toggle()
        delegate?.checkboxIsTapped(indexPath: indexPath)
    }
}
