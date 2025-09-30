using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddStreakTrackingToCaloriesGoals : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "BurnStreak",
                table: "CaloriesGoals",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "IntakeStreak",
                table: "CaloriesGoals",
                type: "integer",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "BurnStreak",
                table: "CaloriesGoals");

            migrationBuilder.DropColumn(
                name: "IntakeStreak",
                table: "CaloriesGoals");
        }
    }
}
