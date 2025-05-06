//
//  CustomSearchBar.swift
//  ToDoList
//
//  Created by Ксения Маричева on 01.05.2025.
//

import UIKit
import Speech

class CustomSearchBar: UIControl {
    
    //MARK: - Naming
    
    var text: String?
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    var textFieldDelegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = textFieldDelegate
        }
    }
    
    private let audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private lazy var loupeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor.systemGray
            ]
        )
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.textColor = .white
        return textField
    }()
    
    private lazy var microphoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "mic.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMicrophoneTap)))
        return imageView
    }()
    
    //MARK: - Init
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .theme
        layer.cornerRadius = 10
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupView() {
        addSubview(loupeImageView)
        addSubview(textField)
        addSubview(microphoneImageView)
        
        NSLayoutConstraint.activate([
            loupeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            loupeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loupeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            loupeImageView.heightAnchor.constraint(equalTo: loupeImageView.widthAnchor),
            
            textField.topAnchor.constraint(equalTo: loupeImageView.topAnchor),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: loupeImageView.trailingAnchor, constant: 3),
            textField.trailingAnchor.constraint(equalTo: microphoneImageView.leadingAnchor, constant: -3),
            
            microphoneImageView.topAnchor.constraint(equalTo: loupeImageView.topAnchor),
            microphoneImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            microphoneImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            microphoneImageView.widthAnchor.constraint(equalTo: microphoneImageView.heightAnchor),
        ])
    }
    
    private func startListening() throws {
        
        guard !audioEngine.isRunning else {
            stopListening()
            return
        }
        
        microphoneImageView.tintColor = .themeYellow
        
        // Заверши предыдущую задачу
        recognitionTask?.cancel()
        recognitionTask = nil

        // Подготовка аудио сессии
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        // Настройка запроса и распознавателя
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Не удалось создать запрос") }

        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true

        // Запуск распознавания
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                self.textField.text = result.bestTranscription.formattedString
            }

            if error != nil || (result?.isFinal ?? false) {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }

        // Подключение аудио потока
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
               self?.stopListening()
           }
    }
    
    private func stopListening() {
        text = textField.text
        sendActions(for: .editingChanged)
        microphoneImageView.tintColor = .lightGray
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
    }
    
    func deleteText() {
        textField.text = ""
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        text = textField.text
        sendActions(for: .editingChanged)
    }
    
    @objc private func handleMicrophoneTap() {
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    guard let self = self else { return }

                    if authStatus == .authorized && granted {
                        try? self.startListening()
                    } else {
                        print("Нет доступа к распознаванию речи или микрофону")
                    }
                }
            }
        }
    }
}
