using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class RemoveUserAppDevicesRelation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Users_AppDevices_UDID",
                table: "Users");

            migrationBuilder.DropIndex(
                name: "IX_Users_UDID",
                table: "Users");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_Users_UDID",
                table: "Users",
                column: "UDID",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Users_AppDevices_UDID",
                table: "Users",
                column: "UDID",
                principalTable: "AppDevices",
                principalColumn: "UDID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
