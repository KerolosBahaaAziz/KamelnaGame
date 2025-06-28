//
//  AsyncImageView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 11/06/2025.
//


import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    let placeHolder: String
    let errorImage: String

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Image(systemName: placeHolder)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height: 30)
                    .clipShape(Circle())
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height: 30)
                    .clipShape(Circle())
            case .failure:
                Image(systemName: errorImage)
                    .resizable()
                    .scaledToFit()
            @unknown default:
                Color.gray
            }
        }
    }
}
