//
//  PreferenceView.swift
//  Dimmer Bar
//
//  Created by Trung Phan on 1/7/20.
//  Copyright © 2020 Dwarves Foundation. All rights reserved.
//

import SwiftUI

struct GeneralView: View {
    @ObservedObject var setting: SettingObservable
    
    var body: some View {
        VStack {
            HStack {
                Text("Blurred level").bold()
                Spacer()
            }
            
            GeometryReader { geometry in
                ZStack {
                    Image("desktop")
                        .resizable()
                        .overlay(Color.black.opacity(self.setting.isEnabled ? self.setting.alpha/100.0 : 0))
                        .cornerRadius(4)
                    
                    Image("window")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400)
                }
                .frame(width: geometry.size.width)
            }
            
            
            HStack {
                Text("10%")
                
                Slider(value: $setting.alpha, in: 10...100, step: 10)
                    .disabled(!setting.isEnabled)

                Text("100%")
            }
            
            HStack(alignment: .center) {
                
                VStack(alignment: .leading) {
                    Picker(selection: $setting.dimMode, label:
                        Text("Blur mode").bold()
                    ) {
                        Text("Single").tag(DimMode.single)
                        Text("Parallel").tag(DimMode.parallel)
                    }.fixedSize()
                    
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
                            RoundedRectangle(cornerRadius: 2).foregroundColor(Color(NSColor.controlLightHighlightColor)) :
                            RoundedRectangle(cornerRadius: 2).foregroundColor(.clear)
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
        }.padding()
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView(setting: DimManager.sharedInstance.setting)
    }
}
