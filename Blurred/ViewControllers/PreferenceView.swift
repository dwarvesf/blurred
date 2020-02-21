//
//  PreferenceView.swift
//  Dimmer Bar
//
//  Created by Trung Phan on 1/7/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import SwiftUI

struct PreferenceView: View {
    @ObservedObject var setting: SettingObservable
    @State private var tag = 1
    
    var body: some View {
        VStack {
            Picker(selection: self.$tag, label: Text("Picker")) {
                Text("Settings").tag(1)
                Text("About").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .frame(width: 200)
            .padding()
            
            HStack {
                Text(self.tag == 1 ? "Settings" : "About")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }.padding()
            
            if self.tag == 1 {
                SettingView(setting: setting).padding()
            } else {
                AboutView()
            }
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView(setting: DimManager.sharedInstance.setting)
    }
}

struct SettingView: View {
    @ObservedObject var setting: SettingObservable
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Image("desktop")
                        .resizable()
                        .scaledToFit()
                        .overlay(Color.black.opacity(setting.isEnabled ? setting.alpha/100.0 : 0))
                        .frame(maxWidth: .infinity)
                        
                    
                    Image("window")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400)
                }
                .frame(width: 600, height: 320)
            }
            
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    
                    Toggle(isOn: $setting.isEnabled) {
                        Text("Enable Blurred")
                    }.padding(.top)
                 
                    Toggle(isOn: $setting.isStartWhenLogin) {
                        Text("Start Blurred when log in")
                    }
                    
                    Toggle(isOn: $setting.isOpenPrefWhenOpenApp) {
                        Text("Open Preferences Window when login")
                    }
                    .padding(.bottom, 10)
                    
                    Picker(selection: $setting.dimMode, label: Text("Dim mode")) {
                        Text("Single").tag(DimMode.single)
                        Text("Parallel").tag(DimMode.parallel)
                    }.fixedSize()
                    
                    Text("Dimmer level:")
                    HStack {
                        Text("10%")
                        Slider(value: $setting.alpha, in: 10...100, step: 10)
                            .frame(width: 200)
                            .disabled(!setting.isEnabled)
                        Text("\(setting.alpha, specifier: "%.f")%")
                    }
                    
                }
                Spacer()
                VStack(alignment: .center) {
                    Text("Global shortcut")
                        .font(.headline)
                    HStack(spacing: 0) {
                        
                        Button(setting.currentHotkeyLabel) {
                            self.setting.isListenningForHotkey = true
                        }
                        .background(setting.isListenningForHotkey ?
                            RoundedRectangle(cornerRadius: 2).foregroundColor(Color(NSColor.controlHighlightColor)) :
                            RoundedRectangle(cornerRadius: 2).foregroundColor(Color(NSColor.controlBackgroundColor))
                        )
                        
                        Button("⌫") {
                            self.setting.isListenningForHotkey = false
                            self.setting.currentHotkeyLabel = "Set Hotkey"
                            self.setting.globalHotkey = nil
                            let appDelegate = NSApplication.shared.delegate as! AppDelegate
                            appDelegate.hotKey = nil
                        }
                        .disabled(setting.isListenningForHotkey || setting.globalHotkey == nil)
                    }
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.secondary.opacity(0.5))
                    )
                    
                }
            }
        }
    }
}


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
                        .antialiased(true)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.primary)
                    
                    Text(title)
                        .foregroundColor(.primary)
                }
            }.buttonStyle(LinkButtonStyle())
        }
    }
}


struct AboutView: View {
    private let releaseVersion = Bundle.main.releaseVersionNumber ?? ""
    private let buildVersion = Bundle.main.buildVersionNumber ?? ""
    
    var body: some View {
        VStack {
            HStack {
                Image("ico_app")
                    .antialiased(true)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)

                
                VStack(alignment: .leading) {
                    Text("Blurred")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Focus to your work")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Version \(releaseVersion) (\(buildVersion))")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            .background(Color.white.opacity(0.1))
            
            VStack(alignment: .leading, spacing: 16) {
                LinkView(imageName: "ico_compass", title: "Know more about us", link: "https://dwarves.foundation/apps")
                LinkView(imageName: "ico_twitter", title: "Follow us on Twitter", link:"https://twitter.com/dwarvesf")
                LinkView(imageName: "ico_github", title: "This app is fully open source", link: "https://github.com/dwarvesf/Blurred")
                LinkView(imageName: "ico_email", title: "Email us", link: "mailto:macos@d.foundation")
            }
            
            Text("MIT © Dwarves Foundation")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.bottom)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
