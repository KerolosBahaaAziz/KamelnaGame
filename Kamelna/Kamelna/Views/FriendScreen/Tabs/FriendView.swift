import SwiftUI

struct FriendView: View {
 
    @ObservedObject var userViewModel : UserViewModel
    @State var showRequest = false
   
    
    var body: some View {
        
        NavigationView{
            ZStack{
                BackgroundGradient.backgroundGradient.ignoresSafeArea()
              
                VStack{

                
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
                        .frame(width: UIScreen.main.bounds.width - 20, height:  UIScreen.main.bounds.height - 220  )
                }
                
            }
           
        }
           
        
    }
}
