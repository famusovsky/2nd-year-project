//
//  ViewController.swift
//  Project
//
//  Created by Алексей Степанов on 2023-01-07.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // let board = Board()
        // print(board.toStr())

        var str = """
                  {
                  "width" : 2,
                  "field" : [
                  {
                  "empty" : {

                  }
                  },
                  {
                  "empty" : {

                  }
                  },
                  {
                  "empty" : {

                  }
                  },
                  {
                  "empty" : {

                  }
                  }
                  ],
                  "height" : 2
                  }
                  """
        let board2 = Board(JSON: str)
        print(board2.toStr())
    }
}

