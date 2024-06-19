//
//  TermsAndConditions.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import SwiftUI


struct TermsAndConditionsView: View {
    @Binding var selectedTab: Int
    @State private var accepted = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Terms and Conditions")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 20)

                    Text("""
                    Welcome to Voqa.io. By using our application, you agree to the following terms and conditions:

                    **1. Acceptance of Terms**
                    By accessing and using our app, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.

                    **2. Changes to Terms**
                    Voqa.io reserves the right to change these terms from time to time as it sees fit, and your continued use of the site will signify your acceptance of any adjustment to these terms.

                    **3. Intellectual Property**
                    The app and its original content, features, and functionality are and will remain the exclusive property of Voqa.io.

                    **4. User Conduct**
                    Users agree to use the app for lawful purposes only and must not use it to engage in any conduct that is unlawful or that restricts or inhibits anyone’s use or enjoyment of the app.

                    **5. Limitation of Liability**
                    Voqa.io is not liable for any damages that may occur as a result of using the app.

                    **6. Governing Law**
                    These terms shall be governed and construed in accordance with the laws of the jurisdiction in which Voqa.io operates.

                    **7. User Accounts**
                    Users are responsible for maintaining the confidentiality of their account information and for all activities that occur under their account. Voqa.io reserves the right to terminate accounts, edit or remove content, and cancel orders at its sole discretion.

                    **8. Termination**
                    Voqa.io reserves the right to terminate your access to the app, without any advance notice.

                    **9. Contact Information**
                    If you have any questions about these terms, please contact us at support@voqa.io.

                    **10. Disclaimer of Warranties**
                    The app is provided on an "as is" and "as available" basis. Voqa.io makes no representations or warranties of any kind, express or implied, as to the operation of the app or the information, content, or materials included on the app.

                    **11. Indemnification**
                    You agree to indemnify and hold Voqa.io harmless from any demands, loss, liability, claims or expenses (including attorneys' fees), made against Voqa.io by any third party due to or arising out of or in connection with your use of the app.

                    **12. Dispute Resolution**
                    Any disputes arising out of or relating to these terms or the app will be resolved through binding arbitration in accordance with the rules of the jurisdiction in which Voqa.io operates.
                    """)

                    Spacer()
                    
                    AcceptButton(title: "Accept", action: {
                        accepted = true
                        selectedTab = 3
                    }, isEnabled: !accepted)
                }
                .padding()
                .foregroundColor(.white)
            }
            .preferredColorScheme(.dark)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
