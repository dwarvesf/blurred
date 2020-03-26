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
                HStack(alignment: .top, spacing: 44) {
                    Image("ico_app")
                        .resizable()
                        .frame(width: 120, height: 120, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Blurred")
                                    .font(.system(size: 27))
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("Focus on your work")
                                    .font(.system(size: 18))
                                    .foregroundColor(.primary)
                            }
                            
                            Text("Version \(self.releaseVersion) (\(self.buildVersion))")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 14) {
                            LinkView(imageName: "ico_compass", title: "Know more about us", link: "https://dwarves.foundation/apps")
                            LinkView(imageName: "ico_twitter", title: "Follow us on Twitter", link:"https://twitter.com/dwarvesf")
                            LinkView(imageName: "ico_github", title: "This app is fully open source", link: "https://github.com/dwarvesf/Blurred")
                            LinkView(imageName: "ico_email", title: "Email us", link: "mailto:macos@d.foundation")
                        }
                    }
                }
                .padding(.top, 44)
                .padding(.leading, 44)
                
                Spacer()
                
                Text("MIT © Dwarves Foundation")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
