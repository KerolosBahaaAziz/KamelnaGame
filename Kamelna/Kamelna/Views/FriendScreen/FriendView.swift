import SwiftUI

struct FriendView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var userViewModel : UserViewModel
    @State var showRequest = false
   
    
    var body: some View {
        
        NavigationView{
            ZStack{
                BackgroundGradient.backgroundGradient.ignoresSafeArea()
              
                VStack{
                    HStack{
                        Button {
                            showRequest.toggle()
                        } label: {
                            Text("طلبات")
                        }.padding(10)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .background(ButtonBackGroundColor.backgroundGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        Text("الاصدقاء")
                            .font(.title)
                            .foregroundStyle(.black)
                            .padding(.leading,50)
                            .padding(.trailing, 50)
                        Button {
                            dismiss()
                        } label: {
                            Text("عوده")
                        }.padding(10)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .background(ButtonBackGroundColor.backgroundGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        NavigationLink(destination: RequestView(userViewModel: userViewModel), isActive: $showRequest) {
                            EmptyView()
                        }
                        
                    }.padding(.bottom,20)
                        .frame(alignment: .top)
                
                    ZStack{
                    
                        SecondaryBackgroundGradient.backgroundGradient
                        if !userViewModel.isLoading{
                            if  !userViewModel.friendList.isEmpty {
                                List {
                                    ForEach(userViewModel.friendList, id: \.id) { user in
                                        
                                        FriendRowBasic(userViewModel: userViewModel, user: user)
                                        
                                    }.listRowBackground(Color.clear)
                                }.scrollContentBackground(.hidden)
                            }else{
                                Text("لا يوجد لديك اصدقاء")
                            }
                        }else{
                            VStack(spacing: 16) {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                        .scaleEffect(1.5)
                                    Text("جارى التحميل ...")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                                
                        }
                       
                        
                    }.clipShape(RoundedRectangle(cornerRadius: 25))
                        .frame(width: UIScreen.main.bounds.width - 50, height:  UIScreen.main.bounds.height - 200  )
                }
                
            }
           
        }
           
        
    }
}
