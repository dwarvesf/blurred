//
//  AboutView.swift
//  Blurred
//
//  Created by phucld on 3/17/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    private let releaseVersion = Bundle.main.releaseVersionNumber ?? ""
    private let buildVersion = Bundle.main.buildVersionNumber ?? ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Image("ico_app")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                    
                    VStack(alignment: .leading) {
                        Text("Blurred")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Focus on your work")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Version \(self.releaseVersion) (\(self.buildVersion))")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                                
                VStack(alignment: .leading, spacing: 16) {
                    LinkView(imageName: "ico_compass", title: "Know more about us", link: "https://dwarves.foundation/apps")
                    LinkView(imageName: "ico_twitter", title: "Follow us on Twitter", link:"https://twitter.com/dwarvesf")
                    LinkView(imageName: "ico_github", title: "This app is fully open source", link: "https://github.com/dwarvesf/Blurred")
                    LinkView(imageName: "ico_email", title: "Email us", link: "mailto:macos@d.foundation")
                }.padding(.top, 30)
                
                Spacer()
                
                Text("MIT © Dwarves Foundation")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 0)
            }
        .padding()
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
