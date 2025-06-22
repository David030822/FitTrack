using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddMealScheduleTitleField : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Title",
                table: "MealSchedules",
                type: "text",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Title",
                table: "MealSchedules");
        }
    }
}
