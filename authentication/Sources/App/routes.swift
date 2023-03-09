import Fluent
import Vapor
import CryptoSwift

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.post("live", "connect") { req async throws in
        let authContent = try req.content.decode(Auth.self)

        req.logger.info("Hello, logs! \(authContent.token)")
        req.logger.info("Hello, >>! \(req)")
        req.logger.info("Hello, >>! \(authContent)")

        guard let auth = try? await TokenModel
            .query(on: req.db)
            .filter(\.$token == authContent.token)
            .first() else {
                return HTTPStatus.unauthorized
        }

        if auth.expiresAt < Date() {
            return HTTPStatus.unauthorized
        }

        auth.ipUsed = req.peerAddress?.ipAddress ?? String()
        try? await auth.update(on: req.db)
        
        return HTTPStatus.ok
    }

    app.get("auths") { req async throws -> [TokenModel] in
        return try await TokenModel.query(on: req.db).all()
    }

    app.get("auth", "generate") { req async throws -> TokenModel in
        guard let ip = req.peerAddress?.ipAddress else {
            throw Abort(.badRequest)
        }

        let uuid = UUID().uuidString.sha256()
        let model = TokenModel(token: uuid, ipCreated: ip)
        try await model.create(on: req.db)

        return model
    }

    // try app.register(collection: TodoController())
}

struct Auth: Codable {
    var app: String
    var token: String
    var call: String
}