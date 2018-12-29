//
//  AddAndEditCanHoViewController.swift
//  AppQLBatDongSan
//
//  Created by NNX on 11/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import Photos

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

class AddAndEditCanHoViewController: UIViewController {
    
    @IBOutlet weak var tfTieuDe: MyTextField!
    @IBOutlet weak var tfDiaChi: MyTextField!
    @IBOutlet weak var tfGiaPhong: MyNumberField!
    @IBOutlet weak var tfDienTich: MyNumberField!
    
    @IBOutlet weak var collectionViewCanHo: UICollectionView!
    @IBOutlet weak var tvThongtinMota: UITextView!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    @IBOutlet weak var checkboxGroupDichVu: MyCheckboxGroup!
    
    @IBOutlet weak var constraintHeightGroupDichVu: NSLayoutConstraint!
    
    var isCreateNew: Bool = true
    var canHo: CanHo? = nil
    var done: ((_ CanHo: CanHo)->())?
    let manager = Alamofire.SessionManager()
    var listDichVu: [DichVu] = []
    var listDichVu_Canho: [CanHo_DichVu] = []
    var listImage: [UIImage] = []
    let imageVC = UIImagePickerController()
    var dictDichVu: [Int: (key: String, value: String)] = [:]
    
    override func viewDidLoad() {
        checkboxGroupDichVu.clipsToBounds = true
        labelHeaderTitle.text = isCreateNew == true ? "Tạo Căn hộ" : "Sửa Căn hộ"
        listDichVu = Storage.shared.getObjects(type: DichVu.self) as! [DichVu]
        configService()
        for index in 0..<listDichVu.count {
            dictDichVu[index] = (key: listDichVu[index].idDichVu, value: listDichVu[index].TenDichVu)
        }
        checkboxGroupDichVu.addTitleAndOptions("", options: dictDichVu.mapValues({$0.value}), isRadioBox: false, minSelectionCount: 0, optionWidth: self.checkboxGroupDichVu.frame.width)
        if !isCreateNew {
            tfTieuDe.text = self.canHo?.TieuDe
            tfDiaChi.text = self.canHo?.DiaChi
            let giaphong = Double(self.canHo?.DonGia ?? "") ?? 0
            let dientich = (Double(self.canHo?.DienTich ?? "") ?? 0 )
            tfGiaPhong.setValue(giaphong)
            tfDienTich.setValue(dientich)
            tvThongtinMota.text = self.canHo?.MoTa
            
            listDichVu_Canho = Storage.shared.getObjects(type: CanHo_DichVu.self) as! [CanHo_DichVu]
            let getDichVu_Canho = listDichVu_Canho.filter({$0.IdCanHo == self.canHo?.IdCanHo}).first
            let convertDichVu = getDichVu_Canho?.IdDichVu.components(separatedBy: ",")
            var arrayOptiondictDichVu: [Int] = []
            for item in dictDichVu.values {
                if convertDichVu?.filter({ $0 == item.key}).first != nil {
                    if let index = listDichVu.firstIndex(where: { $0.idDichVu == item.key}) {
                        arrayOptiondictDichVu.append(index)
                    }
                }
            }
            checkboxGroupDichVu.selectetedOption(indexs: arrayOptiondictDichVu)
            loadImage()
        } else {
            tfGiaPhong.setValue("0")
            tfDienTich.setValue("0")
        }
        var count = listDichVu.count % 2 == 0 ? listDichVu.count : listDichVu.count - 1
        if count == 0 {
            constraintHeightGroupDichVu.constant =  50
        } else {
            constraintHeightGroupDichVu.constant = CGFloat( count * 50)
        }

        collectionViewCanHo.delegate = self
        collectionViewCanHo.dataSource = self
        tfDienTich.setAsNumericKeyboard(type: .integer, autoSelectAll: false)
        tfGiaPhong.setAsNumericKeyboard(type: .money, autoSelectAll: false)
        tvThongtinMota.layer.cornerRadius = 6.0
        tvThongtinMota.layer.borderWidth = 2.0
        tvThongtinMota.layer.borderColor = MyColor.lightGray.cgColor
        viewBody.layer.cornerRadius = 6.0
    }
    
