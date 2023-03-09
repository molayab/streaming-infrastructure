import Fluent

struct CreateTokenModel: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("tokens")
            .id()
            .field("token", .string, .required)
            .field("created_at", .datetime, .required)
            .field("expires_at", .datetime, .required)
            .field("ip_used", .string)
            .field("ip_created", .string, .required)
            //.field("user_id", .uuid)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("tokens").delete()
    }
}
