using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddAppDevicesAndLogsTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "dateTime",
                table: "Calories",
                newName: "DateTime");

            migrationBuilder.CreateTable(
                name: "AppDevices",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    registered = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    used = table.Column<double>(type: "double precision", nullable: false),
                    lastUsed = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppDevices", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Users_Udid",
                table: "Users",
                column: "Udid",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Users_AppDevices_Udid",
                table: "Users",
                column: "Udid",
                principalTable: "AppDevices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Users_AppDevices_Udid",
                table: "Users");

            migrationBuilder.DropTable(
                name: "AppDevices");

            migrationBuilder.DropIndex(
                name: "IX_Users_Udid",
                table: "Users");

            migrationBuilder.RenameColumn(
                name: "DateTime",
                table: "Calories",
                newName: "dateTime");
        }
    }
}
