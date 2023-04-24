//
//  TabBarIcon.swift
//  RecipeProject
//
//  Created by Zülfiye Çakmak on 07.12.21.
//

import SwiftUI

struct TabBarIcon: View {
    let width, height: CGFloat
        let systemIconName, tabName: String
        
        
        var body: some View {
            VStack {
                Image(systemName: systemIconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .padding(.top, 10)
                Text(tabName)
                    .font(.footnote)
                Spacer()
            }
        }
    }
