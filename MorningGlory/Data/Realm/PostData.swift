//
//  PostData.swift
//  MorningGlory
//
//  Created by 최대성 on 9/23/24.
//

import Foundation
import RealmSwift

final class PostData: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true)var id: ObjectId
    @Persisted var uploadDate: Date
    @Persisted var feeling: String
    
    convenience init(uploadDate: Date, feeling: String) {
        self.init()
        self.uploadDate = uploadDate
        self.feeling = feeling
    }
}

