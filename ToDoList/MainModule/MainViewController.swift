//
//  ViewController.swift
//  ToDoList
//
//  Created by Ксения Маричева on 01.05.2025.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func prepare()
}

class MainViewController: UIViewController {
    
    //MARK: - Naming
    
    var presenter: MainPresenterProtocol?
    
    var tasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Задачи"
        label.textColor = Style.titleLabelColor
        label.textAlignment = .left
        label.font = Style.titleLabelFont
        return label
    }()
    
    private lazy var customSearchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var lowerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .theme
        return view
    }()
    
    private lazy var editingActionView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "square.and.pencil")
        view.tintColor = .themeYellow
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editingImageViewTapped)))
        return view
    }()
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        presenter?.viewDidLoaded()
        setupVeiw()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
    
    //MARK: - Methods
    
    private func setupVeiw() {
        
        viewAddGestureRecognizer()
        
        view.addSubview(titleLabel)
        view.addSubview(customSearchBar)
        view.addSubview(tableView)
        view.addSubview(lowerView)
        lowerView.addSubview(editingActionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            customSearchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            customSearchBar.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            customSearchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customSearchBar.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: customSearchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: lowerView.topAnchor),
            
            lowerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lowerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lowerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lowerView.heightAnchor.constraint(equalToConstant: 83),
            
            editingActionView.heightAnchor.constraint(equalToConstant: 28),
            editingActionView.widthAnchor.constraint(equalToConstant: 68),
            editingActionView.trailingAnchor.constraint(equalTo: lowerView.trailingAnchor),
            editingActionView.topAnchor.constraint(equalTo: lowerView.topAnchor, constant: 13)
        ])
    }
    
    func viewAddGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func editingImageViewTapped() {
        presenter?.editingImageViewTapped()
    }
    
    @objc private func searchTextChanged() {
        if let text = customSearchBar.text {
            presenter?.textEntered(text)
        }
    }
}

extension MainViewController: MainViewControllerProtocol {
    func prepare() {
        hideKeyboard()
        customSearchBar.deleteText()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.configure(with: tasks[indexPath.row], indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let task = tasks[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            TaskPreviewController(task: task)
        }, actionProvider: { _ in
            let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.presenter?.editignActionTapped(with: task)
            }
            let share = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                print("Поделиться: \(task.title ?? "")")
            }
            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.presenter?.deleteTask(task)
            }
            return UIMenu(title: "", children: [edit, share, delete])
        })
    }
}

extension MainViewController: MainTableViewCellDellegate {
    func checkboxIsTapped(indexPath: IndexPath) {
        presenter?.checkboxIsTapped(with: tasks[indexPath.row])
    }
}



