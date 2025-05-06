//
//  EditingViewController.swift
//  ToDoList
//
//  Created by Ксения Маричева on 04.05.2025.
//

import UIKit

protocol EditingViewControllerProtocol: AnyObject {
    func setTask(with task: Task?)
}

class EditingViewController: UIViewController {
    
    // MARK: - Naming
    
    var presenter: EditingPresenter?
    
    var task: Task?
    
    private lazy var backStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backImageView, backTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.sizeToFit()
        stackView.axis = .horizontal
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backStackViewTapped)))
        return stackView
    }()
    
    private lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.left")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .themeYellow
        return imageView
    }()
    
    private lazy var backTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Назад"
        label.textColor = .themeYellow
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Заголовок",
            attributes: [
                .foregroundColor: UIColor.lightGray
            ]
        )
        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textField.textColor = .white
        return textField
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var todoTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.placeholder = "Ваша задача"
        return textView
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoaded()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .black
        
        view.addSubview(backStackView)
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(todoTextView)
        
        NSLayoutConstraint.activate([
            backStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backImageView.heightAnchor.constraint(equalToConstant: 22),
            backImageView.widthAnchor.constraint(equalTo: backImageView.heightAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: backStackView.bottomAnchor, constant: 19),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 41),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            
            todoTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            todoTextView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            todoTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            todoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func backStackViewTapped() {
        guard let title = titleTextField.text, let date = dateLabel.text, let todo = todoTextView.inPlaceholderMode ? "" : todoTextView.text else { return }
        presenter?.backStackViewTapped(title: title, date: date, todo: todo)
    }
}

extension EditingViewController: EditingViewControllerProtocol {
    func setTask(with task: Task?) {
        guard let task else {
            dateLabel.text = presenter?.getDate()
            return
        }
        titleTextField.text = task.title
        dateLabel.text = task.date
        todoTextView.text = task.todo
    }
}
