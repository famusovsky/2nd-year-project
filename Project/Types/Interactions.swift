//
// Created by Алексей Степанов on 2023-01-11.
//

import Foundation

struct Interactions: Codable {
    let onGoForward: [Action]
    let onGoLeft: [Action]
    let onGoRight: [Action]
    let onTap: [ActionLocation:[Action]]
    
    init(onGoForward: [Action], onGoLeft: [Action], onGoRight: [Action], onTap: [ActionLocation:[Action]]) {
        self.onGoForward = onGoForward
        self.onGoLeft = onGoLeft
        self.onGoRight = onGoRight
        self.onTap = onTap
    }
}
