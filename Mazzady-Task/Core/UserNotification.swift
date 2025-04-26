//
//  UserNotification.swift
//  Mazzady-Task
//
//  Created by Mrwan on 26/04/2025.
//

import UserNotifications

func requestNotificationPermission() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error)")
        }
    }
}
