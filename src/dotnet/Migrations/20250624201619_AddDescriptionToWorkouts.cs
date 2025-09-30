using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddDescriptionToWorkouts : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Description",
                table: "Workouts",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Duration",
                table: "Workouts",
                type: "integer",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Description",
                table: "Workouts");

            migrationBuilder.DropColumn(
                name: "Duration",
                table: "Workouts");
        }
    }
}
