//
//  ProjectsButtonsView.swift
//  Kamelna
//
//  Created by Kerlos on 20/06/2025.
//

import SwiftUI

struct ProjectsButtonsView: View {
    @StateObject private var viewModel = ProjectViewModel.shared
    
    let roundButtons = ["400" , "100" , "50" , "سرا"]
    let roomId = UserDefaults.standard.string(forKey: "roomId")
    let userId = UserDefaults.standard.string(forKey: "userId")
    var ifAvailable: Bool = false
    
    var body: some View {
        VStack {
            let columnCount = roundButtons.count <= 3 ? roundButtons.count : 2
            let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: columnCount)
            
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(roundButtons, id: \.self) { title in
                    actionButton(title: title, action: {
                        checkIfCanAddThisProject(project: title)
                    })
                    //.disabled(!(viewModel.currentSelector == viewModel.userId && !viewModel.roundTypeChosen))
                }
            }
            .padding(.vertical, 6)
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -3)
        }
    }
    
    func checkIfCanAddThisProject(project: String){
        viewModel.fetchDataForProjectChecking(roomId: roomId ?? "", userId: userId ?? "") { hand, team, roundType in
            let projectType = mapPjectString(project: project)
            let ifAvailable = viewModel.canChooseProject(hand: hand, roundType: roundType, projectType: projectType)
            if ifAvailable{
                viewModel.addProjectToRoom(team: team == "1" ? "team1" : "team2", projectType: projectType)
            }else {
                print("not availble to add this project")
            }
        }
    }
    
    func mapPjectString(project: String) -> ProjectTypes{
        switch project{
        case "400":
            return .fourHundred
        case "100":
            return .hundred
        case "50":
            return .fifty
        case "سرا":
            return .sra
        default:
            return .fifty // or any case, this case must nnever happened
        }
    }
    
    // MARK: - Reusable Button Views
    func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .frame(minWidth: 110)
                .padding(.vertical, 4)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                .background(ButtonBackGroundColor.backgroundGradient)
                .cornerRadius(10)
        }
    }
}

#Preview {
    ProjectsButtonsView()
}
