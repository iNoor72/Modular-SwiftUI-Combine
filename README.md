# 🍏 Modular-SwiftUI-Combine
Modular-SwiftUI-Combine is my implementation for an iOS app to show movies from TMDB website with Modular Architecture.

## Description
Modular-SwiftUI-Combine is an iOS app to fetch and present trending movies and their details from TMDB website.

## Getting started
To run the project, you simply open the project and wait for packages to be downloaded.
#### - The app requires an API key from TMDB website to run it, please use your own API key in the Configuration.xcconfig file to the "API_KEY" variable shown in the following screenshot:
![Screenshot 2024-12-01 at 8 17 53 PM](https://github.com/user-attachments/assets/0ef88878-22c9-4b56-a312-e42e1ee7b6f1)

#### - Note: Please run the app on a physical device for better handling for the network connection and caching.

## Video overview
| Normal mode | Offline mode |
|:----------- |:-------------:|
| ![9cb3vv](https://github.com/user-attachments/assets/939ff32b-2365-46cf-b933-f0bd24636562)  | ![Simulator Screen Recording - iPhone 16 Pro Max - 2024-12-02 at 13 06 47](https://github.com/user-attachments/assets/89257d8f-ce3a-4dc9-b510-368c2cbfe6c3)


## Tech stack
- Swift and SwiftUI.
- Reactive binding using Combine.
- SPM for handling packages.
- Used MVVM-C UI Design Pattern applying Clean Architecture principles (UseCase, Repository, Layers, Factory Method) for scalability and testablity. For more info, <a href="https://www.google.com](https://inoor.hashnode.dev/clean-mvp-with-swift">click here</a> to view my article about applying Clean Architecrture principles to any UI Design Pattern.
- Coordinator/Router pattern in a UIKit-based approach, I've used this for better flexibility and better navigation handling. For the SwiftUI version of it, please check my <a href="https://gist.github.com/iNoor72/d2bf1f71d10c7b5ee3976fa5c9694ed7">SwiftUI Coordinator</a> gist.
- In-memory image caching using CacheAsyncImage, a component that uses SwiftUI AsyncImage with caching up to 30 images. It's much more preffered to use **Disk Caching** using **Kingfisher** or **SDWebImage** for images (especially large ones) but this approach seems simple enough for the project.
- Caching to support offline mode using Core Data.
- Error handling for network and caching errors.
- Unit testing for all layers of the app.
- Supporting iOS 16.0 and newer.

## Main Features
- List the trending movies for the user to browse them.
- List of genres to filter the movies.
- Search bar to add search functionality to the app.
- Detailed view to show the image, the headline, and the publishing date of a movie.
- Details view for the user to show the details of the desired movie including: title, image, poster, year of release, genres, overview, homepage, budget, revenue, spoken languages, status, and runtime.
- Error handling for data fetching errors.

### Bonus features:
- Pagination for loading movies.
- Used DTO for providing data from Repository -> UseCase -> ViewModel -> View.
- Mocking for the network layer and other components.
- Unit testing for the all layers (Network, Cache, UseCases, Factories, Repositories, and ViewModels) using the Mocks.

## Packages / Modules
- NetworkLayer: A module for handling all network-related work. Built using Combine and URLSession with Endpoint protocol mechanism.
- CachingLayer: A module for handling all caching-related work. Build with Core Data.
- Reachability: A library for handling all network statuses of the device. I've used it because it's proven that it's the most stable framework for handling network scenarios among other solutions.
