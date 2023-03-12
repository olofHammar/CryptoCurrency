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
                    Color.theme.textColor : Color.theme.textColorSecondary
                )

            TextField("", text: $searchText)
                .foregroundColor(Color.theme.textColor)
                .placeholder(when: !isFocused, placeholder: {
                    Text("Search by name or symbol")
                        .foregroundColor(.theme.textColorSecondary)
                })
                .autocorrectionDisabled()
                .focused($isFocused)
                .onTapGesture { setSearchBarToFocus() }
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding(.x2)
                        .offset(x: .x2)
                        .foregroundColor(Color.theme.textColorSecondary)
                        .opacity(isFocused ? 1 : 0)
                        .onTapGesture { resetSearchBar() }
                    ,alignment: .trailing
                )
        }
        .font(.textStyle.smallText)
        .padding(.x2)
        .modifier(CardModifier(cornerRadius: .x10))
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
        VStack {
            SearchBarView(searchText: .constant(""))
        }
        .frame(height: 400)
        .padding()
        .background(Color.theme.backgroundColor)
    }
}
