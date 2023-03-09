import Fluent
import Vapor

final class TokenModel: Model, Content {
    static let schema = "tokens"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "token")
    var token: String

    @Field(key: "expires_at")
    var expiresAt: Date

    @Field(key: "created_at")
    var createdAt: Date

    @Field(key: "ip_used")
    var ipUsed: String

    @Field(key: "ip_created")
    var ipCreated: String

    //@Field(key: "user_id")
    //var user: UUID?

    init() { }

    init(token: String, ipCreated: String) {
        self.token = token
        self.ipCreated = ipCreated
        self.expiresAt = Date().addingTimeInterval(3600)
        self.createdAt = Date()
        self.ipUsed = String()
    }
}
