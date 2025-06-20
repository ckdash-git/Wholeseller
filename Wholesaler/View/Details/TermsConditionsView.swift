//
//  TermsConditionsView.swift
//  Wholeseller
//
//  Created by CHANDAN on 18/06/25.
//

import SwiftUI

struct TermsConditionsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Terms & Conditions")
                    .font(.largeTitle)
                    .bold()
                Text("By using this app, you agree to our terms and conditions. This includes responsible usage, no unauthorized access or misuse of information, and compliance with all applicable laws and regulations.")
                Text("The app reserves the right to update these terms at any time. Continued usage implies acceptance of the latest version.")
            }
            .padding()
        }
    }
}
