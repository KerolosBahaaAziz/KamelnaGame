//
//  SessionSettings.swift
//  Kamelna
//
//  Created by Yasser Yasser on 22/05/2025.
//

import SwiftUI

struct SessionSettings: View {
    
    @Binding var matchType: String
    @Binding var numberOfTeams: String
    @Binding var cupType: String
    @Binding var scheduledHours: Int
    @Binding var scheduledMinutes: Int


    @State private var showTimePicker: Bool = false
    private let matchTypeOptions = ["قهوه واحده", "الافضل من 3 قهوات", "قهوه واحده النهائي:الافضل من 3 قهوات"]
    private let teamNumber = ["8 فريق/16 عضو", "16 فريق/32 عضو", "32 فريق/64 عضو"]
    private let cupTypeOptions = ["فوري", "مجدول"]
    private let hoursOptions = Array(0...23)
    private let minutesOptions = Array(0...59)

    
    // Computed property for schedule description
    private var scheduleDescription: String {
        if cupType == "فوري" {
            return "ستبدأ الكأس بعد 15 دقيقة"
        } else {
            if scheduledHours > 0 && scheduledMinutes > 0 {
                return "ستبدأ الكأس بعد \(scheduledHours) ساعة و \(scheduledMinutes) دقيقة"
            } else if scheduledHours > 0 {
                return "ستبدأ الكأس بعد \(scheduledHours) ساعة"
            } else if scheduledMinutes > 0 {
                return "ستبدأ الكأس بعد \(scheduledMinutes) دقيقة"
            } else {
                return "سيتم تحديد وقت البدء"
            }
        }
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Cup Type Segmented Picker
            Text("نوع الدوري")
                .padding(.horizontal)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
            Picker("نوع الكأس", selection: $cupType) {
                ForEach(cupTypeOptions, id: \.self) { type in
                    Text(type)
                        .tag(type)
                        .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
                }
            }
            .pickerStyle(.segmented)
            .tint(ButtonBackGroundColor.backgroundGradient) // Main color
            .background(UnSelectedButtonBackGroundColor.backgroundGradient) // Background color
            .environment(\.layoutDirection, .rightToLeft)
            .onChange(of: cupType) { _ , newValue in
                if newValue == "مجدول" {
                    showTimePicker = true
                } else {
                    showTimePicker = false
                }
            }
            
            // Schedule description text
            HStack{
                if cupType == "فوري"{
                    Image("time")
                        .resizable()
                        .frame(width: 25 ,height: 25)
                }else {
                    Image("schedule")
                        .resizable()
                        .frame(width: 25,height: 25)
                }
                Text(scheduleDescription)
                    .font(.subheadline)
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    .environment(\.layoutDirection, .rightToLeft)
            }
            
            // Conditional time picker for scheduled cup
            if cupType == "مجدول" && showTimePicker {
                VStack {
                    HStack {
                        Picker("الساعات", selection: $scheduledHours) {
                            ForEach(hoursOptions, id: \.self) { hour in
                                Text("\(hour) ساعة").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                        
                        Picker("الدقائق", selection: $scheduledMinutes) {
                            ForEach(minutesOptions, id: \.self) { minute in
                                Text("\(minute) دقيقة").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                    }
                    .environment(\.layoutDirection, .rightToLeft)
                    
                    Button(action: {
                        showTimePicker = false
                    }) {
                        Text("تأكيد")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ButtonBackGroundColor.backgroundGradient)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            
            // Match Type and Number of Teams Pickers
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    HStack{
                        Image("card")
                            .resizable()
                            .frame(width: 25,height: 25)
                        Text("نوع المباراة")
                            .font(.subheadline)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    }
                    Picker("", selection: $matchType) {
                        ForEach(matchTypeOptions, id: \.self) { type in
                            Text(type)
                                .tag(type)
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(.black)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack{
                        Image("armchair")
                            .resizable()
                            .frame(width: 25,height: 25)
                        Text("عدد الفرق")
                            .font(.subheadline)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                    }
                    Picker("", selection: $numberOfTeams) {
                        ForEach(teamNumber, id: \.self) { team in
                            Text(team).tag(team)
                                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(.black)
                }
            }
        }
        .padding()
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    struct SessionSettingsPreview: View {
        @State private var matchType = "Single"
        @State private var numberOfTeams = "8 فريق/16 عضو"
        @State private var cupType = "فوري"
        @State private var minutes = 10
        @State private var seconds = 12
        var body: some View {
            SessionSettings(
                matchType: $matchType,
                numberOfTeams: $numberOfTeams,
                cupType: $cupType,scheduledHours: $minutes,
                scheduledMinutes: $seconds
            )
            .environment(\.locale, Locale(identifier: "ar"))
        }
    }
    return SessionSettingsPreview()
}
