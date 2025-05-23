import SwiftUI

struct PopupOverlay<Content: View>: View {
    let title: String
    let content: () -> Content
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                
                content()
                
                Button("إغلاق") {
                    onDismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(ButtonBackGroundColor.backgroundGradient)
                .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                .cornerRadius(10)
            }
            .padding(5)
            .frame(maxWidth: .infinity)
            .background(SecondaryBackgroundGradient.backgroundGradient)
            .cornerRadius(20)
            .shadow(radius: 10)
            // Ensure right-to-left layout for Arabic text
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

#Preview {
    PopupOverlay(
        title: "معاينة الإعدادات",
        content: {
            VStack {
                Text("محتوى تجريبي")
                Toggle("اختبار", isOn: .constant(true))
            }
        },
        onDismiss: {}
    )
    .environment(\.locale, Locale(identifier: "ar"))
}
