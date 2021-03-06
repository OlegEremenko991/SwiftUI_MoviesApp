//
//  HomeTabView.swift
//  MoviesApp
//
//  Created by Олег Еременко on 01.03.2021.
//

import SwiftUI

struct HomeTabView: View {

    // MARK: - Private properties

    private enum Tab: Int {
        case movie
        case discover
    }

    @State private var selectedTab = Tab.movie

    // MARK: - View

    var body: some View {
        TabView(selection: $selectedTab,
                content:  {
                    MoviesView().tabItem {
                        tabbarItem(text: "Movies", imageName: "film") }
                        .tag(Tab.movie)
                    DiscoverView().tabItem {
                        tabbarItem(text: "Discover", imageName: "square.stack") }
                        .tag(Tab.discover)
                })
    }

    /// Creates a tabItem with specified text and image
    private func tabbarItem(text: String, imageName: String) -> some View {
        VStack {
            Image(systemName: imageName)
                .imageScale(.large)
            Text(text)
        }
    }
}

// MARK: - Preview

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
