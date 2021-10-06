//
//  MoviesView.swift
//  MoviesApp
//
//  Created by Олег Еременко on 02.03.2021.
//

import SwiftUI

struct MoviesView: View {
    @StateObject private var movieManager = MovieDownloadManager()
    @State private var searchTerm = ""
    @State private var selectionIndex = Int.zero
    @State private var tabs = ["Now Playing", "Upcoming", "Trending"]

    init() {
        setupAppearance()
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                titleView
                searchViewWithTextField
            }
            .padding(.horizontal)
            segmentedControlPicker
            moviesList
            Spacer()
        }
    }
}

private extension MoviesView {
    func setupAppearance() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionStyle = .none
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .orange
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.orange]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var titleView: some View {
        Text(tabs[selectionIndex])
            .font(.largeTitle)
            .bold()
            .foregroundColor(.red)
            .padding(.top)
    }

    var searchViewWithTextField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .imageScale(.medium)
            TextField("Search...", text: $searchTerm)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }

    var moviesList: some View {
        List {
            ForEach(movieManager.movies.filter {
                searchTerm.isEmpty ? true : $0.title?.lowercased()
                    .localizedStandardContains(searchTerm.lowercased()) ?? true
                }) { movie in
                NavigationLink(
                    destination: MovieDetailView(movie: movie),
                    label: { MovieCell(movie: movie) }
                )
                .listRowBackground(Color.clear)
            }
        }
        .onAppear { movieManager.getNowPlaying() }
    }

    var segmentedControlPicker: some View {
        VStack {
            Picker("_", selection: $selectionIndex) {
                ForEach(0..<tabs.count) { index in
                    Text(tabs[index])
                        .font(.title)
                        .bold()
                        .tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectionIndex) { _ in
                switch selectionIndex {
                case 0: movieManager.getNowPlaying()
                case 1: movieManager.getUpcoming()
                case 2: movieManager.getPopular()
                default: break
                }
            }
        }
        .padding()
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
