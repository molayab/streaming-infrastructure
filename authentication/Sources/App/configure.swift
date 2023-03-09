import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("POSTGRES_USER") ?? "",
        password: Environment.get("POSTGRES_PASSWORD") ?? "",
        database: Environment.get("POSTGRES_DB") ?? ""
    ), as: .psql)

    app.migrations.add(CreateTokenModel())
    // try await app.autoMigrate()

    // register routes
    try routes(app)
}
