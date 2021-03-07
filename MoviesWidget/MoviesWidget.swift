//
//  MoviesWidget.swift
//  MoviesWidget
//
//  Created by Олег Еременко on 07.03.2021.
//

import WidgetKit
import SwiftUI

struct MovieEntry: TimelineEntry {
    let date: Date
    let movie: Movie
}

struct Provider: TimelineProvider {

    @AppStorage("RecentlyOpenedMovie", store: UserDefaults(suiteName: "group.com.oleg991.MoviesApp"))
    var recentlyOpenedMovie = Data()

    func placeholder(in context: Context) -> MovieEntry {
        MovieEntry(date: Date(), movie: Movie(title: "-"))
    }

    func getSnapshot(in context: Context, completion: @escaping (MovieEntry) -> Void) {
        guard let movie = try? JSONDecoder().decode(Movie.self, from: recentlyOpenedMovie) else { return }
        let entry = MovieEntry(date: Date(), movie: movie)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MovieEntry>) -> Void) {
        guard let movie = try? JSONDecoder().decode(Movie.self, from: recentlyOpenedMovie) else { return }
        let entry = MovieEntry(date: Date(), movie: movie)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct MoviesWidgetEntryView: View {
    let entry: Provider.Entry

    var body: some View {
        VStack {
            Spacer()
            Text(entry.movie.title ?? "")
                .font(.title)
            Text("Release date: \(entry.movie.release_date ?? "") ")
            Spacer()
        }
    }
}

@main
struct MoviesWidget: Widget {
    private let kind = "MoviesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()) {
            MoviesWidgetEntryView(entry: $0)
        }
    }
}

