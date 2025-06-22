using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddMealScheduleTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "MealSchedules",
                columns: table => new
                {
                    MealScheduleID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserID = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MealSchedules", x => x.MealScheduleID);
                    table.ForeignKey(
                        name: "FK_MealSchedules_Users_UserID",
                        column: x => x.UserID,
                        principalTable: "Users",
                        principalColumn: "UserID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "MealScheduleDays",
                columns: table => new
                {
                    MealScheduleDayID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    MealScheduleID = table.Column<int>(type: "integer", nullable: false),
                    DayOfWeek = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MealScheduleDays", x => x.MealScheduleDayID);
                    table.ForeignKey(
                        name: "FK_MealScheduleDays_MealSchedules_MealScheduleID",
                        column: x => x.MealScheduleID,
                        principalTable: "MealSchedules",
                        principalColumn: "MealScheduleID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PlannedMeals",
                columns: table => new
                {
                    PlannedMealID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    MealScheduleDayID = table.Column<int>(type: "integer", nullable: false),
                    MealType = table.Column<string>(type: "text", nullable: false),
                    Time = table.Column<TimeOnly>(type: "time without time zone", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: true),
                    Calories = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PlannedMeals", x => x.PlannedMealID);
                    table.ForeignKey(
                        name: "FK_PlannedMeals_MealScheduleDays_MealScheduleDayID",
                        column: x => x.MealScheduleDayID,
                        principalTable: "MealScheduleDays",
                        principalColumn: "MealScheduleDayID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_MealScheduleDays_MealScheduleID",
                table: "MealScheduleDays",
                column: "MealScheduleID");

            migrationBuilder.CreateIndex(
                name: "IX_MealSchedules_UserID",
                table: "MealSchedules",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_PlannedMeals_MealScheduleDayID",
                table: "PlannedMeals",
                column: "MealScheduleDayID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PlannedMeals");

            migrationBuilder.DropTable(
                name: "MealScheduleDays");

            migrationBuilder.DropTable(
                name: "MealSchedules");
        }
    }
}
