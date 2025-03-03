using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddAppLogs : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "startDate",
                table: "Workouts",
                newName: "StartDate");

            migrationBuilder.RenameColumn(
                name: "endDate",
                table: "Workouts",
                newName: "EndDate");

            migrationBuilder.RenameColumn(
                name: "icon",
                table: "WorkoutCategories",
                newName: "Icon");

            migrationBuilder.RenameColumn(
                name: "date",
                table: "Steps",
                newName: "Date");

            migrationBuilder.RenameColumn(
                name: "date",
                table: "Heatmap",
                newName: "Date");

            migrationBuilder.RenameColumn(
                name: "date",
                table: "GoalChecked",
                newName: "Date");

            migrationBuilder.RenameColumn(
                name: "used",
                table: "AppDevices",
                newName: "Used");

            migrationBuilder.RenameColumn(
                name: "registered",
                table: "AppDevices",
                newName: "Registered");

            migrationBuilder.RenameColumn(
                name: "lastUsed",
                table: "AppDevices",
                newName: "LastUsed");

            migrationBuilder.CreateTable(
                name: "AppLogs",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    File = table.Column<string>(type: "text", nullable: false),
                    Request = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppLogs", x => x.Id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AppLogs");

            migrationBuilder.RenameColumn(
                name: "StartDate",
                table: "Workouts",
                newName: "startDate");

            migrationBuilder.RenameColumn(
                name: "EndDate",
                table: "Workouts",
                newName: "endDate");

            migrationBuilder.RenameColumn(
                name: "Icon",
                table: "WorkoutCategories",
                newName: "icon");

            migrationBuilder.RenameColumn(
                name: "Date",
                table: "Steps",
                newName: "date");

            migrationBuilder.RenameColumn(
                name: "Date",
                table: "Heatmap",
                newName: "date");

            migrationBuilder.RenameColumn(
                name: "Date",
                table: "GoalChecked",
                newName: "date");

            migrationBuilder.RenameColumn(
                name: "Used",
                table: "AppDevices",
                newName: "used");

            migrationBuilder.RenameColumn(
                name: "Registered",
                table: "AppDevices",
                newName: "registered");

            migrationBuilder.RenameColumn(
                name: "LastUsed",
                table: "AppDevices",
                newName: "lastUsed");
        }
    }
}
