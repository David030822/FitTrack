using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddSystemContextToConvos : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "SystemContext",
                table: "Conversations",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "SystemContext",
                table: "Conversations");
        }
    }
}
