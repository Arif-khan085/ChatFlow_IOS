//
//  OnboardingViewModel.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//

import SwiftUI
import Combine

final class OnboardingViewModel: ObservableObject {

    @Published var currentPage = 0

    let pages: [OnboardingItem] = [

        .init(
            image: "lock.fill",
            title: "Secure Messaging",
            subtitle: "Private and protected conversations."
        ),

        .init(
            image: "brain.head.profile",
            title: "Your AI Companion",
            subtitle: "Intelligent assistance anytime."
        ),

        .init(
            image: "paperplane.fill",
            title: "Fast Communication",
            subtitle: "Instant connection with everyone."
        )
    ]

    var isLastPage: Bool {
        currentPage == pages.count - 1
    }

    func nextPage() {

        if currentPage < pages.count - 1 {
            currentPage += 1
        }
    }
}