    func loadImage(){
        let serialQueue = DispatchQueue(label: "queuename")
        
        let getListImage = self.canHo?.AnhCanHo.split(separator: ",")
        for item in getListImage ?? [] {
            serialQueue.sync {
                // The image to dowload
                let stringUrl = "https://localhost:5001/CanHo/Image/\(item)"
                if let remoteImageURL = URL(string: stringUrl) {
                    manager.request(remoteImageURL).responseData { (response) in
                        if response.error == nil {
                            if let data = response.data {
                                if let img = UIImage(data: data) {
                                    self.listImage.append(img)
                                    self.collectionViewCanHo.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    func configService() {
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: (challenge.protectionSpace.serverTrust ?? nil)!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = self.manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            
            return (disposition, credential)
        }
    }
    
    @IBAction func tao(_ sender: Any) {
        let canHo = CanHo()
        canHo.IdCanHo = isCreateNew ? "" : self.canHo?.IdCanHo ?? ""
        canHo.NgayTao = isCreateNew ? Date().toString(format: "yyyy-MM-dd") ?? "" : self.canHo?.NgayTao.formatDate(date: "MM-dd/yyyy HH:mm:ss ", dateTo: "YYYY-MM-dd") ?? ""
        canHo.DonGia =  "\(Int(tfGiaPhong.getValue()))"
        canHo.DienTich = "\(Int(tfDienTich.getValue()))"
        canHo.DiaChi = tfDiaChi.text ?? ""
        canHo.MoTa = tvThongtinMota.text ?? ""
        if canHo.AnhCanHo.isEmpty {
            canHo.AnhCanHo = "anh1.jpg,anh2.jpg,anh3.jpg"
            //            Notice.make(type: .Error, content: "Ảnh căn hộ không được rỗng").show()
            //            return
        }
        canHo.TieuDe = tfTieuDe.text ?? ""
        let parameters: [String: String] = [
            "IdCanHo" : canHo.IdCanHo,
            "DonGia" : canHo.DonGia,
            "DienTich" : canHo.DienTich,
            "DiaChi" : canHo.DiaChi,
            "TieuDe" : canHo.TieuDe,
            "MoTa" : canHo.MoTa,
            "AnhCanHo" : canHo.AnhCanHo,
            "NgayTao": canHo.NgayTao
        ]
        
        
//        self.manager.request("https://localhost:5001/CanHo/AddCanHo", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//            .responseJSON { response in
//                print(response)
//        }
        
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/CanHo/AddCanHo", method: .post, parameters: parameters, encoding: JSONEncoding.default).response{ (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let canHoResponse  = CanHo.init(json: json)
                    if let canHoCopy = canHoResponse.copy() as? CanHo{
                        Storage.shared.addOrUpdate([canHoCopy], type: CanHo.self)
                    }
                    Notice.make(type: .Success, content: "Thêm mới căn hộ thành công! ").show()
                    self.requestDichVu_CanHo(IdCanHo: canHoResponse.IdCanHo)
                    self.done?(canHoResponse)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/CanHo/EditCanHo", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let canHoResponse  = CanHo.init(json: json)
                    if let canHoCopy = canHoResponse.copy() as? CanHo{
                        Storage.shared.addOrUpdate([canHoCopy], type: CanHo.self)
                    }
                    self.requestDichVu_CanHo(IdCanHo: canHoResponse.IdCanHo)
                    Notice.make(type: .Success, content: "Sửa mới căn hộ thành công! ").show()
                    self.done?(canHoResponse)

                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        }
    }
    
    
    func requestDichVu_CanHo(IdCanHo: String) {
        var idDichVu: String = ""
        for index in 0..<self.listDichVu.count {
            if let index2 = checkboxGroupDichVu.selectedIds?.firstIndex(where: { $0 == index}) {
                if index == 0 {
                    idDichVu += self.listDichVu[index2].idDichVu
                } else {
                    idDichVu += "," + self.listDichVu[index2].idDichVu
                }

            }
        }
        if idDichVu.isEmpty {
            self.dismiss(animated: true, completion: nil)
            return
        }
        let parameters = ["IdDichVu": idDichVu, "IdCanHo": IdCanHo]
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/CanHo_DichVu/AddOrUpDateListCanHo_DichVu", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let canHoResponse  = CanHo_DichVu.init(json: json)
                    if let canHoCopy = canHoResponse.copy() as? CanHo_DichVu{
                        Storage.shared.addOrUpdate([canHoCopy], type: CanHo_DichVu.self)
                    }
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        
    }
    
    //    func uploadImageToServer() {
    //        manager.upload(multipartFormData: { multipartFormData in
    //            var dataImages: [Data]
    //            for img in self.listImage {
    //                if let img = UIImagePNGRepresentation(img) {
    //                    dataImages.append(img)
    //                }
    //
    //            }
    //
    //            for (data, text) in (dataImages,listAnhCanHo) {
    //                multipartFormData.append(data, withName: "\(text)[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
    //            }
    //        }, to: "https://localhost:5001//CanHo/Upload_Image",
    //
    //           encodingCompletion: { encodingResult in
    //            switch encodingResult {
    //            case .success(let upload, _, _):
    //                upload.responseJSON { response in
    //
    //                }
    //            case .failure(let error):
    //                print(error)
    //            }
    //
    //        })
    //    }
    
    @IBAction func eventChooseImageFromLibrary(_ sender: Any) {
        
        imageVC.delegate = self
        imageVC.sourceType = .photoLibrary
        imageVC.allowsEditing = false
        self.present(imageVC, animated: true, completion: nil)
    }
    @IBAction func huy(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchOutSide(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension AddAndEditCanHoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 200, height: self.collectionViewCanHo.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CanHoImageCollectionViewCell.id, for: indexPath) as? CanHoImageCollectionViewCell
        cell?.imageCanHo.image = listImage[indexPath.row]
        return cell!
    }
    
}

extension AddAndEditCanHoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let imageURL = info[UIImagePickerControllerImageURL] as? URL {
            let imageName = imageURL.lastPathComponent
            canHo?.AnhCanHo = imageName + ","
            listImage.append(image)
            imageVC.dismiss(animated: true, completion: nil)
            collectionViewCanHo.reloadData()
        } else {
            
        }
    }
}
