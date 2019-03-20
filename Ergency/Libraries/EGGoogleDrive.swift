//
//  EGGoogleDrive.swift
//  Ergency
//
//  Created by Guduru, Pradeep(AWF) on 1/9/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class EGGoogleDrive {
    
    private let service: GTLRDriveService
    
    init(_ service: GTLRDriveService) {
        self.service = service
    }
}

// MARK: List Files

extension EGGoogleDrive {
    public func listFiles(_ folderID: String? = nil, onCompleted: @escaping (GTLRDrive_FileList?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.fields = "files(mimeType, id, kind, name)"
        query.orderBy = "folder, name"
        if let folderID = folderID {
            query.q = "'\(folderID)' in parents and trashed = false"
        }
        else {
            let root = "(mimeType = 'application/vnd.google-apps.folder' or mimeType = 'image/jpeg' or mimeType = 'image/png') and 'root' in parents and trashed = false"
            query.q = root
        }
        service.executeQuery(query) { (ticket, result, error) in
            onCompleted(result as? GTLRDrive_FileList, error)
        }
    }
}

// MARK: Create Folder

extension EGGoogleDrive {
    public func createFolder(_ folderID: String? = nil, name: String, onCompleted: @escaping (GTLRDrive_File?, Error?) -> ()) {
        let file = GTLRDrive_File()
        file.name = name
        file.mimeType = "application/vnd.google-apps.folder"
        
        let userPermission = GTLRDrive_Permission()
        userPermission.type = "user"
        userPermission.role = "reader"
        userPermission.emailAddress = "eenadu17@gmail.com"
        file.permissions = [userPermission]
        
        if let folderID = folderID  {
            file.parents = [folderID]
        }
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: nil)
        query.fields = "mimeType, id, kind, name"
        
        service.executeQuery(query) { (ticket, folder, error) in
            onCompleted((folder as? GTLRDrive_File), error)
        }
    }
}

// MARK: Upload File

extension EGGoogleDrive {
    public func uploadFile(_ image: UIImage, imageName: String, folderID: String?, onCompleted: @escaping (GTLRDrive_File?, Error?) -> ()) {
        let file = GTLRDrive_File()
        file.name = imageName
        if let folderID = folderID  {
            file.parents = [folderID]
        }
        
        guard let data = image.pngData() else {
            return
        }
        
        let uploadParams = GTLRUploadParameters(data: data, mimeType: "image/png")
        uploadParams.shouldUploadWithSingleRequest = true
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParams)
        query.fields = "id, name"
        
        self.service.executeQuery(query, completionHandler: { (ticket, file, error) in
            onCompleted((file as? GTLRDrive_File), error)
        })
    }
}

//MARK: Download File

extension EGGoogleDrive {
    public func download(_ fileID: String, onCompleted: @escaping (Data?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)
        service.executeQuery(query) { (ticket, file, error) in
            onCompleted((file as? GTLRDataObject)?.data, error)
        }
    }
}

//MARK: Delete File

extension EGGoogleDrive {
    public func delete(_ fileID: String, onCompleted: @escaping (Error?) -> ()) {
        let query = GTLRDriveQuery_FilesDelete.query(withFileId: fileID)
        service.executeQuery(query) { (ticket, nilFile, error) in
            onCompleted(error)
        }
    }
}
