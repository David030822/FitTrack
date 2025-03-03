using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddWorkoutStepsCaloriesRelations : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_WorkoutCalories",
                table: "WorkoutCalories");

            migrationBuilder.DropIndex(
                name: "IX_WorkoutCalories_CaloriesId",
                table: "WorkoutCalories");

            migrationBuilder.AddPrimaryKey(
                name: "PK_WorkoutCalories",
                table: "WorkoutCalories",
                column: "WorkoutId");

            migrationBuilder.CreateTable(
                name: "Meal",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    CaloriesID = table.Column<int>(type: "integer", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Meal", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Meal_Calories_CaloriesID",
                        column: x => x.CaloriesID,
                        principalTable: "Calories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Steps",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    StepsCount = table.Column<int>(type: "integer", nullable: false),
                    date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    CaloriesId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Steps", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Steps_Calories_CaloriesId",
                        column: x => x.CaloriesId,
                        principalTable: "Calories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_WorkoutCalories_CaloriesId",
                table: "WorkoutCalories",
                column: "CaloriesId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Meal_CaloriesID",
                table: "Meal",
                column: "CaloriesID");

            migrationBuilder.CreateIndex(
                name: "IX_Steps_CaloriesId",
                table: "Steps",
                column: "CaloriesId",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Meal");

            migrationBuilder.DropTable(
                name: "Steps");

            migrationBuilder.DropPrimaryKey(
                name: "PK_WorkoutCalories",
                table: "WorkoutCalories");

            migrationBuilder.DropIndex(
                name: "IX_WorkoutCalories_CaloriesId",
                table: "WorkoutCalories");

            migrationBuilder.AddPrimaryKey(
                name: "PK_WorkoutCalories",
                table: "WorkoutCalories",
                columns: new[] { "WorkoutId", "CaloriesId" });

            migrationBuilder.CreateIndex(
                name: "IX_WorkoutCalories_CaloriesId",
                table: "WorkoutCalories",
                column: "CaloriesId");
        }
    }
}
