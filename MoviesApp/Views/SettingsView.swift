//
//  SettingsView.swift
//  MoviesApp
//
//  Created by Олег Еременко on 02.03.2021.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @State private var selectedGenre = 1
    @State private var email = ""

    var body: some View {
        NavigationView {
            Form {
                genrePicker
                Section(header: Text("Email")) {
                    TextField("Email", text: $email)
                }
                saveButton
            }
            .navigationTitle("Settings")
        }
    }
}

private extension SettingsView {
    var genrePicker: some View {
        Picker(
            selection: $selectedGenre,
            label: Text("Favorite Genre")
        ) {
            Text("Action").tag(1)
            Text("Comedy").tag(2)
            Text("Horror").tag(3)
            Text("Scify").tag(4)
        }
    }

    var saveButton: some View {
        Button {
            isPresented.toggle()
        } label: {
            Text("Save")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isPresented: Binding<Bool>.constant(false))
    }
}
