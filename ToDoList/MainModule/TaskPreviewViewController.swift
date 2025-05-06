//
//  TaskPreviewViewController.swift
//  ToDoList
//
//  Created by Ксения Маричева on 03.05.2025.
//

import UIKit

class TaskPreviewController: UIViewController {
    
    // MARK: - Constants
    
    struct Sizes {
        static let titleHeight: CGFloat = 22
        static let dateHeight: CGFloat = 16
        static let spacing: CGFloat = 6
        static let inset: CGFloat = 12
        
        static var menuWidth: CGFloat {
            UIScreen.main.bounds.width - 40
        }
        
        static var stackViewWidth: CGFloat {
            menuWidth - 32
        }
        
        static var stackViewFixedHeight: CGFloat {
            Sizes.titleHeight + Sizes.dateHeight + Sizes.spacing * 2 + Sizes.inset * 2
        }
    }
    
    // MARK: - Naming
    
    private let task: Task
    
    private var descriptionHeight: CGFloat {
        descriptionLabel.sizeThatFits(CGSize(width: Sizes.stackViewWidth, height: .greatestFiniteMagnitude)).height
    }
    
    // MARK: - UIComponents
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = task.title
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = task.todo
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 10
        label.textColor = .white
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = task.date
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackVeiw =  UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        stackVeiw.axis = .vertical
        stackVeiw.spacing = Sizes.spacing
        stackVeiw.translatesAutoresizingMaskIntoConstraints = false
        return stackVeiw
    }()
    
    // MARK: - Life cycle
    
    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        preferredContentSize = CGSize(width: Sizes.menuWidth, height: Sizes.stackViewFixedHeight + descriptionHeight)
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        view.backgroundColor = .theme
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizes.inset),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: Sizes.stackViewWidth),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: Sizes.titleHeight),
            dateLabel.heightAnchor.constraint(equalToConstant: Sizes.dateHeight)
        ])
    }
}
