//
//  QLDichVuViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD

class QLDichVuViewController: UIViewController {

    var listDichvu: [DichVu] = [DichVu]()
    
    @IBOutlet weak var tblDichvu: UITableView!
    @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
    @IBOutlet weak var viewBody: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBody.layer.borderWidth = 2.0
        viewBody.layer.borderColor = UIColor.init(netHex: 0x5D7AFF).cgColor
        tblDichvu.delegate = self
        tblDichvu.dataSource = self
        getListDichVu()
//        loadDichvu()
    }
    
    func getListDichVu() {
        listDichvu = []
        (Storage.shared.getObjects(type: DichVu.self) as! [DichVu] ).forEach({ (dichvu) in
            if dichvu.idDichVu != ""{
                if let dichvuCopy = dichvu.copy() as? DichVu {
                    self.listDichvu.append(dichvuCopy)
                }
            }
        })
        self.constraintHeightViewBody.constant = CGFloat (200.0 +  70.0 * CGFloat(self.listDichvu.count ))
        self.tblDichvu.reloadData()
    }
    
    func loadDichvu()  {
        SVProgressHUD.show()
        QLBatDongSanService.shared.loadListDichVu( completionHandler: { (json, error) in
            if let json = json {
                self.listDichvu  = json.arrayValue.map({DichVu.init(json: $0)})
                self.listDichvu.forEach({ (dichvu) in
                    if let dichvuCopy = dichvu.copy() as? DichVu {
                        Storage.shared.addOrUpdate([dichvuCopy], type: DichVu.self)
                    }
                })
                self.tblDichvu.reloadData()
            } else if let error = error {
                Notice.make(type: .Error, content: error.localizedDescription).show()
            }
            self.constraintHeightViewBody.constant = CGFloat (200.0 +  70.0 * CGFloat(self.listDichvu.count ))
            SVProgressHUD.dismiss()
        })
    }

}

extension QLDichVuViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDichvu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QLDichVuTableViewCell.id, for: indexPath) as! QLDichVuTableViewCell
        cell.binding(dichvu: self.listDichvu[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @IBAction func themMoiDichVu(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditDichVuViewController") as! AddAndEditDichVuViewController
        currentViewController.isCreateNew = true
        currentViewController.done = {
            self.getListDichVu()
        }
        currentViewController.modalPresentationStyle = .overCurrentContext
        self.present(currentViewController, animated: true, completion: nil)
    }
    
}
extension QLDichVuViewController: eventProtocols {
    func eventEdit(_ index: Int) {
        //        let vc: EditPhieuChiViewController = UIStoryboard.init(name: "BatDongSanPopOver", bundle: nil).instantiateViewController(withIdentifier: "EditPhieuChiViewController") as! EditPhieuChiViewController
        //        vc.onUpdatePhieuChi = { (phieuchi) in
        //            self.listPhieuChi.append(phieuchi)
        //            self.tblPhieuChi.reloadData()
        //        }
        //        vc.modalPresentationStyle = .overCurrentContext
        //        vc.phieuchi = self.listPhieuChi[index]
        //        self.present(vc, animated: true, completion: nil)
        
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditDichVuViewController") as! AddAndEditDichVuViewController
        currentViewController.modalPresentationStyle = .overCurrentContext
        currentViewController.dichvu = self.listDichvu[index].copy() as! DichVu
        currentViewController.isCreateNew = false
        currentViewController.done = {
            self.getListDichVu()
        }
        self.present(currentViewController, animated: true, completion: nil)
    }
    
    func eventRemove(_ index: Int) {
        //        SVProgressHUD.show()
        //        let parameters = ["IdPhieuChi": self.listPhieuChi[index].IdPhieuChi ]
        //        QLBatDongSanService.shared.removePhieuChi(parameters: parameters) { (json , error) in
        //            SVProgressHUD.dismiss()
        //            if let error = error {
        //                Notice.make(type: .Error, content: error.localizedDescription).show()
        //            } else {
        //                Notice.make(type: .Success, content: "Xoá phiếu chi thành công !").show()
        //                Storage.shared.delete(PhieuChi.self, ids: [self.listPhieuChi[index].IdPhieuChi], idPrefix: "IdPhieuChi")
        //                self.listPhieuChi.remove(at: index)
        //                let tongtien: Double = self.listPhieuChi.reduce(0) { (obj1, obj2) -> Double in
        //                    return (Double(obj1) + Double(obj2.Sotien)! )
        //                }
        //                self.labelTongCong.text = "\(tongtien)".toNumberString(decimal: false)
        //                self.tblPhieuChi.reloadData()
        //                self.constraintHeightViewBody.constant = CGFloat (200.0 +  70.0 * CGFloat(self.listPhieuChi.count ?? 0))
        //            }
        //        }
        
        Storage.shared.delete(DichVu.self, ids: [self.listDichvu[index].idDichVu], idPrefix: "idDichVu")
        Notice.make(type: .Success, content: "Xoá Dịch vụ  thành công !").show()
        getListDichVu()
        
    }
    
    
}

