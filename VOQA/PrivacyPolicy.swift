//
//  PrivacyPolicy.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Binding var selectedTab: Int
    @State private var accepted = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 20)

                    Text("""
                    At Voqa.io, we adhere to the highest standards of data privacy. Our app does not collect, store, or share any personal data of the users. All quiz algorithms and data processing are performed on the device to ensure complete privacy and security.

                    **1. Data Collection**
                    We do not collect any personal data from our users. The app functions independently on your device.

                    **2. Data Usage**
                    Any data processed by the app is used solely for the purpose of enhancing user experience and providing accurate quiz results. No data is transmitted to external servers.

                    **3. Third-Party Services**
                    We do not use any third-party services that collect data from our users.

                    **4. User Consent**
                    By using our app, you consent to our privacy policy. If you have any questions or concerns, please contact us at support@voqa.io.
                    """)

                    Text("For more information, visit our website at Voqa.io.")
                    
                    Spacer()
                    
                    AcceptButton(title: "Accept", action: {
                        accepted = true
                        selectedTab = 2
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
