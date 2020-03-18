//
//  LinkView.swift
//  Blurred
//
//  Created by phucld on 3/17/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import SwiftUI

struct LinkView: View {
    var imageName: String
    var title: String
    var link: String
    var body: some View {
        HStack {
            Button(action: {
                if let url = URL(string: self.link) {
                    NSWorkspace.shared.open(url)
                }
            }) {
                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .foregroundColor(.primary)
                    
                    Text(title)
                        .foregroundColor(.primary)
                }
            }.buttonStyle(LinkButtonStyle())
        }
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView(imageName: "ico_compass", title: "Know more about us", link: "https://dwarves.foundation/apps")
    }
}
