//
//  AccessPermissionService.swift
//  ToDoList
//
//  Created by Ксюша on 05.05.2025.
//
import Speech

class AccessPermissionService {
    
    static func requestMicrophoneAccess() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Пользователь разрешил доступ к микрофону")
                } else {
                    print("Пользователь запретил доступ к микрофону")
                    // Здесь можно показать предупреждение или отключить функциональность
                }
            }
        }
    }
    
    static func requestSpeechRecognition() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("Пользователь разрешил распознавание речи")
                case .denied:
                    print("Пользователь запретил доступ к распознаванию речи")
                case .restricted:
                    print("Распознавание речи недоступно на этом устройстве")
                case .notDetermined:
                    print("Разрешение не было запрошено или пользователь ещё не принял решение")
                @unknown default:
                    print("Неизвестный статус")
                }
            }
        }
    }
}
