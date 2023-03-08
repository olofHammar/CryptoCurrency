//
//  SearchBarView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import SwiftUI

struct SearchBarView: View {

    @Binding var searchText: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    isFocused ?
                    Color.theme.textColor : Color.theme.purpleBlue
                )

            TextField("", text: $searchText)
                .foregroundColor(Color.theme.textColor)
                .placeholder(when: !isFocused, placeholder: {
                    Text("Search by name or symbol")
                        .foregroundColor(.theme.purpleBlue)
                })
                .autocorrectionDisabled()
                .focused($isFocused)
                .onTapGesture { setSearchBarToFocus() }
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding(16)
                        .offset(x: 16)
                        .foregroundColor(Color.theme.purpleBlue)
                        .opacity(isFocused ? 1 : 0)
                        .onTapGesture { resetSearchBar() }
                    ,alignment: .trailing
                )
        }
        .font(.textStyle.smallText)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.theme.backgroundColor)
                .shadow(
                    color: .theme.blueShadow,
                    radius: 4, x: 0, y: 0
                )
        )
        .animation(.easeInOut, value: isFocused)
        .onChange(of: isFocused) { newValue in
            if !newValue {
                self.searchText = ""
            }
        }
    }

    private func setSearchBarToFocus() {
        isFocused = true
    }

    private func resetSearchBar() {
        UIApplication.shared.endEditing()
        isFocused = false
        searchText = ""
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
    }
}
