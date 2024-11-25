//
//  AppConfiguration.swift
//  GitHub-repos-browser
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public enum AppConfiguration {
    public static let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
    public static let imagesBaseURL = Bundle.main.object(forInfoDictionaryKey: "IMAGES_BASE_URL") as? String ?? ""
    public static let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
}
