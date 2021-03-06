//
//  MoviesView.swift
//  MoviesApp
//
//  Created by Олег Еременко on 02.03.2021.
//

import SwiftUI

struct MoviesView: View {

    @ObservedObject var movieManager = MovieDownloadManager()

    // MARK: - Private properties

    @State private var searchTerm = ""
    @State private var selectionIndex = 0
    @State private var tabs = ["Now Playing", "Upcoming", "Trending"]

    // MARK: - Init

    init() {
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

    // MARK: - View

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(tabs[selectionIndex])
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.medium)
                    TextField("Search...", text: $searchTerm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }.padding(.horizontal)

            // Segmented control (Picker)
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
            }.padding()
            List {
                ForEach(
                    movieManager.movies.filter {
                        searchTerm.isEmpty ? true : $0.title?.lowercased().localizedStandardContains(searchTerm.lowercased()) ?? true
                    }
                ) { movie in
                    NavigationLink(
                        destination: Text(movie.titleWithLanguage),
                        label: { MovieCell(movie: movie) }
                    ).listRowBackground(Color.clear)
                }
            }.onAppear {
                movieManager.getNowPlaying()
            }
            Spacer()
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
