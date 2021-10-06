//
//  HomeTabView.swift
//  MoviesApp
//
//  Created by Олег Еременко on 01.03.2021.
//

import SwiftUI

struct HomeTabView: View {
    @State private var selectedTab = Tab.movie

    var body: some View {
        TabView(selection: $selectedTab) {
            MoviesView().tabItem {
                tabbarItem(
                    text: "Movies",
                    imageName: "film")
            }
            .tag(Tab.movie)
            DiscoverView().tabItem {
                tabbarItem(
                    text: "Discover",
                    imageName: "square.stack")
            }
            .tag(Tab.discover)
        }
    }
}

private extension HomeTabView {
    enum Tab: Int {
        case movie
        case discover
    }

    func tabbarItem(
        text: String,
        imageName: String
    ) -> some View {
        VStack {
            Image(systemName: imageName)
                .imageScale(.large)
            Text(text)
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
