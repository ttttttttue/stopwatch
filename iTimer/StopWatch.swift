//
//  ViewController.swift
//  iTimer
//
//  Created by Антон Красиков on 10.11.2022.
//

import UIKit

class StopWatch: UIViewController, UITableViewDelegate,UITableViewDataSource {


    var stopWatch = Timer()
    var playTimer = true
    var lapTimer = true
    var counter = 0.0
    var lapList:[String] = []
    
    @IBOutlet weak var timerOutput: UILabel!
    
    @IBOutlet weak var lapAndResetButton: UIButton!
    
    @IBOutlet weak var table: UITableView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            table.delegate = self
            table.dataSource = self
    }
//запуск и остановка таймера
    @IBAction func startAndPauseTimer(_ sender: UIButton) {
        if playTimer {
            stopWatch = Timer.scheduledTimer(timeInterval: 0.0035, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            lapAndResetButton.isEnabled = true
            changeStartPauseButton(by: sender, "pause.fill", text: "PAUSE")
            changeLapAndResetButton(by: lapAndResetButton, "timelapse", text: "Lap")
            lapTimer = true
        }else{
            stopWatch.invalidate()
            changeStartPauseButton(by: sender, "play.fill", text: "PLAY")
            changeLapAndResetButton(by: lapAndResetButton, "clear.fill", text: "RESET")
            lapTimer = false
            
        }
    }
//отсекает отрезок времени, добавлять его в таблицу(table view) и reset(обнуление таймера)
    @IBAction func lapAndResetTimer(_ sender: UIButton) {
        if lapTimer{
            lapList.append(timerOutput.text!)
            table.reloadData()
        }else {
            guard playTimer else {return}
            lapList.removeAll()
            table.reloadData()
            timerOutput.text = "00:00"
            counter = 0.0
            
        }

    }
    @objc func updateTimer(){
        counter += 0.0035
        var minutes:String = "\((Int)(counter / 60))"
        if(Int)(counter / 60) < 10{
                minutes = "0\((Int)(counter / 60))"
        }
        
        
        //формат %.2f = 0.00
        var second: String = String(format: "%.2f", counter.truncatingRemainder(dividingBy: 60))
        if counter.truncatingRemainder(dividingBy: 60) < 10{
            second = "0" + second
        }
        timerOutput.text = minutes + ":" + second
    }
    
    func changeStartPauseButton(by button: UIButton,_ image: String, text title: String){
        playTimer = !playTimer
        button.setTitle(title, for: UIControl.State())
        button.setImage(UIImage(systemName: image), for: UIControl.State())
    }
    
    func changeLapAndResetButton   (by button: UIButton,_ image: String, text title: String){
        button.setTitle(title, for: UIControl.State())
        button.setImage(UIImage(systemName: image), for: UIControl.State())
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableRow", for: indexPath) as! TableCell
        cell.tableLabel.text = lapList[indexPath.row]
        return cell
    }
//
}


























