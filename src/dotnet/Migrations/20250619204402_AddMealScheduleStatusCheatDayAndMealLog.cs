using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddMealScheduleStatusCheatDayAndMealLog : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "MealSchedules",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsCheatDay",
                table: "MealScheduleDays",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.CreateTable(
                name: "MealLog",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    MealId = table.Column<int>(type: "integer", nullable: false),
                    Date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    Status = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MealLog", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MealLog_PlannedMeals_MealId",
                        column: x => x.MealId,
                        principalTable: "PlannedMeals",
                        principalColumn: "PlannedMealID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_MealLog_MealId",
                table: "MealLog",
                column: "MealId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "MealLog");

            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "MealSchedules");

            migrationBuilder.DropColumn(
                name: "IsCheatDay",
                table: "MealScheduleDays");
        }
    }
}
