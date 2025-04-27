using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddCaloriesGoalsTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CaloriesGoals",
                columns: table => new
                {
                    CaloriesGoalsID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    IntakeGoal = table.Column<double>(type: "double precision", nullable: true),
                    BurnGoal = table.Column<double>(type: "double precision", nullable: true),
                    UserID = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CaloriesGoals", x => x.CaloriesGoalsID);
                    table.ForeignKey(
                        name: "FK_CaloriesGoals_Users_UserID",
                        column: x => x.UserID,
                        principalTable: "Users",
                        principalColumn: "UserID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_CaloriesGoals_UserID",
                table: "CaloriesGoals",
                column: "UserID",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CaloriesGoals");
        }
    }
}
