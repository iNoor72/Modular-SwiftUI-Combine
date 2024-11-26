//
//  AppStrings.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 26/11/2024.
//


enum AppStrings {
    static let noNetworkAlertMessage = "You're not connected to network, you'll be using the app in the offline mode"
    static let fetchingMoreDataString = "Fetching more movies..."
    static let tryingToConnectString = "Trying to connect to network..."
    
    enum ErrorDescriptions {
        static let emptryDataErrorDescription = "The data fetched is empty"
        static let fetchingErrorDescription = "An error happened when fetching data, please try again"
        static let urlConstructionErrorDescription = "There was an error getting data from URL. Please try again later"
        static let noNetworkErrorDescription = "You're offline. Please reconnect to the network"
        static let serverFetchingErrorDescription = "There was an error fetching your data from server"
    }
}
