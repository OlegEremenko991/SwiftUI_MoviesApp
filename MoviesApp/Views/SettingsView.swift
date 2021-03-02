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
                Picker(selection: $selectedGenre, label: Text("Favorite Genre"), content: {
                    Text("Action").tag(1)
                    Text("Comedy").tag(2)
                    Text("Horror").tag(3)
                    Text("Scify").tag(4)
                })
                Section(header: Text("Email")) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text("Save")
                })
            }.navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isPresented: Binding<Bool>.constant(false))
    }
}